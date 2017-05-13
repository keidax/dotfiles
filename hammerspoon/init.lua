log = hs.logger.new("config", "debug")

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

    -- Declare eventtap beore initialization
    local keyEventTap

    local function passThroughKeyEvent(evt)
        keyEventTap:stop()
        evt:post()
        keyEventTap:start()
    end

    -- If the key is pending release, release it
    local function releaseKeyIfPending(keysym)
        if pendingKeys[keysym] then
            local downEvent = hs.eventtap.event.newKeyEvent(simulMods, keysym, true)
            passThroughKeyEvent(downEvent)
            pendingKeys[keysym] = false
        end
    end

    -- Release all pending keys and reset pending state
    local function releaseAllPendingKeys()
        for key, _ in pairs(pendingKeys) do
            releaseKeyIfPending(key)
        end
    end

    -- Reset pending state without releasing keys
    local function cancelAllPendingKeys()
        for key, _ in pairs(pendingKeys) do
            pendingKeys[key] = false
        end
    end

    -- Return true if all keys are pending release
    local function allKeysPending()
        local pendingAll = true
        for _, isPending in pairs(pendingKeys) do
            pendingAll = pendingAll and isPending
        end
        return pendingAll
    end

    keyEventTap = hs.eventtap.new({keyDown, keyUp}, function(evt)
        local keysym = hs.keycodes.map[evt:getKeyCode()]
        local isDown = evt:getType() == keyDown

        local shouldDeleteEvent = false

        if simulKeys[keysym] and evt:getFlags():containExactly(simulMods) then
            log.d("got " .. keysym .. (isDown and " down" or " up"))
            if isDown then
                pendingKeys[keysym] = true
                hs.timer.doAfter(delay, function () releaseKeyIfPending(keysym) end)
                shouldDeleteEvent = true

                -- Test for substitution
                if allKeysPending() then
                    -- log.d("All keys down!")
                    hs.eventtap.keyStrokes(replacement)
                    cancelAllPendingKeys()
                    -- print_r(pendingKeys)
                end
            else -- keyUp
                releaseKeyIfPending(keysym)
            end
            log.d((shouldDelete and "not " or "") .. "posting")
        else -- different key or modifiers
            if isDown then
                releaseAllPendingKeys()
            end
        end

        return shouldDeleteEvent
    end):start()
    return keyEventTap
end

hypenTap = simultaneousKeyPress({}, {"f", "j"}, "-")
underTap = simultaneousKeyPress({}, {"h", "g"}, "_")
