---@diagnostic disable: missing-fields, unused-local
local M = require("lua-mods-libs.options_module")
local items = M.items
local default = { ---@type Mod_Options_Item
    logLevel = "INFO",
}

--#region
--[[
    This example increases the movement speed of creatures.
]]

local MULT = M.MULT -- we will be able to use MULT instead of M.MULT
local x = 5         -- multiplier

items:insert({
    id = "EXAMPLE",
    className = "/Script/Maine.MaineCharMovementComponent",
    shortClassName = "MaineCharMovementComponent",

    -- If the instance class is NOT "/Script/Maine.SurvivalPlayerCharacter",
    -- then the instance values will be modified.
    -- In other words, the movement speed of players will NOT be changed.
    filters = {
        M.filters.isNotA(
            "/Script/Maine.SurvivalPlayerCharacter",
            function(instance) return instance.CharacterOwner end),
    },
    instances = M.instances.getAllInstances(),
    reapplyOnModRestart = true,

    -- The "pre" and "post" functions will print to the log file (and to the console if enabled)
    -- the property value before and after the change.
    -- This can cause lags and are only used for debugging, so you can delete them.
    pre = {
        function(instance, property, value, item)
            print("[EX] BEFORE " .. property .. " = " .. tostring(instance[property]) .. "\n")
        end
    },
    post = {
        function(instance, property, value, item)
            print("[EX] AFTER " .. property .. " = " .. tostring(instance[property]) .. "\n")
        end
    },
}, {
    -- For each instance found, the MaxWalkSpeed property value will be
    -- multiplied by a random integer between 2 and 5.
    MaxWalkSpeed = MULT(M.CALL(math.random, 2, 5)),
    -- Alternatively, you can use the LOAD function, as below:
    -- MaxWalkSpeed = M.LOAD("return instance[property] * math.random(2, 5)"), -- (do the same thing)

    MaxWalkSpeedCrouched = MULT(x),
    MaxSwimSpeed = MULT(x),
    MaxFlySpeed = MULT(x),
    MaxCustomMovementSpeed = MULT(2),
    MaxAcceleration = MULT(x),
    MaxSprintSpeed = MULT(x),
    MaxFlySprintSpeed = MULT(x),

} --[[@as UMaineCharMovementComponent]])

--#endregion

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = M.loaders._ifPCExists_or_onPCRestart()
}
