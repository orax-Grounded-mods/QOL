---@diagnostic disable: missing-fields
local M = require("lua-mods-libs.options_module")
local items = M.items
local default = { ---@type Mod_Options_Item
    instances = M.instances.getAllInstances(),
    pre = { M.pre.checkPropertyValidity() },
    post = { M.post.checkPropertyValueChange(0.01) },
    reapplyOnModRestart = true,
    minNumberOfInstancesToFind = 1,
    logLevelForFatalError = "ERROR",
    epsilon = 0.01
}

--#region SurvivalPlayerCharacter
items:insert({
    id = "/Script/Maine.SurvivalPlayerCharacter",
    className = "/Script/Maine.SurvivalPlayerCharacter",
    shortClassName = "SurvivalPlayerCharacter",
}, {
    InteractTimerMax = 0.6,                  -- 0.6,
    DropInteractTimerMax = 0.6,              -- 0.6,
    CancelInteractTimerMax = 1,              -- 1.0,
    InteractTraceLength = 300,               -- 300.0, | Distance at which you can interact,
    BuildModeInteractionRangeMultiplier = 4, -- 4.0 | Multiplier of the distance at which you can build,

    CharMovementComponent = {
        -- Player movement speed --,
        MaxWalkSpeed = 350,       -- 350.0,
        MaxSprintSpeed = 600,     -- 600.0,
        MaxSwimSpeed = 330,       -- 330.0,
        MaxSwimSprintSpeed = 500, -- 500.0,

        Mass = 100,               -- 100.0,
        GravityScale = 1,         -- 1.0,

        -- Zipline
        --   https://grounded.fandom.com/wiki/Zipline_Anchor
        --   /!\ You might need the "ZIP.R" if it doesn't work. --,
        ZiplineIgnoreCollisionDistance = 250, -- 250.0,
        ZiplineMaxSpeedMultiplier = 2.5,      -- 2.5,
        ZiplineExitVelocityMultiplier = 0.5,  -- 0.5,
        ZiplineAscendAccel = 600,             -- 600.0,
        ZiplineMaxAscendSpeed = 1000,         -- 1000.0,
    },

    -- Block --,
    BlockComponent = {
        PerfectBlockWindow = 0.25, -- 0.25,
    },

    -- Hauling --,
    HaulingComponent = {
        Capacity = 5, -- 5,
    },

    -- Storage radius --,
    ProximityInventoryComponent = {
        StorageRadius = 2000,               -- 2000.0,
        TypeRestrictedStorageRadius = 4000, -- 4000.0,
    }
} --[[@as ASurvivalPlayerCharacter]])
--#endregion

--#region Handy Gnat movement
items:insert({
    id = "HandyGnatMovement",
    className = "/Script/Maine.BuilderMovementComponent",
    shortClassName = "BuilderMovementComponent",
    minNumberOfInstancesToFind = 0,
}, {
    MaxFlySpeed = 1200,               -- 1200.0,
    MaxAcceleration = 2048,           -- 2048.0,
    BrakingFrictionFactor = 2,        -- 2.0,
    BrakingFriction = 0,              -- 0.0,
    BrakingSubStepTime = 0.03,        -- 0.03,
    BrakingDecelerationFlying = 1000, -- 1000.0,
} --[[@as UBuilderMovementComponent]])
--#endregion

--#region Bird (Crow)
items:insert({
    id = "Bird",
    className = "/Script/Maine.Bird",
    shortClassName = "Bird",
}, {
    FlySpeed = 20000,                 -- 20000.0,
    LandedTime = {
        LowerBound = { Value = 120 }, -- 120.0 | Landed time (min),
        UpperBound = { Value = 300 }  -- 300.0 | Landed time (max),
    },
    TimeBetweenSpawns = {
        LowerBound = { Value = 400 }, -- 400.0 | Time between spawns (min),
        UpperBound = { Value = 800 }  -- 800.0 | Time between spawns (max),
    },
} --[[@as ABird]])
--#endregion

--#region GlobalItemData
items:insert({
    id = "GlobalItemData",
    className = "/Script/Maine.GlobalItemData",
    shortClassName = "GlobalItemData",
}, {
    -- Stack --,
    ItemStackBonusPerTier = 5, -- 5,
    MaxItemStackTier = 5,      -- 5,
    MaxDropStackSize = 35,     -- 35,
    -- "StackSizes" is a "MapProperty".
    -- Actually, in UE4SS 3.0.1, the property type "MapProperty" is not supported.
    -- But you can use "IMPORT_TEXT" to change the property value.
    StackSizes = M.IMPORT_TEXT(
        [[(((TagName="StackSize.Default"), 123),((TagName="StackSize.Ammo"), 456),((TagName="StackSize.Single"), 1),((TagName="StackSize.Food"), 789),((TagName="StackSize.Resource"), 10),((TagName="StackSize.LargeResource"), 5),((TagName="StackSize.UpgradeStones"), 99))]]),

    -- Production speed --,
    ProcessingData = {
        -- Cooking
        { ProcessingTime = 0.25 }, -- 0.25,
        -- Drying
        { ProcessingTime = 8 },    -- 8.0,
        -- Spinning
        { ProcessingTime = 1.2 },  -- 1.2,
        -- Smelting
        { ProcessingTime = 1.0 },  -- 1.0,
        -- Refining
        { ProcessingTime = 0.5 },  -- 0.5,
    },

    -- Durability --,
    AttackDurability = 1,   -- 1.0,
    BlockDurability = 1,    -- 1.0,
    ThrowDurability = 1,    -- 1.0,
    ArmorHitDurability = 1, -- 1.0,

    ItemUseCooldown = 4,    -- 4.0,
} --[[@as UGlobalItemData]])
--#endregion

--#region Bounce Web (trampoline)
items:insert({
    id = "BounceWeb",
    className = "/Game/Design/CustomizablePropertyData/TrampolineCustomProperties.TrampolineCustomProperties",
    instances = M.instances.getStaticObject(),
}, {
    CustomProperties = {
        -- BounceIntensity --,
        {
            DefaultValue = 1.0,      -- 1.0,
            SliderMinValue = 0.5,    -- 0.5,
            SliderMaxValue = 1.0,    -- 1.0,
            SliderStepSize = 0.05,   -- 0.05,
            ValueFormat = 1,         -- 1 | Valid values: 0 (plain number), 1 (percent),
            MaxIntegralDigits = 3,   -- 3,
            MinFractionalDigits = 1, -- 1,
            MaxFractionalDigits = 1, -- 1,
        },
        -- Angle --,
        {
            DefaultValue = 0,        -- 0.0,
            SliderMinValue = -45,    -- -45.0,
            SliderMaxValue = 45,     -- 45.0,
            SliderStepSize = 10,     -- 10.0,
            MaxIntegralDigits = 3,   -- 3,
            MinFractionalDigits = 1, -- 1,
            MaxFractionalDigits = 1, -- 1,
        },
    },
} --[[@as UCustomPropertyDataAsset]])

--#region GameModeSettings
items:insert({
    id = "SurvivalGameplayStatics->SurvivalModeManagerComponent->GetGameModeSettings",
    className = "/Script/Maine.Default__SurvivalGameplayStatics",
    -- The injected UEHelpers library from targetVars will be available in the target. --,
    target = "instance:GetSurvivalGameModeManager(UEHelpers.GetGameViewportClient()):GetGameModeSettings()",
    -- It will inject UEHelpers lib as variable. --,
    targetVars = { UEHelpers = M.UEHelpers },
    instances = M.instances.getStaticObject(),
}, {
    HungerMultiplier = 1,                       -- 1.0,
    ThirstMultiplier = 1,                       -- 1.0,
    PlayerDamageMultiplier = 1,                 -- 1.0,
    EnemyDamageMultiplier = 1,                  -- 1.0,
    BuildingHealthMultiplier = 1,               -- 1.0,
    HeatMultiplier = 1,                         -- 1.0,
    ItemSpoilageMultiplier = 1,                 -- 1.0,
    ItemDurabilityMultiplier = 1,               -- 1.0,
    ItemDurabilityPenaltyOnDeathPercentage = 1, -- 1.0,
    SizzleMultiplier = 0.1,                     -- 0.1,
} --[[@as USurvivalGameModeSettings]])
--#endregion

--#region GlobalBuildingData
items:insert({
    id = "SurvivalGameplayStatics->GlobalBuildingData",
    className = "/Script/Maine.Default__SurvivalGameplayStatics",
    target = "instance:GetGlobalBuildingData()",
    instances = M.instances.getStaticObject(),
}, {
    -- Coziness --,
    CozinessLevels = {
        { RequiredValue = 500, },  -- 500,
        { RequiredValue = 1000, }, -- 1000,
        { RequiredValue = 1500, }, -- 1500,
        { RequiredValue = 2000, }, -- 2000,
        { RequiredValue = 3000, }, -- 3000,
    },
    CozinessCheckRadius = 2000,    -- 2000,
} --[[@as UGlobalBuildingData]])
--#endregion

--#region SurvivalGameState
items:insert({
    id = "/Script/Maine.Default__SurvivalGameplayStatics->SurvivalGameState",
    className = "/Script/Maine.Default__SurvivalGameplayStatics",
    target = "instance:GetSurvivalGameState(UEHelpers.GetGameViewportClient())",
    instances = M.instances.getStaticObject(),
    targetVars = { UEHelpers = M.UEHelpers },
}, {
    -- Calendar --,
    CalendarComponent = {
        GameToRealTimeRatio = 30, -- 30,
    }
} --[[@as ABP_SurvivalGameState_C]])
--#endregion

--#region Storages
-- Storage & Utilities/Storage
-- https://grounded.fandom.com/wiki/Category:Storage_%26_Utilities/Storage

-- Storage Basket
items:insert({
    id = "Buildings/Storage",
    className = "/Script/Maine.StorageBuilding",
    shortClassName = "StorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_Storage.BP_Storage_C") },
}, {
    InventoryComponent = {
        MaxSize = 20, -- 20,
    }
} --[[@as AStorageBuilding]])

-- Storage Chest
items:insert({
    id = "Buildings/Storage",
    className = "/Script/Maine.StorageBuilding",
    shortClassName = "StorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_Storage_Big.BP_Storage_Big_C") },
}, {
    InventoryComponent = {
        MaxSize = 40, -- 40,
    }
} --[[@as AStorageBuilding]])

-- Large Storage Chest
items:insert({
    id = "Buildings/Storage",
    className = "/Script/Maine.StorageBuilding",
    shortClassName = "StorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_Storage_Tier3.BP_Storage_Tier3_C") },
}, {
    InventoryComponent = {
        MaxSize = 60, -- 60,
    }
} --[[@as AStorageBuilding]])

-- Fresh Storage
items:insert({
    id = "Buildings/Storage",
    className = "/Script/Maine.StorageBuilding",
    shortClassName = "StorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_StorageFridge.BP_StorageFridge_C") },
}, {
    InventoryComponent = {
        MaxSize = 20, -- 20,
    }
} --[[@as AStorageBuilding]])

-- Stem Pallet
items:insert({
    id = "Buildings/LogStorage",
    className = "/Script/Maine.TypeRestrictedStorageBuilding",
    shortClassName = "TypeRestrictedStorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_LogStorage.BP_LogStorage_C") },
}, {
    Capacity = 21, -- 21,
} --[[@as ATypeRestrictedStorageBuilding]])

-- Large Stem Pallet
items:insert({
    id = "Buildings/PlankStorage",
    className = "/Script/Maine.TypeRestrictedStorageBuilding",
    shortClassName = "TypeRestrictedStorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_LogStorage_Tier3.BP_LogStorage_Tier3_C") },
}, {
    Capacity = 60, -- 60,
} --[[@as ATypeRestrictedStorageBuilding]])

-- Plank Pallet
items:insert({
    id = "Buildings/PlankStorage",
    className = "/Script/Maine.TypeRestrictedStorageBuilding",
    shortClassName = "TypeRestrictedStorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_PlankStorage.BP_PlankStorage_C") },
}, {
    Capacity = 24, -- 24,
} --[[@as ATypeRestrictedStorageBuilding]])

-- Large Plank Pallet
items:insert({
    id = "Buildings/PlankStorage",
    className = "/Script/Maine.TypeRestrictedStorageBuilding",
    shortClassName = "TypeRestrictedStorageBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/Storage/BP_PlankStorage_Tier3.BP_PlankStorage_Tier3_C") },
}, {
    Capacity = 60, -- 60,
} --[[@as ATypeRestrictedStorageBuilding]])
--#endregion

--#region Dew Collector
-- https://grounded.fandom.com/wiki/Dew_Collector
items:insert({
    id = "FaucetBuilding",
    className = "/Script/Maine.FaucetBuilding",
    shortClassName = "FaucetBuilding",
    filters = { M.filters.isA("/Game/Blueprints/Items/Buildings/BP_DewCollector.BP_DewCollector_C") },

}, {
    FillAmountPerHour = 5, -- 5,
} --[[@as ABP_DewCollector_C]])
--#endregion

--#region Mutations
-- https://grounded.fandom.com/wiki/Mutations
items:insert({
    id = "SurvivalPlayerState",
    className = "/Script/Maine.SurvivalPlayerState",
    shortClassName = "SurvivalPlayerState",
}, {
    PerkComponent = {
        MaxEquippedPerks = 2 -- 2 | Number of slots for mutations (not including milk molar bonus),
    }
} --[[@as ASurvivalPlayerState]])
--#endregion

--#region Building
items:insert({
    id = "Building",
    className = "/Script/Maine.Building",
    shortClassName = "Building",
}, {
    DropIngredientsPercentage = 1,                       -- 1.0,
    DestroyedByCreatureDropIngredientsPercentage = 0.25, -- 0.25,
} --[[@as ABuilding]])
--#endregion

--#region ProductionBuilding
items:insert({
    id = "ProductionBuilding",
    className = "/Script/Maine.ProductionBuilding",
    shortClassName = "ProductionBuilding",
}, {
    -- The default value depends on the building. --,
    ProductionTime = M.MULT(1.0),    -- (float),
    MaxProductionItems = M.MULT(1),  -- (integer),
    MaxSimulateousItems = M.MULT(1), -- (integer),
} --[[@as AProductionBuilding]])
--#endregion

--#region TimeOfDayLightingManager
items:insert({
    id = "TimeOfDayLightingManager",
    className = "/Script/Maine.TimeOfDayLightingManager",
    shortClassName = "TimeOfDayLightingManager",
}, {

} --[[@as ATimeOfDayLightingManager]])
--#endregion

return { ---@type Mod_Options
    items = items,
    default = default,
    loader = M.loaders._ifPCExists_or_onPCRestart()
}
