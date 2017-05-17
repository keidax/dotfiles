-- Eventtaps to simulate some Karabiner functionality

local eventtap = hs.eventtap
local event = eventtap.event
local func = hs.fnutils
local types = event.types
local properties = event.properties
local keyCodes = hs.keycodes.map

local log = hs.logger.new("keys", "debug")

local function keyIsSynthetic(evt)
    local flags = evt:getRawEventData().CGEventData.flags
    return (flags & 0x20000000) ~= 0
end

local function simultaneousKeyPress(mods, keys, replacement, options)
    local options = options or {}

    -- Default delay value
    local delay = options.delay or 0.1

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

    -- If the key is pending release, release it. If a table is provided, append to the table,
    -- otherwise post the event.
    -- Return true if a key was released, false otherwise.
    local function releaseKeyIfPending(keysym, tbl)
        if pendingKeys[keysym] then
            local downEvent = event.newKeyEvent(simulMods, keysym, true)
            if tbl == nil then
                hs.timer.usleep(100)
                downEvent:post()
                hs.timer.usleep(100)
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

    local keyEventTap = eventtap.new({types.keyDown, types.keyUp}, function(evt)
        local keysym = keyCodes[evt:getKeyCode()]
        local isDown = evt:getType() == types.keyDown
        if keyIsSynthetic(evt) then
            return false
        end

        local returnKeys = {}
        local shouldDeleteEvent = false
        local shouldDuplicateEvent = false

        if simulKeys[keysym] and evt:getFlags():containExactly(simulMods) then
            if isDown then
                pendingKeys[keysym] = true
                hs.timer.doAfter(delay, function ()
                    releaseKeyIfPending(keysym)
                end)
                shouldDeleteEvent = true

                -- Test for substitution
                if allKeysPending() then
                    eventtap.keyStrokes(replacement)
                    cancelAllPendingKeys()
                end
            else -- keyUp
                shouldDuplicateEvent = releaseKeyIfPending(keysym, returnKeys)
                shouldDuplicateEvent = true
            end
        else -- different key or modifiers
            if isDown then
                shouldDuplicateEvent = releaseAllPendingKeys(returnKeys)
            end
        end

        shouldDeleteEvent = shouldDeleteEvent or shouldDuplicateEvent

        if shouldDuplicateEvent then
            local flagList = {}
            for k, _ in pairs(evt:getFlags()) do
                table.insert(flagList, k)
            end
            local copyOfEvent = event.newKeyEvent(flagList, keysym, isDown)
            table.insert(returnKeys, copyOfEvent)
        end

        if not isDown then
            shouldDeleteEvent = false
        end

        -- Seems to be necessary to prevent keystrokes from occasionally disappearing
        hs.timer.usleep(1000)
        return shouldDeleteEvent, returnKeys
    end):start()
    return keyEventTap
end

return {
    simultaneousKeyPress = simultaneousKeyPress
}
