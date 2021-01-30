local Lycan = {}

local scriptEnable = false
local myHero, myPlayer, enemy, summon, howl, shapeshift, bite = nil, nil, nil, nil, nil, nil, nil
local mainTimer = 0

local targetParticle = 0

local font = Renderer.LoadFont("Arial", 30, FONTFLAG_NONE, BOLD)


local rootPath = "Hero Specific"

local mainPath = {rootPath, "Lycan"}

local settingsPath = {rootPath, "Lycan", "Settings"}

local skillsPath = {rootPath, "Lycan", "Skills"}

local itemsPath = {rootPath, "Lycan", "Items"}

local unitsPath = {rootPath, "Lycan", "Units settings"}


local optionEnable = Menu.AddOptionBool(mainPath, "Enable", false)
Menu.AddOptionIcon(optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_lycan_png.vtex_c")

local optionFullCombo = Menu.AddKeyOption(settingsPath, "Button for full combo", Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(optionFullCombo, "~/MenuIcons/enemy_evil.png")
Menu.AddMenuIcon(settingsPath, "~/MenuIcons/utils_wheel.png")

local optionCursor = Menu.AddOptionBool(settingsPath, "Move to cursor if no enemy in combo", true)
Menu.AddOptionIcon(optionCursor, "~/MenuIcons/cursor.png")

local optionSelector = Menu.AddOptionCombo(settingsPath, "Style", { "Free", "Locked" }, 0)
Menu.AddOptionIcon(optionSelector, "~/MenuIcons/text_panel.png")


local optionIsTargetParticleEnabled = Menu.AddOptionBool(settingsPath, "Draws particle for current target", true)
Menu.AddOptionIcon(optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
local optionRangeToTarget = Menu.AddOptionSlider(settingsPath, "Distance from mouse to enemy for combo", 1, 3000, 500)
Menu.AddOptionIcon(optionRangeToTarget, "~/MenuIcons/edit.png")

local optionHits = Menu.AddOptionBool(settingsPath, "Show the number of hits before the kill")
Menu.AddOptionIcon(optionHits, "~/MenuIcons/counter_simple.png")
local radiusHits = Menu.AddOptionSlider(settingsPath, "radius of HTK", 100, 15000, 1500)
Menu.AddOptionIcon(radiusHits, "~/MenuIcons/edit.png")


local optionSatanicSlider = Menu.AddOptionSlider(itemsPath, "HPercent Threshold", 1, 100, 30)
Menu.AddOptionIcon(optionSatanicSlider, "panorama/images/items/satanic_png.vtex_c")


Lycan.itemsSelection = Menu.AddOptionMultiSelect(itemsPath, "Items Selection:", 
{
{"sheepstick", "panorama/images/items/sheepstick_png.vtex_c", true},
{"bloodthorn", "panorama/images/items/bloodthorn_png.vtex_c", true},
{"orchid", "panorama/images/items/orchid_png.vtex_c", true},
{"shivasguard", "panorama/images/items/shivas_guard_png.vtex_c", true},
{"blackkingbar", "panorama/images/items/black_king_bar_png.vtex_c", false},
{"manta", "panorama/images/items/manta_png.vtex_c", true},
{"mjollnir", "panorama/images/items/mjollnir_png.vtex_c", true},
{"armlet", "panorama/images/items/armlet_png.vtex_c", true},
{"mask", "panorama/images/items/mask_of_madness_png.vtex_c", true},
{"abyssal", "panorama/images/items/abyssal_blade_png.vtex_c", true},
{"satanic", "panorama/images/items/satanic_png.vtex_c", true},
{"silver", "panorama/images/items/silver_edge_png.vtex_c", true},
{"shadow", "panorama/images/items/invis_sword_png.vtex_c", true},
{"necronomicon", "panorama/images/items/necronomicon_3_png.vtex_c", true},
{"diffusal", "panorama/images/items/diffusal_blade_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

Lycan.skillsSelection = Menu.AddOptionMultiSelect(skillsPath, "Skills Selection:", 
{
{"summon", "panorama/images/spellicons/".."lycan_summon_wolves".."_png.vtex_c", true},
{"howl", "panorama/images/spellicons/".."lycan_howl".."_png.vtex_c", true},
{"shapeshift", "panorama/images/spellicons/".."lycan_shapeshift".."_png.vtex_c", true},
{"bite", "panorama/images/spellicons/".."lycan_wolf_bite".."_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

Lycan.optionUnitsSkills = Menu.AddOptionMultiSelect(unitsPath, "Units Skills Selection:", 
{
    {"stomp", "panorama/images/spellicons/centaur_khan_war_stomp_png.vtex_c", true},
    {"ensnare", "panorama/images/spellicons/dark_troll_warlord_ensnare_png.vtex_c", true},
    {"purge", "panorama/images/spellicons/satyr_trickster_purge_png.vtex_c", true},

    {"clap", "panorama/images/spellicons/polar_furbolg_ursa_warrior_thunder_clap_png.vtex_c", true},
    {"slam", "panorama/images/spellicons/big_thunder_lizard_slam_png.vtex_c", true},

    {"tornado", "panorama/images/spellicons/enraged_wildkin_tornado_png.vtex_c", true},
    {"boulder", "panorama/images/spellicons/mud_golem_hurl_boulder_png.vtex_c", true},
    {"frenzy", "panorama/images/spellicons/big_thunder_lizard_frenzy_png.vtex_c", true},
    {"fireball", "panorama/images/spellicons/black_dragon_fireball_png.vtex_c", true},
    {"manaBurn", "panorama/images/spellicons/satyr_soulstealer_mana_burn_png.vtex_c", true},
    {"lightning", "panorama/images/spellicons/harpy_storm_chain_lightning_png.vtex_c", true},
    {"shockwave", "panorama/images/spellicons/satyr_hellcaller_shockwave_png.vtex_c", true}
})
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

Lycan.optionUnitsBlocker = Menu.AddOptionBool(unitsPath, "Block target", true)
Lycan.optionUnitsBlockerCount = Menu.AddOptionSlider(unitsPath, "How many units block target", 1, 4, 2)
Menu.AddMenuIcon(unitsPath, "~/MenuIcons/utils_wheel.png")


-- //|\\
local w3core = {
    projectiles = {
        table = {},
        updateTimer = 0
    },
    importantUsage = {
        source = nil,
        target = nil,
        timer = 0
    },

    units = {
        status = {
            mainComboing = false,
            comboing = false
        },

        target = {
            entity = nil,
            particle = nil
        },

        overallTable = {},
        orderedTable = {},
        blockTable = {},

        stompTable = {},
        ensareTable = {},
        purgeTable = {},

        tornadoTable = {},
        
        clapTable = {},
        slamTable = {},

        lastIndex = {
            tornado = 0,
            combo = 0,
            block = 0,
        },
        timer = {
            stompOrder = 0,
            ensareOrder = 0,
            purgeOrder = 0,
    
            tornadoOrder = 0,
    
            clapOrder = 0,
            slamOrder = 0,

            combo = 0,
            block = 0,
        }
    },
}
function w3core.maxn(table)
    local maxn = 0
    for i, _ in pairs(table) do
        if i > maxn then
            maxn = i
        end
    end
    return maxn
end

--
function w3core.customFindFacing(Source, Target)
	local SourcePos = Entity.GetAbsOrigin(Source)
	local SourceRotation = Entity.GetRotation(Source):GetForward():Normalized()
	local BaseVec = (Entity.GetAbsOrigin(Target) - SourcePos):Normalized()
	local Processing = BaseVec:Dot2D(SourceRotation) / (BaseVec:Length2D() * SourceRotation:Length2D())
	if Processing > 1 then
		Processing = 1
	end	
	local CheckAngleRad = math.acos(Processing)
    local CheckAngle = (180 / math.pi) * CheckAngleRad
    return CheckAngle
end
--

--
function w3core.canInteract(Source, Target, Type, Abil, Mana, Magic)
    if Source and Entity.IsAlive(Source)
    and (not Abil or (Abilities.Contains(Abil) and not Ability.IsPassive(Abil) and Mana and Ability.IsCastable(Abil, Mana)))
    and not NPC.IsStunned(Source)
    and not NPC.HasState(Source, Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME)
    and (not Magic or not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE)) then
        if Type == "UtilityMove" then -- or (can move)
            if not NPC.HasState(Source, Enum.ModifierState.MODIFIER_STATE_ROOTED) then
                return true
            end
        elseif Type == "UtilityAttack" then -- or (can attack)
            if not NPC.HasState(Source, Enum.ModifierState.MODIFIER_STATE_DISARMED) then
                return true
            end
        elseif Type == "UtilitySkill" then -- or (can use skill)
            if Abil
            and not NPC.IsSilenced(Source) then
                return true
            end
        elseif Type == "UtilityItem" then -- or (can use item)
            if Abil then
                return true
            end
        elseif Type == "Move" then -- or (can move to target)
            if not NPC.HasState(Source, Enum.ModifierState.MODIFIER_STATE_ROOTED)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME) then
                return true
            end
        elseif Type == "Attack" then -- or (can attack target)
            if not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_UNTARGETABLE)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_ATTACK_IMMUNE)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME)
            and not NPC.HasState(Source, Enum.ModifierState.MODIFIER_STATE_DISARMED) then
                return true
            end
        elseif Type == "SkillNoTarget" then -- or (can use 'areaTarget' skill on target(target position))
            if Abil
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME)
            and not NPC.IsSilenced(Source) then
                return true
            end
        elseif Type == "SkillOnTarget" then -- or (can use 'targetUnit' skill on target)
            if Abil
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_UNTARGETABLE)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME)
            and not NPC.IsSilenced(Source) then
                return true
            end
        elseif Type == "ItemNoTarget" then -- or (can use 'areaTarget' item on target(target position))
            if Abil
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME) then
                return true
            end
        elseif Type == "ItemOnTarget" then -- or (can use 'targetUnit' item on target)
            if Abil
            and (not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) or Ability.GetName(Abil) == "item_nullifier")
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_UNTARGETABLE)
            and not NPC.HasState(Target, Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME) then
                return true
            end
        end
    end
    return false
end
--

-- skillsUsage
function w3core.skillsUsage()
    local disableTime = 0
    local pigDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_sheepstick_debuff")
    if pigDebuff then
        local pigTime = Modifier.GetDieTime(pigDebuff)
        if pigTime > disableTime then
            disableTime = pigTime
        end
    end
    local frogDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_lion_voodoo")
    if frogDebuff then
        local frogTime = Modifier.GetDieTime(frogDebuff)
        if frogTime > disableTime then
            disableTime = frogTime
        end
    end
    local sheepDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_shadow_shaman_voodoo")
    if sheepDebuff then
        local sheepTime = Modifier.GetDieTime(sheepDebuff)
        if sheepTime > disableTime then
            disableTime = sheepTime
        end
    end
    local stunDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_stunned")
    if stunDebuff then
        local stunTime = Modifier.GetDieTime(stunDebuff)
        if stunTime > disableTime then
            disableTime = stunTime
        end
    end
    local bashDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_bashed")
    if bashDebuff then
        local bashTime = Modifier.GetDieTime(bashDebuff)
        if bashTime > disableTime then
            disableTime = bashTime
        end
    end

    local rootTime = 0
    local atosDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_rod_of_atos_debuff")
    if atosDebuff then
        local atosTime = Modifier.GetDieTime(atosDebuff)
        if atosTime > rootTime then
            rootTime = atosTime
        end
    end
    local gungirDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_gungnir_debuff")
    if gungirDebuff then
        local gungirTime = Modifier.GetDieTime(gungirDebuff)
        if gungirTime > rootTime then
            rootTime = gungirTime
        end
    end
    local ensnareDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_dark_troll_warlord_ensnare")
    if ensnareDebuff then
        local ensnareTime = Modifier.GetDieTime(ensnareDebuff)
        if ensnareTime > rootTime then
            rootTime = ensnareTime
        end
    end

    local purgeTime = 0
    local neutralPurgeDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_satyr_trickster_purge")
    if neutralPurgeDebuff then
        purgeTime = Modifier.GetDieTime(neutralPurgeDebuff)
    end
    local necroPurgeDebuff = NPC.GetModifier(w3core.units.target.entity, "modifier_necronomicon_archer_purge")
    if necroPurgeDebuff then
        if Modifier.GetDieTime(necroPurgeDebuff) > purgeTime then
            purgeTime = Modifier.GetDieTime(necroPurgeDebuff)
        end
    end

    if Menu.IsSelected(Lycan.optionUnitsSkills, "stomp")
    and #w3core.units.stompTable >= 1 then
        local stompRange = 175
        if not NPC.IsRunning(w3core.units.target.entity) then
            stompRange = 225
        end
        local bestUnit
        local distance = 1000
        for _, unit in pairs(w3core.units.stompTable) do
            local stomp = NPC.GetAbilityByIndex(unit, 0)
            local mana = NPC.GetMana(unit)
            if w3core.canInteract(unit, w3core.units.target.entity, "SkillNoTarget", stomp, mana, true)
            and NPC.IsEntityInRange(w3core.units.target.entity, unit, distance)
            and (w3core.importantUsage.source == unit
            or w3core.importantUsage.target ~= w3core.units.target.entity
            or GameRules.GetGameTime() >= w3core.importantUsage.timer) then
                bestUnit = unit
                distance = Entity.GetAbsOrigin(unit):__sub(Entity.GetAbsOrigin(w3core.units.target.entity)):Length2D()
            end
        end
        if bestUnit
        and GameRules.GetGameTime() + 0.5 >= disableTime then
            table.insert(w3core.units.orderedTable, bestUnit)
            if GameRules.GetGameTime() >= w3core.units.timer.stompOrder then
                w3core.units.timer.stompOrder = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                if NPC.IsEntityInRange(w3core.units.target.entity, bestUnit, stompRange) then
                    Ability.CastNoTarget(NPC.GetAbilityByIndex(bestUnit, 0))
                    w3core.importantUsage.source = bestUnit
                    w3core.importantUsage.target = w3core.units.target.entity
                    w3core.importantUsage.timer = w3core.units.timer.stompOrder + 0.1
                    return
                else
                    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(w3core.units.target.entity), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, bestUnit)
                    return
                end
            end
        end
    end
    if Menu.IsSelected(Lycan.optionUnitsSkills, "ensnare")
    and #w3core.units.ensnareTable >= 1 then
    --and not RootProjectile then
        local bestUnit
        local distance = 550
        for _, unit in pairs(w3core.units.ensnareTable) do
            local ensnare = NPC.GetAbilityByIndex(unit, 0)
            local mana = NPC.GetMana(unit)
            if w3core.canInteract(unit, w3core.units.target.entity, "SkillOnTarget", ensnare, mana, true)
            and NPC.IsEntityInRange(w3core.units.target.entity, unit, distance) then
                if w3core.importantUsage.source == unit
                and w3core.importantUsage.target == w3core.units.target.entity
                and GameRules.GetGameTime() < w3core.importantUsage.timer then
                    bestUnit = unit
                    distance = Entity.GetAbsOrigin(unit):__sub(Entity.GetAbsOrigin(w3core.units.target.entity)):Length2D()
                    break
                elseif (w3core.importantUsage.source == unit
                or w3core.importantUsage.target ~= w3core.units.target.entity
                or GameRules.GetGameTime() >= w3core.importantUsage.timer) then
                --and not w3core.canDisable(w3core.units.target.entity, counterspellBuff, lotusBuff) then
                    bestUnit = unit
                    distance = Entity.GetAbsOrigin(unit):__sub(Entity.GetAbsOrigin(w3core.units.target.entity)):Length2D()
                end
            end
        end
        if bestUnit
        and GameRules.GetGameTime() + 0.4 + (distance / 1500) >= disableTime
        and GameRules.GetGameTime() + 0.4 + (distance / 1500) >= rootTime then
            table.insert(w3core.units.orderedTable, bestUnit)
            if GameRules.GetGameTime() >= w3core.units.timer.ensareOrder then
                Ability.CastTarget(NPC.GetAbilityByIndex(bestUnit, 0), w3core.units.target.entity)
                w3core.units.timer.ensareOrder = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                w3core.importantUsage.source = bestUnit
                w3core.importantUsage.target = w3core.units.target.entity
                w3core.importantUsage.timer = w3core.units.timer.ensareOrder + 0.1
                return
            end
        end
    end
    if Menu.IsSelected(Lycan.optionUnitsSkills, "purge")
    and #w3core.units.purgeTable >= 1
    and GameRules.GetGameTime() + 0.2 >= disableTime
    and GameRules.GetGameTime() + 0.2 >= rootTime
    and GameRules.GetGameTime() + 1.6 >= purgeTime then
        local bestUnit
        local minDistance = 99999
        for _, unit in pairs(w3core.units.purgeTable) do
            local purge = NPC.GetAbilityByIndex(unit, 0)
            local mana = NPC.GetMana(unit)
            local purgeCastRange = Ability.GetCastRange(purge)
            local distance = Entity.GetAbsOrigin(unit):__sub(Entity.GetAbsOrigin(w3core.units.target.entity)):Length2D() + purgeCastRange
            if w3core.canInteract(unit, w3core.units.target.entity, "SkillOnTarget", purge, mana, true)
            and NPC.IsEntityInRange(w3core.units.target.entity, unit, purgeCastRange + 400)
            and distance < minDistance then
                bestUnit = unit
                minDistance = distance
            end
        end
        if bestUnit then
            table.insert(w3core.units.orderedTable, bestUnit)
            if GameRules.GetGameTime() >= w3core.units.timer.purgeOrder then
                local purge = NPC.GetAbilityByIndex(bestUnit, 0)
                local purgeCastRange = Ability.GetCastRange(purge)
                if NPC.IsEntityInRange(w3core.units.target.entity, bestUnit, purgeCastRange) then
                    Ability.CastTarget(purge, w3core.units.target.entity)
                    w3core.units.timer.purgeOrder = GameRules.GetGameTime() + 0.4 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                else
                    Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(w3core.units.target.entity), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, bestUnit)
                    w3core.units.timer.purgeOrder = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                end
                return
            end
        end
    end
end
--

-- bodyBlocker
function w3core.bodyBlockTarget()
    local unitsCount = 0
    for _, unit in pairs(w3core.units.overallTable) do
        if unit and not NPC.IsChannellingAbility(unit) then
            unitsCount = unitsCount + 1
        end
    end

    local blockPos = Entity.GetAbsOrigin(w3core.units.target.entity)
    local dir = Entity.GetRotation(w3core.units.target.entity):GetForward():Normalized()
    local targetSpeed = NPC.GetMoveSpeed(w3core.units.target.entity)
    blockPos = blockPos + dir:Scaled(100)

    if #w3core.units.blockTable == 0
    and unitsCount > 1 then
        local cachedUnit
        local minDistance
        ::again::
        cachedUnit = nil
        minDistance = 99999
        for _, unit in pairs(w3core.units.overallTable) do
            if unit and not NPC.IsChannellingAbility(unit) then
                local check = false
                if #w3core.units.blockTable >= 1 then
                    for _, unitInTable in pairs(w3core.units.blockTable) do
                        if unit == unitInTable then
                            check = true
                        end
                    end
                end
                local distanceToTarget = Entity.GetAbsOrigin(unit):__sub(blockPos):Length2D()
                if not check and distanceToTarget < minDistance then
                    cachedUnit = unit
                    minDistance = distanceToTarget
                end
            end
        end
        if cachedUnit then
            table.insert(w3core.units.blockTable, cachedUnit)
        end
        if #w3core.units.blockTable < Menu.GetValue(Lycan.optionUnitsBlockerCount) and #w3core.units.blockTable < unitsCount - 1 then
            goto again
        end
    elseif #w3core.units.blockTable >= 1
    and GameRules.GetGameTime() >= w3core.units.timer.block then
        for index, unit in pairs(w3core.units.blockTable) do
            local check = false
            if #w3core.units.orderedTable >= 1 then
                for _, unitInTable in pairs(w3core.units.orderedTable) do
                    if unit == unitInTable then
                        check = true
                    end
                end
            end
            if unit and index > w3core.units.lastIndex.block and not check then
                if not NPC.IsRunning(w3core.units.target.entity) then
                    if w3core.customFindFacing(w3core.units.target.entity, unit) < 40
                    and w3core.canInteract(unit, w3core.units.target.entity, "Attack") then
                        Player.AttackTarget(myPlayer, unit, w3core.units.target.entity)
                    else
                        Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, blockPos + dir:Scaled(100), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, unit)
                    end
                else
                    Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, blockPos + dir:Scaled(w3core.customFindFacing(w3core.units.target.entity, unit) * 7.5 + targetSpeed * 0.05), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, unit)
                end
                w3core.units.lastIndex.block = index
                w3core.units.timer.block = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                break
            end
            if index >= w3core.maxn(w3core.units.blockTable) then
                w3core.units.blockTable = {}
                w3core.units.lastIndex.block = 0
            end
        end
    end
end
--

-- comboUnits
function w3core.comboUnits()
    if #w3core.units.tornadoTable >= 1
    and GameRules.GetGameTime() >= w3core.units.timer.tornadoOrder then
        for index, tornado in pairs(w3core.units.tornadoTable) do
            if index > w3core.units.lastIndex.tornado then
                Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(w3core.units.target.entity), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, tornado)
                w3core.units.lastIndex.tornado = index
                w3core.units.timer.tornadoOrder = GameRules.GetGameTime() + 0.2 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                break
            end
            if index >= w3core.maxn(w3core.units.tornadoTable) then
                w3core.units.lastIndex.tornado = 0
                w3core.units.timer.tornadoOrder = GameRules.GetGameTime() + 0.3 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
            end
        end
    end
    if Menu.IsSelected(Lycan.optionUnitsSkills, "clap")
    and #w3core.units.clapTable >= 1 then
        local clapRange = 275
        if NPC.IsRunning(w3core.units.target.entity) then
            clapRange = 225
        end
        local bestUnit
        local distance = 1000
        for _, unit in pairs(w3core.units.clapTable) do
            local clap = NPC.GetAbilityByIndex(unit, 0)
            local mana = NPC.GetMana(unit)
            if w3core.canInteract(unit, w3core.units.target.entity, "SkillNoTarget", clap, mana, true)
            and NPC.IsEntityInRange(w3core.units.target.entity, unit, distance) then
                bestUnit = unit
                distance = Entity.GetAbsOrigin(unit):__sub(Entity.GetAbsOrigin(w3core.units.target.entity)):Length2D()
            end
        end
        if bestUnit then
            table.insert(w3core.units.orderedTable, bestUnit)
            if GameRules.GetGameTime() >= w3core.units.timer.clapOrder then
                if NPC.IsEntityInRange(w3core.units.target.entity, bestUnit, clapRange) then
                    Ability.CastNoTarget(NPC.GetAbilityByIndex(bestUnit, 0))
                else
                    Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(w3core.units.target.entity), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, bestUnit)
                end
                w3core.units.timer.clapOrder = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                return
            end
        end
    end
    if Menu.IsSelected(Lycan.optionUnitsSkills, "slam")
    and #w3core.units.slamTable >= 1 then
        local slamRange = 225
        if NPC.IsRunning(w3core.units.target.entity) then
            slamRange = 175
        end
        local bestUnit
        local distance = 1000
        for _, unit in pairs(w3core.units.slamTable) do
            local slam = NPC.GetAbilityByIndex(unit, 0)
            local mana = NPC.GetMana(unit)
            if w3core.canInteract(unit, w3core.units.target.entity, "SkillNoTarget", slam, mana, true)
            and NPC.IsEntityInRange(w3core.units.target.entity, unit, distance) then
                bestUnit = unit
                distance = Entity.GetAbsOrigin(unit):__sub(Entity.GetAbsOrigin(w3core.units.target.entity)):Length2D()
            end
        end
        if bestUnit then
            table.insert(w3core.units.orderedTable, bestUnit)
            if GameRules.GetGameTime() >= w3core.units.timer.slamOrder then
                if NPC.IsEntityInRange(w3core.units.target.entity, bestUnit, slamRange) then
                    Ability.CastNoTarget(NPC.GetAbilityByIndex(bestUnit, 0))
                else
                    Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(w3core.units.target.entity), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, bestUnit)
                end
                w3core.units.timer.slamOrder = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                return
            end
        end
    end

    if GameRules.GetGameTime() >= w3core.units.timer.combo then
        for index, unit in pairs(w3core.units.overallTable) do
            local check = false
            if #w3core.units.orderedTable >= 1 then
                for _, unitInTable in pairs(w3core.units.orderedTable) do
                    if unit == unitInTable then
                        check = true
                    end
                end
            end
            if #w3core.units.blockTable >= 1 then
                for _, unitInTable in pairs(w3core.units.blockTable) do
                    if unit == unitInTable then
                        check = true
                    end
                end
            end
            if not check and not NPC.IsChannellingAbility(unit)
            and index > w3core.units.lastIndex.combo then
                if Menu.IsSelected(Lycan.optionUnitsSkills, "tornado")
                and NPC.GetUnitName(unit) == "npc_dota_neutral_enraged_wildkin"
                and NPC.IsEntityInRange(w3core.units.target.entity, unit, 500)
                and w3core.canInteract(unit, w3core.units.target.entity, "SkillNoTarget", NPC.GetAbilityByIndex(unit, 0), NPC.GetMana(unit), true) then
                    Ability.CastPosition(NPC.GetAbilityByIndex(unit, 0), Entity.GetAbsOrigin(w3core.units.target.entity))
                    w3core.units.timer.block = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                elseif Menu.IsSelected(Lycan.optionUnitsSkills, "boulder")
                and (NPC.GetUnitName(unit) == "npc_dota_neutral_mud_golem"
                or NPC.GetUnitName(unit) == "npc_dota_neutral_mud_golem_split")
                and NPC.IsEntityInRange(w3core.units.target.entity, unit, 800)
                and w3core.canInteract(unit, w3core.units.target.entity, "SkillOnTarget", NPC.GetAbilityByIndex(unit, 0), NPC.GetMana(unit), true) then
                    Ability.CastTarget(NPC.GetAbilityByIndex(unit, 0), w3core.units.target.entity)
                elseif Menu.IsSelected(Lycan.optionUnitsSkills, "frenzy")
                and NPC.GetUnitName(unit) == "npc_dota_neutral_big_thunder_lizard"
                and NPC.IsEntityInRange(w3core.units.target.entity, unit, 400)
                and w3core.canInteract(unit, w3core.units.target.entity, "Attack")
                and w3core.canInteract(unit, nil, "UtilitySkill", NPC.GetAbilityByIndex(unit, 0), NPC.GetMana(unit)) then
                    Ability.CastTarget(NPC.GetAbilityByIndex(unit, 1), unit)
                elseif Menu.IsSelected(Lycan.optionUnitsSkills, "fireball")
                and NPC.GetUnitName(unit) == "npc_dota_neutral_black_dragon"
                and NPC.IsEntityInRange(w3core.units.target.entity, unit, 1000)
                and w3core.canInteract(unit, w3core.units.target.entity, "SkillNoTarget", NPC.GetAbilityByIndex(unit, 0), NPC.GetMana(unit), true) then
                    Ability.CastPosition(NPC.GetAbilityByIndex(unit, 0), Entity.GetAbsOrigin(w3core.units.target.entity))
                elseif Menu.IsSelected(Lycan.optionUnitsSkills, "manaBurn")
                and NPC.GetUnitName(unit) == "npc_dota_neutral_satyr_soulstealer"
                and NPC.IsEntityInRange(w3core.units.target.entity, unit, 600)
                and NPC.GetMana(w3core.units.target.entity) >= 50
                and w3core.canInteract(unit, w3core.units.target.entity, "SkillOnTarget", NPC.GetAbilityByIndex(unit, 0), NPC.GetMana(unit), true) then
                    Ability.CastTarget(NPC.GetAbilityByIndex(unit, 0), w3core.units.target.entity)
                elseif Menu.IsSelected(Lycan.optionUnitsSkills, "lightning")
                and NPC.GetUnitName(unit) == "npc_dota_neutral_harpy_storm"
                and NPC.IsEntityInRange(w3core.units.target.entity, unit, 900)
                and w3core.canInteract(unit, w3core.units.target.entity, "SkillOnTarget", NPC.GetAbilityByIndex(unit, 0), NPC.GetMana(unit), true) then
                    Ability.CastTarget(NPC.GetAbilityByIndex(unit, 0), w3core.units.target.entity)
                elseif Menu.IsSelected(Lycan.optionUnitsSkills, "shockwave")
                and NPC.GetUnitName(unit) == "npc_dota_neutral_satyr_hellcaller"
                and NPC.IsEntityInRange(w3core.units.target.entity, unit, 700)
                and w3core.canInteract(unit, w3core.units.target.entity, "SkillNoTarget", NPC.GetAbilityByIndex(unit, 0), NPC.GetMana(unit), true) then
                    Ability.CastPosition(NPC.GetAbilityByIndex(unit, 0), Entity.GetAbsOrigin(w3core.units.target.entity))
                else
                    if #w3core.units.blockTable >= 1 then
                        for _, unitInTable in pairs(w3core.units.blockTable) do
                            if unit == unitInTable then
                                check = true
                            end
                        end
                    end
                    if not check then
                        if w3core.canInteract(unit, w3core.units.target.entity, "Attack") then
                            Player.AttackTarget(myPlayer, unit, w3core.units.target.entity)
                        else
                            Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, Entity.GetAbsOrigin(w3core.units.target.entity), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, unit)
                        end
                    end
                end
                w3core.units.lastIndex.combo = index
                w3core.units.timer.combo = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
                break
            end
            if index >= w3core.maxn(w3core.units.overallTable) then
                w3core.units.lastIndex.combo = 0
            end
        end
    end
end
--

-- init
function w3core.getUnitTable()
    w3core.units.overallTable = {}
    w3core.units.orderedTable = {}
    w3core.units.blockTable = {}

    w3core.units.stompTable = {}
    w3core.units.ensnareTable = {}
    w3core.units.purgeTable = {}

    w3core.units.tornadoTable = {}

    w3core.units.clapTable = {}
    w3core.units.slamTable = {}

    for count = 1, NPCs.Count() do
        local unit = NPCs.Get(count)
        if Entity.RecursiveGetOwner(unit) == myPlayer
        and Entity.IsNPC(unit) and Entity.IsAlive(unit) then
            if NPC.GetUnitName(unit) == "npc_dota_enraged_wildkin_tornado" then
                table.insert(w3core.units.tornadoTable, unit)
            elseif NPC.GetModifier(unit, "modifier_kill") or NPC.GetModifier(unit, "modifier_illusion")
            or NPC.GetModifier(unit, "modifier_dominated") then
                table.insert(w3core.units.overallTable, unit)
                if NPC.GetUnitName(unit) == "npc_dota_neutral_centaur_khan" then
                    table.insert(w3core.units.stompTable, unit)
                elseif NPC.GetUnitName(unit) == "npc_dota_neutral_dark_troll_warlord" then
                    table.insert(w3core.units.ensnareTable, unit)
                elseif NPC.GetUnitName(unit) == "npc_dota_neutral_satyr_trickster" or NPC.GetUnitName(unit) == "npc_dota_necronomicon_archer_3" then
                    table.insert(w3core.units.purgeTable, unit)
                elseif NPC.GetUnitName(unit) == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
                    table.insert(w3core.units.clapTable, unit)
                elseif NPC.GetUnitName(unit) == "npc_dota_neutral_big_thunder_lizard" then
                    table.insert(w3core.units.slamTable, unit)
                end
            end
        end
    end 
end
function w3core.init()
    w3core.getUnitTable()
end
--

function Lycan.OnModifierCreate(ent, mod)
    if not scriptEnable then return end

    if Entity.RecursiveGetOwner(ent) == myPlayer then
        if Modifier.GetName(mod) == "modifier_tornado_tempest"
        and NPC.GetUnitName(ent) == "npc_dota_enraged_wildkin_tornado" then
            table.insert(w3core.units.tornadoTable, ent)
        elseif Modifier.GetName(mod) == "modifier_kill" or Modifier.GetName(mod) == "modifier_illusion"
        or Modifier.GetName(mod) == "modifier_dominated" then
            table.insert(w3core.units.overallTable, ent)
            if NPC.GetUnitName(ent) == "npc_dota_neutral_centaur_khan" then
                table.insert(w3core.units.stompTable, ent)
            elseif NPC.GetUnitName(ent) == "npc_dota_neutral_dark_troll_warlord" then
                table.insert(w3core.units.ensnareTable, ent)
            elseif NPC.GetUnitName(ent) == "npc_dota_neutral_satyr_trickster" or NPC.GetUnitName(ent) == "npc_dota_necronomicon_archer_3" then
                table.insert(w3core.units.purgeTable, ent)
            elseif NPC.GetUnitName(ent) == "npc_dota_neutral_polar_furbolg_ursa_warrior" then
                table.insert(w3core.units.clapTable, ent)
            elseif NPC.GetUnitName(ent) == "npc_dota_neutral_big_thunder_lizard" then
                table.insert(w3core.units.slamTable, ent)
            end
        end
    end
end
function Lycan.OnModifierDestroy(ent, mod)
    if not scriptEnable then return end

    if Modifier.GetName(mod) == "modifier_tornado_tempest" then
        for index, unit in pairs(w3core.units.tornadoTable) do
            if ent == unit then
                w3core.units.tornadoTable[index] = nil
            end
        end
    elseif Modifier.GetName(mod) == "modifier_kill" or Modifier.GetName(mod) == "modifier_illusion"
    or Modifier.GetName(mod) == "modifier_chen_holy_persuasion" or Modifier.GetName(mod) == "modifier_dominated" then
        for index, unit in pairs(w3core.units.overallTable) do
            if ent == unit then
                w3core.units.overallTable[index] = nil
            end
        end
        for index, unit in pairs(w3core.units.stompTable) do
            if ent == unit then
                w3core.units.stompTable[index] = nil
            end
        end
        for index, unit in pairs(w3core.units.ensnareTable) do
            if ent == unit then
                w3core.units.ensnareTable[index] = nil
            end
        end
        for index, unit in pairs(w3core.units.purgeTable) do
            if ent == unit then
                w3core.units.purgeTable[index] = nil
            end
        end
        for index, unit in pairs(w3core.units.clapTable) do
            if ent == unit then
                w3core.units.clapTable[index] = nil
            end
        end
        for index, unit in pairs(w3core.units.slamTable) do
            if ent == unit then
                w3core.units.slamTable[index] = nil
            end
        end
    end
end
-- //|\\


function Lycan.init()
    scriptEnable = true
    if not Menu.IsEnabled(optionEnable) then
        scriptEnable = false
        return
    end
    myPlayer = Players.GetLocal()
    if not myPlayer then
        scriptEnable = false
        return
    end
    myHero = Heroes.GetLocal()
    if not myHero then
        scriptEnable = false
        return
    end
    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_lycan" then 
        scriptEnable = false
        return
    end
    w3core.init()
end
Lycan.init()
function Lycan.OnMenuOptionChange(option, oldValue, newValue)
    if option == optionEnable then
        Lycan.init()
    end
end

function Lycan.OnUpdate()
    if not scriptEnable then return end

    if (not Menu.IsEnabled(optionEnable)) then
        myHero = nil
        return
    end

    local mana = NPC.GetMana(myHero)


    if (not summon) then
        summon = NPC.GetAbility(myHero, "lycan_summon_wolves")
        return
    end


    if (not howl) then
        howl = NPC.GetAbility(myHero, "lycan_howl")
        return
    end
    
    if (not shapeshift) then
        shapeshift = NPC.GetAbility(myHero, "lycan_shapeshift")
        return
    end

    if (not bite) then
        bite = NPC.GetAbility(myHero, "lycan_wolf_bite")
        return
    end



    local sheepstick = Lycan.CheckItem("item_sheepstick")

    local bloodthorn = Lycan.CheckItem("item_bloodthorn")

    local orchid = Lycan.CheckItem("item_orchid")

    local shivasguard = Lycan.CheckItem("item_shivas_guard")

    local blackkingbar = Lycan.CheckItem("item_black_king_bar")

    local manta = Lycan.CheckItem("item_manta")

    local mjollnir = Lycan.CheckItem("item_mjollnir")

    local armlet = Lycan.CheckItem("item_armlet")

    local mask = Lycan.CheckItem("item_mask_of_madness")

    local abyssal = Lycan.CheckItem("item_abyssal_blade")

    local satanic = Lycan.CheckItem("item_satanic")

    local silver = Lycan.CheckItem("item_silver_edge")

    local shadow = Lycan.CheckItem("item_invis_sword")

    local necr1 = Lycan.CheckItem("item_necronomicon")

    local necr2 = Lycan.CheckItem("item_necronomicon_2")

    local necr3 = Lycan.CheckItem("item_necronomicon_3")

    local diffusal = Lycan.CheckItem("item_diffusal_blade")


    if not enemy then
        enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
    end
    if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(optionRangeToTarget), 0) then
        enemy = nil
    end

    if Menu.GetValue(optionSelector) == 0 then
        if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
            enemy = nil
        end
    end

    if Menu.GetValue(optionSelector) == 1 then
        if not Menu.IsKeyDown(optionFullCombo) then
            if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
                enemy = nil
            end
        end    
    end

    if Menu.IsKeyDown(optionFullCombo) and enemy then
        if (not NPC.IsChannellingAbility(myHero))
        and GameRules.GetGameTime() >= mainTimer then
            local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
            local origin = Entity.GetOrigin(enemy)
        

            if (Menu.IsSelected(Lycan.itemsSelection, "silver")) and  Lycan.ItemNoTarget(silver, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "shadow")) and  Lycan.ItemNoTarget(shadow, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

    
            if NPC.GetModifier(myHero, "modifier_item_silver_edge_windwalk") or NPC.GetModifier(myHero, "modifier_item_invisibility_edge_windwalk") then
                Player.AttackTarget(myPlayer, myHero, enemy)
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end
            

            if (Menu.IsSelected(Lycan.itemsSelection, "armlet")) and armlet and not Ability.GetToggleState(armlet) and not accept then
                Ability.Toggle(armlet)
                mainTimer = GameRules.GetGameTime() + 0.1
                accept = 1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "mjollnir")) and Lycan.ItemTarget(mjollnir, myHero, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            --
            local disableTime = 0
            local pigDebuff = NPC.GetModifier(enemy, "modifier_sheepstick_debuff")
            if pigDebuff then
                local pigTime = Modifier.GetDieTime(pigDebuff)
                if pigTime > disableTime then
                    disableTime = pigTime
                end
            end
            local frogDebuff = NPC.GetModifier(enemy, "modifier_lion_voodoo")
            if frogDebuff then
                local frogTime = Modifier.GetDieTime(frogDebuff)
                if frogTime > disableTime then
                    disableTime = frogTime
                end
            end
            local sheepDebuff = NPC.GetModifier(enemy, "modifier_shadow_shaman_voodoo")
            if sheepDebuff then
                local sheepTime = Modifier.GetDieTime(sheepDebuff)
                if sheepTime > disableTime then
                    disableTime = sheepTime
                end
            end
            local stunDebuff = NPC.GetModifier(enemy, "modifier_stunned")
            if stunDebuff then
                local stunTime = Modifier.GetDieTime(stunDebuff)
                if stunTime > disableTime then
                    disableTime = stunTime
                end
            end
            local bashDebuff = NPC.GetModifier(enemy, "modifier_bashed")
            if bashDebuff then
                local bashTime = Modifier.GetDieTime(bashDebuff)
                if bashTime > disableTime then
                    disableTime = bashTime
                end
            end
            --
            
            if (Menu.IsSelected(Lycan.itemsSelection, "abyssal")) and abyssal
            and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(abyssal)) and
            (w3core.importantUsage.source == myHero
            or w3core.importantUsage.target ~= enemy
            or GameRules.GetGameTime() >= w3core.importantUsage.timer)
            and GameRules.GetGameTime() + 0.2 >= disableTime
            and Lycan.ItemTarget(abyssal, enemy, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                w3core.importantUsage.source = myHero
                w3core.importantUsage.target = enemy
                w3core.importantUsage.timer = mainTimer + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "sheepstick")) and sheepstick
            and NPC.IsEntityInRange(myHero, enemy, Ability.GetCastRange(sheepstick)) and
            (w3core.importantUsage.source == myHero
            or w3core.importantUsage.target ~= enemy
            or GameRules.GetGameTime() >= w3core.importantUsage.timer)
            and GameRules.GetGameTime() + 0.2 >= disableTime
            and Lycan.ItemTarget(sheepstick , enemy, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                w3core.importantUsage.source = myHero
                w3core.importantUsage.target = enemy
                w3core.importantUsage.timer = mainTimer + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "bloodthorn")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Lycan.ItemTarget(bloodthorn, enemy, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end
        
            if (Menu.IsSelected(Lycan.itemsSelection, "orchid")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and Lycan.ItemTarget(orchid, enemy, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "manta")) and  Lycan.ItemNoTarget(manta, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "necronomicon")) and  Lycan.ItemNoTarget(necr1, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "necronomicon")) and  Lycan.ItemNoTarget(necr2, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "necronomicon")) and  Lycan.ItemNoTarget(necr3, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "mask")) and  Lycan.ItemNoTarget(mask, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "diffusal")) and not NPC.IsStunned(enemy) and not NPC.GetModifier(enemy, "modifier_sheepstick_debuff") and Lycan.ItemTarget(diffusal, enemy, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.itemsSelection, "shivasguard")) and  Lycan.ItemNoTarget(shivasguard, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.skillsSelection, "summon")) and Lycan.Summon(summon, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.skillsSelection, "howl")) and distance < 2000 and Lycan.Howl(howl, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if (Menu.IsSelected(Lycan.skillsSelection, "shapeshift")) and Lycan.Shapeshift(shapeshift, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end

            if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(optionSatanicSlider) then
                if (Menu.IsSelected(Lycan.itemsSelection, "satanic")) and not NPC.GetModifier(enemy, "modifier_oracle_false_promise") and Lycan.ItemNoTarget(satanic, mana) == true then
                    mainTimer = GameRules.GetGameTime() + 0.1
                    return
                end
            end 
        
            if (Menu.IsSelected(Lycan.itemsSelection, "blackkingbar")) and Lycan.ItemNoTarget(blackkingbar, mana) == true then
                mainTimer = GameRules.GetGameTime() + 0.1
                return
            end              

            Player.AttackTarget(myPlayer, myHero, enemy)
            mainTimer = GameRules.GetGameTime() + 0.1
        end
        --
        w3core.units.orderedTable = {}
        w3core.units.target.entity = enemy
        w3core.skillsUsage()
        if Menu.IsEnabled(Lycan.optionUnitsBlocker) then
            w3core.bodyBlockTarget()
        end
        w3core.comboUnits()
        --
    else
        --
        w3core.units.target.entity = nil
        --
    end

    if Menu.IsEnabled(optionCursor) then
    	if GameRules.GetGameTime() >= mainTimer then
        	if Menu.IsKeyDown(optionFullCombo) then
        	    if (not enemy) and (not NPC.IsChannellingAbility(myHero)) then
        	        NPC.MoveTo(myHero, Input.GetWorldCursorPos())
        	    end     
        	end
            mainTimer = GameRules.GetGameTime() + 0.1
        end	 
    end 
    
    if not Menu.IsKeyDown(optionFullCombo) then 
        accept = nil
        --
        w3core.units.target.entity = nil
        --
    end  
end

function Lycan.OnDraw()
    if (not myHero) then
        return
    end 

    if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_lycan" then 
        return
    end
    local particleEnemy = enemy
    if Menu.IsEnabled(optionIsTargetParticleEnabled) then    
        if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
            Particle.Destroy(targetParticle)            
            targetParticle = 0
            particleEnemy = enemy
        else
            if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(optionRangeToTarget), 0) then
                targetParticle = Particle.Create("particles/ui_mouseactions/range_finder_tower_aoe.vpcf", Enum.ParticleAttachment.PATTACH_INVALID, enemy)               
            end
            if targetParticle ~= 0 then
                Particle.SetControlPoint(targetParticle, 2, Entity.GetOrigin(myHero))
                Particle.SetControlPoint(targetParticle, 6, Vector(1, 0, 0))
                Particle.SetControlPoint(targetParticle, 7, Entity.GetOrigin(enemy))
            end
        end
    else 
        if targetParticle ~= 0 then
            Particle.Destroy(targetParticle)            
            targetParticle = 0
        end
    end

    if Menu.IsEnabled(optionHits) then
        for i = 1, Heroes.Count() do
            local enemyHits = Heroes.Get(i)
            local rangeHits = Menu.GetValue(radiusHits)
            do
                if enemyHits and Entity.IsHero(enemyHits) and NPC.IsEntityInRange(myHero, enemyHits, rangeHits) and Entity.IsAlive(enemyHits) and
                    not Entity.IsSameTeam(myHero, enemyHits) and not NPC.IsIllusion(enemyHits) and not Entity.IsDormant(enemyHits) then
                    local oneHitDamage = NPC.GetTrueDamage(myHero) * NPC.GetArmorDamageMultiplier(enemyHits)
                    local hitsLeft = math.ceil(Entity.GetHealth(enemyHits) / oneHitDamage)
                    local posHits = Entity.GetAbsOrigin(enemyHits)
                    local xH, yH, visible = Renderer.WorldToScreen(posHits)
    
                    text = string.format(hitsLeft)
    
                    if true then
                        Renderer.SetDrawColor(0, 255, 0, 255)
                        Lycan.DrawTextCentered(font, xH, yH, text)
                    end
                end
            end
        end
    end    
end 

function Lycan.CheckItem(item)
    for i = 0, 5 do
        local itemCheck = NPC.GetItemByIndex(myHero, i)
        if itemCheck and item == Ability.GetName(itemCheck) then
            return itemCheck
        end
    end
end

function Lycan.Summon(ability, mana)
    if Menu.IsSelected(Lycan.skillsSelection, "summon") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
        Ability.CastNoTarget(ability, mana)
        return true
    end 
end

function Lycan.Howl(ability, mana)
    if Menu.IsSelected(Lycan.skillsSelection, "howl") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
        Ability.CastNoTarget(ability, mana)
        return true
    end 
end

function Lycan.Shapeshift(ability, mana)
    if Menu.IsSelected(Lycan.skillsSelection, "shapeshift") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
        Ability.CastNoTarget(ability, mana)
        return true
    end 
end



--Функции предметов

function Lycan.ItemTarget(item, enemy, mana)
    if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastTarget(item, enemy)
        return true  
    end   
end

function Lycan.ItemOrigin(item, origin, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastPosition(item, origin) 
        return true
    end   
end


function Lycan.ItemNoTarget(item, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastNoTarget(item)
        return true  
    end   
end


function Lycan.DrawTextCentered(p1, p2, p3, p4)
    local wide, tall = Renderer.GetTextSize(p1, p4)
    return Renderer.DrawText(p1, math.ceil(p2 - wide / 2), math.ceil(p3 - tall / 2), p4)
end


return Lycan