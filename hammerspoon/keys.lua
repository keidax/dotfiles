--- Eventtaps to simulate some Karabiner functionality
-- @module keys

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

local function keyEventToString(evt)
    local str = ""
    if eventHasFlag(evt, eventFlags.ignoreFlag) then
        str = "FAKE "
    end
    for mod, _ in pairs(evt:getFlags()) do
        str = str .. mod .. " + "
    end
    str = str .. keyCodes[evt:getKeyCode()] .. (evt:getType() == types.keyDown and " down" or " up")
    return str
end

--- Several keys pressed together to generate a different key.
-- @function simultaneousKeyPress
-- @param mods modifiers to be pressed together
-- @param keys keys to be pressed together
-- @param replacement replacement keys, passed to `hs.eventtap.keyStrokes()`
-- @param[opt] options table of optional arguments
-- @param[opt=0.1] options.delay the delay in which all keys must be pressed
-- @param[opt=false] options.repeat whether to repeat the replacement if the keys are held down
-- @return the eventtap object controlling key replacement, already active
-- @usage underTap = keys.simultaneousKeyPress({}, {"h", "g"}, "_", {delay=0.05})
local function simultaneousKeyPress(mods, keys, replacement, options)
    options = options or {}
    -- DEBUG
    local keyTapTitle = "<" .. keys[1] .. " " .. keys[2] .. " tap>"
    log.d(keyTapTitle .. " initialized")

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
                -- timer.usleep(100)
                eventAddFlag(downEvent, eventFlags.ignoreFlag) -- TODO: necessary?
                log.d(keyTapTitle .. " posting event " .. keyEventToString(downEvent))
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
            log.d(keyTapTitle .. " ignoring event " .. keyEventToString(evt))
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
                elseif evt:getProperty(properties.keyboardEventAutorepeat) == 0 then
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
                else
                    -- This is an autorepeating event -- just send it through. We do want to
                    -- turn off the timerFired flag, so that the keyUp after a series of
                    -- repeating keyDowns doesn't get posted.
                    -- TODO: check if timer is still pending?
                    -- TODO: add option for autorepeating substitution
                    timerFiredForKey[keysym] = false
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
            log.d(keyTapTitle .. " duplicated " .. keyEventToString(evt))
        end

        for _, e in ipairs(returnKeys) do
            log.d(keyTapTitle .. " returning " .. keyEventToString(e))
        end

        if shouldDeleteEvent then
            log.d(keyTapTitle .. " deleting " .. keyEventToString(evt))
        else
            log.d(keyTapTitle .. " returning " .. keyEventToString(evt))
        end

        -- Seems to be necessary to prevent keystrokes from occasionally disappearing
        timer.usleep(100)
        return shouldDeleteEvent, returnKeys
    end):start()
    return keyEventTap
end

-- Modified from
-- https://gist.github.com/rjhilgefort/07ce5cdd3832083d7e94113d54372b1c
-- and
-- https://gist.github.com/otijhuis/6bdbfaa25a8e3773f4c13ba2fe2ab5d1
local function overlayModifier(mod, replacement, options)
    options = options or {}
    local delay = options.delay or 0.1

    local sendReplace = false
    local modKeyTimer = timer.delayed.new(delay, function()
        sendReplace = false
    end)

    local flagClass = {
        shift       = "shift",
        rightshift  = "shift",
        ctrl        = "ctrl",
        rightctrl   = "ctrl",
        alt         = "alt",
        rightalt    = "alt",
        cmd         = "cmd",
        rightcmd    = "cmd",
        fn          = "fn"
    }
    local simpleFlag = flagClass[mod]

    local lastMods = {}

    local keyEventTap

    local function passThroughKeyEvent(evt)
        keyEventTap:stop()
        evt:post()
        keyEventTap:start()
    end


    local flagsChangedHandler = function(evt)
        local newMods = evt:getFlags()

        -- Only match the specific modifier key
        if mod ~= hs.keycodes.map[evt:getKeyCode()] then return false end

        -- This modifer was not changed
        if lastMods[simpleFlag] == newMods[simpleFlag] then return false end

        -- This modifer was pressed
        if newMods[simpleFlag] then
            sendReplace = true
            modKeyTimer:start()
        else -- This modifier was released
            if sendReplace then hs.eventtap.keyStroke({}, replacement, 10000) end
            modKeyTimer:stop()
        end

        lastMods = newMods
        return false
    end

    local keyDownHandler = function(evt)
        -- Cancel any replacement if a normal key is pressed
        sendReplace = false
        return false
    end

    keyEventTap = hs.eventtap.new({types.flagsChanged, types.keyDown}, function(evt)
        if evt:getType() == types.flagChanged then
            flagsChangedHandler(evt)
        elseif evt:getType() == types.keyDown then
            keyDownHandler(evt)
        end
    end):start()
    return keyEventTap
end

-- local debugTap = hs.eventtap.new({10, 11, 12}, function(e)
--     inspect(e:getRawEventData().NSEventData)
-- end):start()

-------------------
-- J TIMER STUFF --
-------------------
local jDown = false
local jPosted = false
local keyUp = hs.eventtap.event.types["keyUp"]
local keyDown = hs.eventtap.event.types["keyDown"]

local jStartTimer = nil
local jDelayTimer = nil
local jIntervalTimer = nil

jStartTimer = timer.doAfter(0.1, function()
    if jDown then
        log.d("posting j down from jStartTimer")
        hs.eventtap.event.newKeyEvent({}, "j", true):post()
        jPosted = true
        jDelayTimer:start()
    end
end):stop()

jDelayTimer = timer.doAfter(hs.eventtap.keyRepeatDelay(), function()
    if jDown then
        log.d("posting j down repeat from jDelayTimer")
        hs.eventtap.event.newKeyEvent({}, "j", true):setProperty(hs.eventtap.event.properties.keyboardEventAutorepeat, 1):post()
        jIntervalTimer:start()
    end
end):stop()

jIntervalTimer = timer.doEvery(hs.eventtap.keyRepeatInterval(), function()
    if jDown then
        log.d("posting j down repeat from jIntervalTimer")
        hs.eventtap.event.newKeyEvent({}, "j", true):setProperty(hs.eventtap.event.properties.keyboardEventAutorepeat, 1):post()
    else
        jIntervalTimer:stop()
    end
end):stop()

local function stopAllTimers()
    jStartTimer:stop()
    jDelayTimer:stop()
    jIntervalTimer:stop()
end

local keyEventTap = hs.eventtap.new({keyUp, keyDown}, function(event)
    local keysym = hs.keycodes.map[event:getKeyCode()]
    local isDown = event:getType() == keyDown
    local raw_flags = event:getRawEventData().CGEventData.flags
    if (raw_flags & 0x20000000) ~= 0 then
        log.d("skipping fake "..keysym .." "..(isDown and "down" or "up"))
        return false
    end

    local shouldDeleteEvent = false

    if keysym == "j" and event:getFlags():containExactly({}) then
        if event:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) ~= 0 then
            log.d("skipping repeating j down")
            return true
        end
        log.d("got j ".. (isDown and "down" or "up"))
        if isDown then
            jDown = true
            jPosted = false
            stopAllTimers()
            log.d("starting timer sequence")
            jStartTimer:start()

            shouldDeleteEvent = true
        else -- keyUp
            jDown = false
            stopAllTimers()
            if not jPosted then
                log.d("posting j down before up")
                hs.eventtap.event.newKeyEvent({}, "j", true):post()
            end
            log.d("posting j up")
            hs.eventtap.event.newKeyEvent({}, "j", false):post()

            shouldDeleteEvent = true
        end
    else -- different key or modifiers
        log.d("got "..keysym)
        if isDown then
            stopAllTimers()
            if jDown and not jPosted then
                log.d("posting j down from other key")
                hs.eventtap.event.newKeyEvent({}, "j", true):post()
                jPosted = true
            end
        end
    end

    timer.usleep(1000)
    return shouldDeleteEvent
end):stop()

-- with none:   0x00000100
-- with l_cmd:  0x00100108
-- with r_cmd:  0x00100110
-- with l_opt:  0x00080120
-- with r_opt:  0x00080140
-- with l_ctl:  0x00040101
-- with r_ctl:  0x00042100
-- with l_shft: 0x00020102
-- with r_shft: 0x00020104
--
-- fake: 0x20000000

return {
    simultaneousKeyPress = simultaneousKeyPress
}
