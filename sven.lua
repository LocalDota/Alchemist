local Sven = {}

local myHero, myPlayer, enemy, storm, warcry, god = nil, nil, nil, nil, nil, nil


------------------------------------------------
local targetParticle = 0
------------------------------------------------



--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1

local lastMoveOrder2 = 0
local orderDelay2 = 1 

local lastMoveOrder3 = 0
local orderDelay3 = 0.1

local lastMoveOrder4 = 0
local orderDelay4 = 1

local lastMoveOrder5 = 0
local orderDelay5 = 0.1

local lastMoveOrder6 = 0
local orderDelay6 = 0.1  

function Sven.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end
--------------------------------------------------










-------------------------------------------------------------------------------------------------------------------------------------------------
--Перевод
local RU = "russian"
local EN = "english" 
local CN = "Chinese" 
 
 
local language = EN
 
if Menu.GetLanguageOptionid then
    local LanguageItem = Menu.GetLanguageOptionid()
    local menuLang = Menu.GetValue(LanguageItem)
    if menuLang == 1 then -- ru
      language = RU
    elseif menuLang == 0 then -- en
      language = EN
	elseif menuLang == 2 then -- cn
	  language = CN
    end
end




local Translation = {
    ["optionEnable"] = {
        [RU] = "Включение",
        [EN] = "Enable",
		[CN] = "启用",
    },
    ["optionRangeToTarget"] = {
        [RU] = "Расстояние  от мышки до врага для комбо",
        [EN] = "Distance from mouse to enemy for combo",
		[CN] = "靠近鼠标范围",
    },
    ["optionFullCombo"] = {
    	[RU] = "Кнопка для полного комбо",
    	[EN] = "Button for full combo",
		[CN] = "Button for full combo",
    },
    ["optionIsTargetParticleEnabled"] = {
    	[RU] = "Рисовать партикль захваченной цели",
    	[EN] = "Draws particle for current target",
		[CN] = "目标指示器",
    },
    ["optionCursor"] = {
    	[RU] = "Двигаться к курсору если нет врага в комбо", 
    	[EN] = "Move to cursor if no enemy in combo",
		[CN] = "无目标时移动到鼠标",
    },
    ["optionBlinkSlider"] = {
        [RU] = "Минимальная дистанция до врага",
        [EN] = "Min distance to enemy",
    },
    ["optionTurn"] = {
        [RU] = "Когда использовать",
        [EN] = "When to use",
        [CN] = "",
    },
    ["Turn1"] = {
        [RU] = "Использовать перед станом",
        [EN] = "Use before Storm Hammer",
        [CN] = "",
    },
    ["Turn2"] = {
        [RU] = "Использовать после стана",
        [EN] = "Use after Storm Hammer",
        [CN] = "",
    },
    ["optionCombo"] = {
        [RU] = "Кнопка для комбо без ультимейта",
        [EN] = "Button for combo without ultimate",
        [CN] = "",
    },
    ["optionSatanicSlider"] = {
        [RU] = "Порог здоровья в %",
        [EN] = "HPercent Threshold",
        [CN] = "生命值百分比",
    },
    ["optionHit"] = {
        [RU] = "Наносить удар перед комбо",
        [EN] = "Strike before combo",
        [CN] = "",
    },
    ["optionArmlet"] = {
        [RU] = "Выключать после комбо",
        [EN] = "Disable after combo",
        [CN] = "",
    },
}




local rootPath = "Hero Specific"

local mainPath = {rootPath, "Sven"}

local settingsPath = {rootPath, "Sven", "Settings"}

local skillsPath = {rootPath, "Sven", "Skills"}

local itemsPath = {rootPath, "Sven", "Items"}




if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Sven"}
    settingsPath = {rootPath, "Sven", "Настройки"}
    skillsPath = {rootPath, "Sven", "Способности"}
    itemsPath = {rootPath, "Sven", "Предметы"}
end 

if language == CN then
    rootPath = "独立英雄脚本"
    mainPath = {rootPath, "Sven"}
    settingsPath = {rootPath, "Sven", ""}
    skillsPath = {rootPath, "Sven", ""}
    itemsPath = {rootPath, "Sven", ""}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------




-----------------------------------------------------------------------------------------------------------------------
Sven.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Sven.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_sven_png.vtex_c")

Sven.optionFullCombo = Menu.AddKeyOption(settingsPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Sven.optionFullCombo, "~/MenuIcons/enemy_evil.png")
Menu.AddMenuIcon(settingsPath, "~/MenuIcons/utils_wheel.png")

Sven.optionCombo = Menu.AddKeyOption(settingsPath, Translation.optionCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Sven.optionCombo, "~/MenuIcons/enemy_evil.png")

Sven.optionCursor = Menu.AddOptionBool(settingsPath, Translation.optionCursor[language], true)
Menu.AddOptionIcon(Sven.optionCursor, "~/MenuIcons/cursor.png")


Sven.optionIsTargetParticleEnabled = Menu.AddOptionBool(settingsPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Sven.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Sven.optionRangeToTarget = Menu.AddOptionSlider(settingsPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Sven.optionRangeToTarget, "~/MenuIcons/edit.png")

Sven.optionBlink = Menu.AddOptionBool(itemsPath, "Use Blink", true)
Menu.AddOptionIcon(Sven.optionBlink, "panorama/images/items/".."blink".."_png.vtex_c")
Sven.optionBlinkSlider = Menu.AddOptionSlider(itemsPath, Translation.optionBlinkSlider[language], 1, 2000, 1400) 
Menu.AddOptionIcon(Sven.optionBlinkSlider, "~/MenuIcons/edit.png")

Sven.optionSatanicSlider = Menu.AddOptionSlider(itemsPath, Translation.optionSatanicSlider[language], 1, 100, 30)
Menu.AddOptionIcon(Sven.optionSatanicSlider, "panorama/images/items/satanic_png.vtex_c")

Sven.optionHit = Menu.AddOptionBool(itemsPath, Translation.optionHit[language], true)
Menu.AddOptionIcon(Sven.optionHit, "panorama/images/items/silver_edge_png.vtex_c")

Sven.optionArmlet = Menu.AddOptionBool(itemsPath, Translation.optionArmlet[language], true)
Menu.AddOptionIcon(Sven.optionArmlet, "panorama/images/items/armlet_png.vtex_c")
---------------------------------------------------------------------------------------------------------------------------
Sven.optionStorm = Menu.AddOptionBool(skillsPath, "Storm Hammer", true)
Menu.AddOptionIcon(Sven.optionStorm, "panorama/images/spellicons/".."sven_storm_bolt".."_png.vtex_c")
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")


Sven.optionWarcry = Menu.AddOptionBool(skillsPath, "Warcry", true)
Menu.AddOptionIcon(Sven.optionWarcry, "panorama/images/spellicons/".."sven_warcry".."_png.vtex_c")

Sven.optionGod = Menu.AddOptionBool(skillsPath, "God's Strenght", true)
Menu.AddOptionIcon(Sven.optionGod, "panorama/images/spellicons/".."sven_gods_strength".."_png.vtex_c")
Sven.optionTurn = Menu.AddOptionCombo(skillsPath, Translation.optionTurn[language], { Translation.Turn1[language], Translation.Turn2[language] }, 1)
Menu.AddOptionIcon(Sven.optionTurn, "~/MenuIcons/lists/list_combo.png")


---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

Sven.itemsSelection = Menu.AddOptionMultiSelect(itemsPath, "Items Selection:", 
{
{"bloodthorn", "panorama/images/items/bloodthorn_png.vtex_c", true},
{"orchid", "panorama/images/items/orchid_png.vtex_c", true},
{"blackkingbar", "panorama/images/items/black_king_bar_png.vtex_c", false},
{"manta", "panorama/images/items/manta_png.vtex_c", true},
{"mjollnir", "panorama/images/items/mjollnir_png.vtex_c", true},
{"armlet", "panorama/images/items/armlet_png.vtex_c", true},
{"mask", "panorama/images/items/mask_of_madness_png.vtex_c", true},
{"abyssal", "panorama/images/items/abyssal_blade_png.vtex_c", true},
{"satanic", "panorama/images/items/satanic_png.vtex_c", true},
{"silver", "panorama/images/items/silver_edge_png.vtex_c", true},
{"shadow", "panorama/images/items/invis_sword_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")



------------------------------------------------------------------------------------------------------------------------



function Sven.OnUpdate()

    if (not Menu.IsEnabled(Sven.optionEnable)) then
        myHero = nil
        return
    end

    if (not myHero) then
        myHero = Heroes.GetLocal()
        return
    end 

    if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_sven" then 
        return
    end

    if (not myPlayer) then
        myPlayer = Players.GetLocal()
        return
    end
---------------------------------------
--Мана героя
    local mana = NPC.GetMana(myHero)
-----------------------------------------



--Способности ищем

    if (not storm) then
        storm = NPC.GetAbility(myHero, "sven_storm_bolt")
        return
    end

    if (not warcry) then
        warcry = NPC.GetAbility(myHero, "sven_warcry")
        return
    end
    
    if (not god) then
       god = NPC.GetAbility(myHero, "sven_gods_strength")
       return
    end

----------------------------------------------------------------------------



--Предметы


    local bloodthorn = Sven.CheckItem("item_bloodthorn")

    local orchid = Sven.CheckItem("item_orchid")

    local blackkingbar = Sven.CheckItem("item_black_king_bar")

    local manta = Sven.CheckItem("item_manta")

    local blink = Sven.CheckItem("item_blink")

    local mjollnir = Sven.CheckItem("item_mjollnir")

    local armlet = Sven.CheckItem("item_armlet")

    local mask = Sven.CheckItem("item_mask_of_madness")

    local abyssal = Sven.CheckItem("item_abyssal_blade")

    local satanic = Sven.CheckItem("item_satanic")

    local silver = Sven.CheckItem("item_silver_edge")

    local shadow = Sven.CheckItem("item_invis_sword")


--------------------------------------------------------------------------------


--Врага ищем
    if not enemy then
        enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
    end
    if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Sven.optionRangeToTarget), 0) then
        enemy = nil
    end
    if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
        enemy = nil
    end

---------------------------------------------------------------------------------------------------

--Комбо
    if Menu.IsKeyDown(Sven.optionFullCombo) and enemy and (not NPC.IsChannellingAbility(myHero)) then
        local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
        local origin = Entity.GetOrigin(enemy)
        local value = Menu.GetValue(Sven.optionBlinkSlider)

        if (Menu.IsSelected(Sven.itemsSelection, "silver")) and  Sven.ItemNoTarget(silver, mana) == true then
            return
        end

        if (Menu.IsSelected(Sven.itemsSelection, "shadow")) and  Sven.ItemNoTarget(shadow, mana) == true then
            return
        end

        if Menu.IsEnabled(Sven.optionHit) then
            if NPC.GetModifier(myHero, "modifier_item_silver_edge_windwalk") or NPC.GetModifier(myHero, "modifier_item_invisibility_edge_windwalk") then
                if Sven.SleepReady(orderDelay5, lastMoveOrder5) then
                    Player.AttackTarget(myPlayer, myHero, enemy)
                    lastMoveOrder5 = os.clock()
                end
                return
            end
        end         

        if Sven.SleepReady(orderDelay2, lastMoveOrder2) then
            if  (Menu.IsSelected(Sven.itemsSelection, "armlet")) and armlet and not Ability.GetToggleState(armlet) and not accept then
                Ability.Toggle(armlet)
                return
            end
            lastMoveOrder2 = os.clock()
            accept = 1
        end    

        if  (Menu.IsSelected(Sven.itemsSelection, "mjollnir")) and Sven.ItemTarget(mjollnir, myHero, mana) == true then
            return
        end

        if  Menu.IsEnabled(Sven.optionWarcry) and Sven.Warcry(warcry, mana) == true then
            return
        end

        if  Menu.IsEnabled(Sven.optionGod) and Menu.GetValue(Sven.optionTurn) == 0 and Sven.God(god, mana) == true then
            return
        end

        if Sven.Blink(blink, origin, distance, value) == true then
            return
        end         
    
        if (Menu.IsSelected(Sven.itemsSelection, "bloodthorn")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Sven.ItemTarget(bloodthorn, enemy, mana) == true then
            return
        end
    
        if  (Menu.IsSelected(Sven.itemsSelection, "orchid")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and Sven.ItemTarget(orchid, enemy, mana) == true then
            return
        end

        if  Menu.IsEnabled(Sven.optionStorm) and Sven.Storm(storm, mana, enemy) == true then
            return
        end

        if  Menu.IsEnabled(Sven.optionGod) and Menu.GetValue(Sven.optionTurn) == 1 and Sven.God(god, mana) == true then
            return
        end
    
        if (Menu.IsSelected(Sven.itemsSelection, "manta")) and  Sven.ItemNoTarget(manta, mana) == true then
            return
        end

        if (Menu.IsSelected(Sven.itemsSelection, "mask")) and  Sven.ItemNoTarget(mask, mana) == true then
            return
        end

        if  (Menu.IsSelected(Sven.itemsSelection, "abyssal")) and Ability.SecondsSinceLastUse(storm) > 0.5 and not NPC.IsStunned(enemy) and Sven.ItemTargetAb(abyssal, enemy, mana) == true then
            return
        end

        if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(Sven.optionSatanicSlider) then
            if (Menu.IsSelected(Sven.itemsSelection, "satanic")) and not NPC.GetModifier(enemy, "modifier_oracle_false_promise") and  Sven.ItemNoTarget(satanic, mana) == true then
                return
            end
        end 
    
        if (Menu.IsSelected(Sven.itemsSelection, "blackkingbar")) and Sven.ItemNoTarget(blackkingbar, mana) == true then
            return
        end              

        if Sven.SleepReady(orderDelay, lastMoveOrder) then
            Player.AttackTarget(myPlayer, myHero, enemy)
            lastMoveOrder = os.clock()
        end 
    end





--Без ульты
    if Menu.IsKeyDown(Sven.optionCombo) and enemy and (not NPC.IsChannellingAbility(myHero)) then
        local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
        local origin = Entity.GetOrigin(enemy)
        local value = Menu.GetValue(Sven.optionBlinkSlider)

        if (Menu.IsSelected(Sven.itemsSelection, "silver")) and  Sven.ItemNoTarget(silver, mana) == true then
            return
        end

        if (Menu.IsSelected(Sven.itemsSelection, "shadow")) and  Sven.ItemNoTarget(shadow, mana) == true then
            return
        end

        if Menu.IsEnabled(Sven.optionHit) then
            if NPC.GetModifier(myHero, "modifier_item_silver_edge_windwalk") or NPC.GetModifier(myHero, "modifier_item_invisibility_edge_windwalk") then
                if Sven.SleepReady(orderDelay6, lastMoveOrder6) then
                    Player.AttackTarget(myPlayer, myHero, enemy)
                    lastMoveOrder6 = os.clock()
                end
                return
            end
        end 

        if Sven.SleepReady(orderDelay4, lastMoveOrder4) then
            if  (Menu.IsSelected(Sven.itemsSelection, "armlet")) and armlet and not Ability.GetToggleState(armlet) and not accept then
                Ability.Toggle(armlet)
                return
            end
            lastMoveOrder4 = os.clock()
            accept = 1
        end    

        if  (Menu.IsSelected(Sven.itemsSelection, "mjollnir")) and Sven.ItemTarget(mjollnir, myHero, mana) == true then
            return
        end

        if  Menu.IsEnabled(Sven.optionWarcry) and Sven.Warcry(warcry, mana) == true then
            return
        end

        if Sven.Blink(blink, origin, distance, value) == true then
            return
        end         
    
        if (Menu.IsSelected(Sven.itemsSelection, "bloodthorn")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Sven.ItemTarget(bloodthorn, enemy, mana) == true then
            return
        end
    
        if  (Menu.IsSelected(Sven.itemsSelection, "orchid")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and Sven.ItemTarget(orchid, enemy, mana) == true then
            return
        end

        if  Menu.IsEnabled(Sven.optionStorm) and Sven.Storm(storm, mana, enemy) == true then
            return
        end
    
        if (Menu.IsSelected(Sven.itemsSelection, "manta")) and  Sven.ItemNoTarget(manta, mana) == true then
            return
        end

        if (Menu.IsSelected(Sven.itemsSelection, "mask")) and  Sven.ItemNoTarget(mask, mana) == true then
            return
        end

        if  (Menu.IsSelected(Sven.itemsSelection, "abyssal")) and not NPC.IsStunned(enemy) and Sven.ItemTargetAb(abyssal, enemy, mana) == true then
            return
        end

        if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(Sven.optionSatanicSlider) then
            if (Menu.IsSelected(Sven.itemsSelection, "satanic")) and  Sven.ItemNoTarget(satanic, mana) == true then
                return
            end
        end 
    
        if (Menu.IsSelected(Sven.itemsSelection, "blackkingbar")) and Sven.ItemNoTarget(blackkingbar, mana) == true then
            return
        end              

        if Sven.SleepReady(orderDelay3, lastMoveOrder3) then
            Player.AttackTarget(myPlayer, myHero, enemy)
            lastMoveOrder3 = os.clock()
        end 
    end


--Преследовать курсор
    if Menu.IsEnabled(Sven.optionCursor) then
        if Menu.IsKeyDown(Sven.optionFullCombo) or Menu.IsKeyDown(Sven.optionCombo) then
            if (not enemy) and (not NPC.IsChannellingAbility(myHero)) then
                NPC.MoveTo(myHero, Input.GetWorldCursorPos())
            end     
        end 
    end


    if not Menu.IsKeyDown(Sven.optionFullCombo) and not Menu.IsKeyDown(Sven.optionCombo) then
        if Menu.IsEnabled(Sven.optionArmlet) then
            if Ability.GetToggleState(armlet) and accept then
                Ability.Toggle(armlet)
                accept = nil
            end    
        else    
            accept = nil
        end    
    end    
end




----------------------------------------------------------------------------------------
--Рисуем Партикль
function Sven.OnDraw()
    if (not myHero) then
        return
    end 

    if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_sven" then 
        return
    end
    local particleEnemy = enemy
    if Menu.IsEnabled(Sven.optionIsTargetParticleEnabled) then    
        if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Sven.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
            Particle.Destroy(targetParticle)            
            targetParticle = 0
            particleEnemy = enemy
        else
            if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Sven.optionRangeToTarget), 0) then
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
end     
---------------------------------------------------------------------------------------------------








--Функции способностей

function Sven.Storm(ability, mana, enemy)
    if Menu.IsEnabled(Sven.optionStorm) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability) and not NPC.GetModifier(enemy, "modifier_item_lotus_orb_active") and not NPC.GetModifier(enemy, "modifier_antimage_counterspell") and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) and not NPC.HasState(Heroes.GetLocal(), Enum.ModifierState.MODIFIER_STATE_SILENCED) then 
        Ability.CastTarget(ability, enemy)
        return true 
    end 
end

function Sven.Warcry(ability, mana)
    if Menu.IsEnabled(Sven.optionWarcry) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability) and not NPC.HasState(Heroes.GetLocal(), Enum.ModifierState.MODIFIER_STATE_SILENCED)  then
        Ability.CastNoTarget(ability, mana)
        return true
    end 
end

function Sven.God(ability, mana)
    if Menu.IsEnabled(Sven.optionGod) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability) and not NPC.HasState(Heroes.GetLocal(), Enum.ModifierState.MODIFIER_STATE_SILENCED)  then
        Ability.CastNoTarget(ability, mana)
        return true
    end 
end





--Функции предметов

function Sven.ItemTarget(item, enemy, mana)
    if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) and not NPC.GetModifier(enemy, "modifier_item_lotus_orb_active") and not NPC.GetModifier(enemy, "modifier_antimage_counterspell") and not NPC.HasState(enemy, Enum.ModifierState.MODIFIER_STATE_MAGIC_IMMUNE) then
        Ability.CastTarget(item, enemy)
        return true  
    end   
end

function Sven.ItemTargetAb(item, enemy, mana)
    if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) and not NPC.GetModifier(enemy, "modifier_item_lotus_orb_active") and not NPC.GetModifier(enemy, "modifier_antimage_counterspell") then
        Ability.CastTarget(item, enemy)
        return true  
    end   
end

function Sven.ItemOrigin(item, origin, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastPosition(item, origin) 
        return true
    end   
end


function Sven.ItemNoTarget(item, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastNoTarget(item)
        return true  
    end   
end

function Sven.Blink(item, origin, distance, value)
    if Menu.IsEnabled(Sven.optionBlink) and item and Ability.IsReady(item) and distance < value and distance > 500  then
        Ability.CastPosition(item, origin)
        return true
    end 
end



--Проверка на слоты
function Sven.CheckItem(item)
    for i = 0, 5 do
        local itemCheck = NPC.GetItemByIndex(myHero, i)
        if itemCheck and item == Ability.GetName(itemCheck) then
            return itemCheck
        end
    end
end




function Sven.OnEntityDestroy(entity)
    if not myHero then 
        return
    end 

    if entity == myHero then
        Sven.Reinit()
        return
    end 
end 

function Sven.Reinit()
    myHero, myPlayer, enemy, storm, warcry, god = nil, nil, nil, nil, nil, nil

    particleEnemy = nil 
end

return Sven