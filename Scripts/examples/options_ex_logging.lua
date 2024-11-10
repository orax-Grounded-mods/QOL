---@diagnostic disable: missing-fields, unused-local
local M = require("lua-mods-libs.options_module")
local items = M.items
local default = {
    className = "/Script/Maine.SurvivalPlayerCharacter",
    shortClassName = "SurvivalPlayerCharacter",
    instances = M.instances.getAllInstances(),
    reapplyOnModRestart = true,
}

--[[
    [*] means the message will be displayed.
    [ ] means the message will NOT be displayed.
]]

--#region EXAMPLE 1
items:insert({
    id = "EXAMPLE 1",
    logLevel = "TRACE", -- ALL TRACE DEBUG INFO WARN ERROR FATAL OFF
    logLevelForFatalError = "OFF",
    post = {
        function()
            M.log.trace("[EX1] trace") -- [*]
            M.log.debug("[EX1] debug") -- [*]
            M.log.info("[EX1] info")   -- [*]
            M.log.warn("[EX1] warn")   -- [*]
            M.log.error("[EX1] error") -- [*]
            M.log.fatal("[EX1] fatal") -- [*]
        end,
    }
}, {
    JumpMaxCount = 10,
} --[[@as ASurvivalPlayerCharacter]])
--#endregion


--#region EXAMPLE 2
items:insert({
    logLevel = "WARN", -- ALL TRACE DEBUG INFO WARN ERROR FATAL OFF
    logLevelForFatalError = "OFF",
    post = {
        function()
            M.log.trace("[EX2] trace") -- [ ]
            M.log.debug("[EX2] debug") -- [ ]
            M.log.info("[EX2] info")   -- [ ]
            M.log.warn("[EX2] warn")   -- [*]
            M.log.error("[EX2] error") -- [*]
            M.log.fatal("[EX2] fatal") -- [*]
        end
    }
}, {
    JumpMaxCount = 10
} --[[@as ASurvivalPlayerCharacter]])
--#endregion

--#region EXAMPLE 3
items:insert({
    logLevel = "WARN", -- ALL TRACE DEBUG INFO WARN ERROR FATAL OFF
    -- The minimum logging level for fatal errors is now ERROR.
    logLevelForFatalError = "ERROR",
    post = {
        function()
            M.log.trace("[EX3] trace") -- [ ]
            M.log.debug("[EX3] debug") -- [ ]
            M.log.info("[EX3] info")   -- [ ]
            M.log.warn("[EX3] warn")   -- [*]
            M.log.error("[EX3] error") -- [*] will display a fatal error
            M.log.fatal("[EX3] fatal") -- [ ]
        end
    }
}, {
    JumpMaxCount = 10
} --[[@as ASurvivalPlayerCharacter]])
--#endregion

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = M.loaders._ifPCExists_or_onPCRestart(),
}
