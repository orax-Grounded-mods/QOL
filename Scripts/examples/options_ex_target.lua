---@diagnostic disable: missing-fields, unused-local, unused-function
local M = require("lua-mods-libs.options_module")
local items = M.items
local default = {}

--#region /Script/Maine.SurvivalPlayerCharacter->CharMovementComponent
--[[
    EXAMPLE 1 - simple target
]]
local function example_1()
    -- create an empty table of instances
    local instances = {}
    -- find all non-default instances of "SurvivalPlayerCharacter"
    ---@type ASurvivalPlayerCharacter[]?
    local instancesOfSurvivalPlayerCharacter = FindAllOf("SurvivalPlayerCharacter")
    assert(type(instancesOfSurvivalPlayerCharacter) == "table")
    -- for each instance of SurvivalPlayerCharacter...
    for index, instance in ipairs(instancesOfSurvivalPlayerCharacter) do
        -- ensure that the instance inherits from the expected class
        if instance:IsA("/Script/Maine.SurvivalPlayerCharacter") then
            -- get the "CharMovementComponent" instance from SurvivalPlayerCharacter
            local charMovementComponent = instance.CharMovementComponent
            -- add the "CharMovementComponent" instance in the instances table
            table.insert(instances, charMovementComponent)
        end
    end
    -- return all "CharMovementComponent" instances found
    return instances
end

items:insert({
    --[[
    Find all instances of "SurvivalPlayerCharacter" and get "CharMovementComponent" in those instances.
    The example function "example_1" above does an equivalent thing.
    ]]
    id = "/Script/Maine.SurvivalPlayerCharacter->CharMovementComponent",
    className = "/Script/Maine.SurvivalPlayerCharacter",
    shortClassName = "SurvivalPlayerCharacter",
    target = "instance.CharMovementComponent",
    instances = M.instances.getAllInstances(),
    reapplyOnModRestart = true,
}, {
    ZiplineIgnoreCollisionDistance = 1234, -- 250.0
    ZiplineMaxSpeedMultiplier = 5,         -- 2.5
    ZiplineExitVelocityMultiplier = 0,     -- 0.5
    ZiplineAscendAccel = 6000,             -- 600.0
    ZiplineMaxAscendSpeed = 10000,         -- 1000.0
} --[[@as UMaineCharMovementComponent]])
--#endregion

--#region /Script/Maine.Default__SurvivalGameplayStatics
--[[
    EXAMPLE 2 - target with variables (targetVars)
]]
local function example_2()
    -- import UEHelpers library
    local UEHelpers = require("UEHelpers")
    -- get Default__SurvivalGameplayStatics (it is a CDO: Class Default Object)
    ---@type USurvivalGameplayStatics
    ---@diagnostic disable-next-line: assign-type-mismatch
    local instance = StaticFindObject("/Script/Maine.Default__SurvivalGameplayStatics")
    -- call "GetGameViewportClient" from the UEHelpers library
    local gameViewportClient = UEHelpers.GetGameViewportClient()
    -- call the "GetLocalSurvivalPlayerState" method on "Default__SurvivalGameplayStatics"
    local localSurvivalPlayerState = instance:GetLocalSurvivalPlayerState(gameViewportClient)
    -- return the "localSurvivalPlayerState" instance in a table
    return { localSurvivalPlayerState }
end

items:insert({
    --[[
    Find the CDO (Class Default Object) "Default__SurvivalGameplayStatics"
    and call "GetLocalSurvivalPlayerState" on it to get an instance of "SurvivalPlayerState".
    The example function "example_2" above does an equivalent thing.
    ]]
    id = "/Script/Maine.Default__SurvivalGameplayStatics",
    className = "/Script/Maine.Default__SurvivalGameplayStatics",
    target = [[instance:GetLocalSurvivalPlayerState(UEHelpers.GetGameViewportClient())]],
    instances = M.instances.getStaticObject(),
    targetVars = { UEHelpers = M.UEHelpers },
    reapplyOnModRestart = true,
}, {
    ColorSelection = 2, -- it seems to be the color of your waypoints on the map
} --[[@as ASurvivalPlayerState]])
--#endregion

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = M.loaders._ifPCExists_or_onPCRestart()
}
