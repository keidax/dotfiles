local func = hs.fnutils
local eventTypes = hs.eventtap.event.types

log = hs.logger.new("config", "debug")

function keyIsSynthetic(event)
    local flags = event:getRawEventData().CGEventData.flags
    return (flags & 0x20000000) ~= 0
end

function simultaneousKeyPress(mods, keys, replacement, delay)
    -- Default delay value
    local delay = delay or 0.1

    -- Modifiers that must be pressed together
    local simulMods = mods or {}
    -- Keys that must be pressed together
    local simulKeys = {}
    -- Whether each key has been pressed but a keyDown event not released
    local pendingKeys = {}

    for _, key in ipairs(keys) do
        simulKeys[key] = true
        pendingKeys[key] = false
    end

    -- Key event codes
    local keyDown = hs.eventtap.event.types["keyDown"]
    local keyUp = hs.eventtap.event.types["keyUp"]

    -- If the key is pending release, release it. If a table is provided, append to the table,
    -- otherwise post the event.
    -- Return true if a key was released, false otherwise.
    local function releaseKeyIfPending(keysym, tbl)
        if pendingKeys[keysym] then
            local downEvent = hs.eventtap.event.newKeyEvent(simulMods, keysym, true)
            if tbl == nil then
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
        local released = false
        for key, _ in pairs(pendingKeys) do
            released = releaseKeyIfPending(key, tbl) or released
        end
        return released
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

    local keyEventTap = hs.eventtap.new({keyDown, keyUp}, function(event)
        local keysym = hs.keycodes.map[event:getKeyCode()]
        local isDown = event:getType() == keyDown
        if keyIsSynthetic(event) then
            return false
        end

        local returnKeys = {}
        local shouldDeleteEvent = false
        local shouldDuplicateEvent = false

        if simulKeys[keysym] and event:getFlags():containExactly(simulMods) then
            if isDown then
                pendingKeys[keysym] = true
                hs.timer.doAfter(delay, function () releaseKeyIfPending(keysym) end)
                shouldDeleteEvent = true

                -- Test for substitution
                if allKeysPending() then
                    hs.eventtap.keyStrokes(replacement)
                    cancelAllPendingKeys()
                end
            else -- keyUp
                shouldDuplicateEvent = releaseKeyIfPending(keysym, returnKeys)
            end
        else -- different key or modifiers
            if isDown then
                shouldDuplicateEvent = releaseAllPendingKeys(returnKeys)
            end
        end

        shouldDeleteEvent = shouldDeleteEvent or shouldDuplicateEvent

        if shouldDuplicateEvent then
            local flagList = {}
            for k, _ in pairs(event:getFlags()) do
                table.insert(flagList, k)
            end
            local copyOfEvent = hs.eventtap.event.newKeyEvent(flagList, keysym, isDown)
            table.insert(returnKeys, copyOfEvent)
        end

        -- Seems to be necessary to prevent keystrokes from occasionally disappearing
        hs.timer.usleep(100)
        return shouldDeleteEvent, returnKeys
    end):start()
    return keyEventTap
end

hypenTap = simultaneousKeyPress({}, {"f", "j"}, "-")
underTap = simultaneousKeyPress({}, {"h", "g"}, "_")
