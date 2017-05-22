-- Eventtaps to simulate some Karabiner functionality

local eventtap = hs.eventtap
local event = eventtap.event
local func = hs.fnutils
local types = event.types
local properties = event.properties
local keyCodes = hs.keycodes.map
local inspect = hs.inspect
local timer = hs.timer

log = hs.logger.new("keys", "info")

local eventFlags = {
    ignoreFlag  = 0x00010000,
    timerFlag   = 0x00020000,
}

local function flagMatch(value, flag)
    if type(flag) == "string" then
        flag = eventFlags[flag]
    end
    return (value & flag) ~= 0
end

local function eventHasFlag(evt, flag)
    local userData = evt:getProperty(properties.eventSourceUserData)
    return flagMatch(userData, flag)
end

local function eventAddFlag(evt, flag)
    local userData = evt:getProperty(properties.eventSourceUserData)
    userData = userData | flag
    return evt:setProperty(properties.eventSourceUserData, userData)
end

local function simultaneousKeyPress(mods, keys, replacement, options)
    options = options or {}

    -- Default delay value
    local delay = options.delay or 0.1

    -- Modifiers that must be pressed together
    local simulMods = mods or {}
    -- Keys that must be pressed together
    local simulKeys = {}
    -- Whether each key has been pressed but a keyDown event not released
    local pendingKeys = {}
    -- Store delay timers for each key
    local keyTimers = {}
    -- Remember which keyUp events need to be `post`ed
    local timerFiredForKey = {}

    -- Our timer posts a new keydown event for the keysym, without turning off the pendingKeys
    -- entry. This allows our eventtap handler to treat timer-flagged events differently. We
    -- need this workaround to avoid a race condition that may occur if the timer fires while
    -- a different keyDown event is being handled by the eventtaps.
    local function timerForKey(keysym)
        return timer.doAfter(delay, function ()
            if pendingKeys[keysym] then
                log.d(keysym .. " timer triggered")
                local evt = event.newKeyEvent(simulMods, keysym, true)
                eventAddFlag(evt, eventFlags.timerFlag)
                evt:post()
                timerFiredForKey[keysym] = true
            end
        end):stop()
    end

    for _, key in ipairs(keys) do
        simulKeys[key] = true
        pendingKeys[key] = false
        keyTimers[key] = timerForKey(key)
        timerFiredForKey[key] = false
    end

    local function createKeyEvent(keysym, isDown)
        if isDown == nil then isDown = true end

        local keyEvent = event.newKeyEvent(simulMods, keysym, isDown)
        return keyEvent
    end

    -- If the key is pending release, release it. If a table is provided, append to the table,
    -- otherwise post the event.
    -- Return true if a key was released/appended, false otherwise.
    local function releaseKeyIfPending(keysym, tbl)
        if pendingKeys[keysym] then
            local downEvent = createKeyEvent(keysym)
            if tbl == nil  then
                eventAddFlag(downEvent, eventFlags.ignoreFlag) -- TODO: necessary?
                downEvent:post()
            else
                table.insert(tbl, downEvent)
            end
            pendingKeys[keysym] = false

            return true
        end
        return false
    end

    -- Release all pending keys and reset pending state.
    -- Return true if any keys were released, false otherwise.
    local function releaseAllPendingKeys(tbl)
        local anyReleased = false
        for key, _ in pairs(pendingKeys) do
            anyReleased = releaseKeyIfPending(key, tbl) or anyReleased
        end
        return anyReleased
    end

    -- Reset pending state without releasing keys
    local function cancelAllPendingKeys()
        for key, _ in pairs(pendingKeys) do
            pendingKeys[key] = false
        end
    end

    -- Return true if all keys are pending release
    local function allKeysPending()
        return func.every(pendingKeys, function(isPending)
            return isPending
        end)
    end

    local keyEventTap = eventtap.new({types.keyDown, types.keyUp}, function(evt)
        local keysym = keyCodes[evt:getKeyCode()]
        local isDown = evt:getType() == types.keyDown
        -- Simply ignore any events with the ignoreFlag set.
        if eventHasFlag(evt, eventFlags.ignoreFlag) then
            return false
        end

        local returnKeys = {}
        local shouldDeleteEvent = false
        local shouldDuplicateEvent = false

        if simulKeys[keysym] and evt:getFlags():containExactly(simulMods) then
            if isDown then
                if eventHasFlag(evt, eventFlags.timerFlag) then
                    if pendingKeys[keysym] then
                        -- If this event has been fired from a timer, we don't want to start
                        -- _another_ timer, so we'll pass it through and mark it as completed.
                        pendingKeys[keysym] = false
                    else
                        -- If this event is coming from a timer, but the key is no longer
                        -- pending, then another keyEvent must have already been in the
                        -- stream. In this case, we can just delete this event.
                        shouldDeleteEvent = true
                        timerFiredForKey[keysym] = false
                    end
                else
                    -- If this event is raw from the user, we need a slight delay to check for
                    -- the other "simultaneous" events. So, we delete this event, and start a
                    -- timer that will fire if the user doesn't press another key.
                    pendingKeys[keysym] = true
                    timerFiredForKey[keysym] = false
                    keyTimers[keysym]:start()
                    shouldDeleteEvent = true

                    -- Test for substitution
                    if allKeysPending() then
                        eventtap.keyStrokes(replacement)
                        cancelAllPendingKeys()
                    end
                end
            else -- keyUp
                -- We have to generate an up event using the same method as the down event.
                if releaseKeyIfPending(keysym, returnKeys) then
                    -- If we just released the key, that means the timer did not fire and no
                    -- other key was pressed. So, we'll just return an artifical keyUp
                    -- TODO: is this necessary? Seems to work fine without.
                    shouldDuplicateEvent = true
                elseif timerFiredForKey[keysym] then
                    -- The key wasn't pending, but the timer was fired, so we want to generate
                    -- the keyUp the same way, via post
                    timerFiredForKey[keysym] = false
                    shouldDeleteEvent = true
                    local upEvent = createKeyEvent(keysym, false)
                    -- We don't need to see this event again, so add the ignore flag
                    eventAddFlag(upEvent, eventFlags.ignoreFlag):post()
                else
                    -- The key wasn't pending, and the timer didn't go off either. This means
                    -- a different keyDown event must have triggered this key. So, we'll just
                    -- return an artificial keyUp.
                    -- TODO: is this necessary? Seems to work fine without.
                    shouldDuplicateEvent = true
                end
            end
        else -- different key or modifiers
            if isDown then
                -- If any keys get released, we have to send the current event again.
                -- Otherwise, the current event will finish propagating through the various
                -- eventtaps before the downEvent(s) we are releasing.
                if releaseAllPendingKeys(returnKeys) then
                    if eventHasFlag(evt, eventFlags.timerFlag) then
                        -- If we released some keys but we are handling an outside event fired
                        -- by a timer, then the outside timer fired before our own timer. We
                        -- should let that event go first, so we add it to the beginning of the
                        -- table.
                        table.insert(returnKeys, 1, evt)
                        shouldDeleteEvent = true
                    else
                        -- TODO: is this necessary? Seems to work fine without.
                        -- shouldDuplicateEvent = true
                    end
                end
            end
        end

        shouldDeleteEvent = shouldDeleteEvent or shouldDuplicateEvent

        if shouldDuplicateEvent then
            local flagList = {}
            for k, _ in pairs(evt:getFlags()) do
                table.insert(flagList, k)
            end
            local copyOfEvent = event.newKeyEvent(flagList, keysym, isDown)
            eventAddFlag(copyOfEvent, eventFlags.ignoreFlag)
            table.insert(returnKeys, copyOfEvent)
        end

        -- Seems to be necessary to prevent keystrokes from occasionally disappearing
        timer.usleep(100)
        return shouldDeleteEvent, returnKeys
    end):start()
    return keyEventTap
end

return {
    simultaneousKeyPress = simultaneousKeyPress
}
