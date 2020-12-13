local OD = {}

local myHero, myPlayer, enemy, orb, astral, flux = nil, nil, nil, nil, nil, nil


------------------------------------------------
local targetParticle = 0
------------------------------------------------



--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1 

local lastMoveOrder2 = 0
local orderDelay2 = 0.1

local lastMoveOrder3 = 0
local orderDelay3 = 1

local lastMoveOrder4 = 0
local orderDelay4 = 1  

local lastMoveOrder5 = 0
local orderDelay5 = 1

local lastMoveOrder6 = 0
local orderDelay6 = 3 

local lastMoveOrder7 = 0
local orderDelay7 = 0.1

function OD.SleepReady(sleep, lastTick)
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
    ["optionOrbSlider"] = {
        [RU] = "Использовать, пока маны больше чем %",
        [EN] = "Use while more mana than %",
    },
    ["optionTurn"] = {
        [RU] = "Когда использовать",
        [EN] = "When to use",
        [CN] = "",
    },
    ["Turn1"] = {
        [RU] = "Использовать в начале",
        [EN] = "Use at the beginning",
        [CN] = "",
    },
    ["Turn2"] = {
        [RU] = "Использовать в конце",
        [EN] = "Use at the end",
        [CN] = "",
    },
    ["optionAstralMove"] = {
        [RU] = "Двигаться к центру астрала",
        [EN] = "Move to the center of the Astral",
        [CN] = "",
    },
    ["optionCurrent"] = {
        [RU] = "Оставлять заряд Астрала, если есть Аганим",
        [EN] = "Leave a charge of the Astral if there is an Aghanim",
        [CN] = "",
    },
}




local rootPath = "Hero Specific"

local mainPath = {rootPath, "Outworld Devourer"}

local settingsPath = {rootPath, "Outworld Devourer", "Settings"}

local skillsPath = {rootPath, "Outworld Devourer", "Skills"}

local itemsPath = {rootPath, "Outworld Devourer", "Items"}

local linkenPath = {rootPath, "Outworld Devourer", "Linken Breaker"}



if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Outworld Devourer"}
    skillsPath = {rootPath, "Outworld Devourer", "Способности"}
    itemsPath = {rootPath, "Outworld Devourer", "Предметы"}
    linkenPath = {rootPath, "Outworld Devourer", "Сбитие Линки"}
end 

if language == CN then
    rootPath = "独立英雄脚本"
    mainPath = {rootPath, "Outworld Devourer"}
    skillsPath = {rootPath, "Outworld Devourer", ""}
    itemsPath = {rootPath, "Outworld Devourer", ""}
    linkenPath = {rootPath, "Outworld Devourer", ""}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------




-----------------------------------------------------------------------------------------------------------------------
OD.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(OD.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_obsidian_destroyer_png.vtex_c")

OD.optionFullCombo = Menu.AddKeyOption(settingsPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(OD.optionFullCombo, "~/MenuIcons/enemy_evil.png")
Menu.AddMenuIcon(settingsPath, "~/MenuIcons/utils_wheel.png")

OD.optionCursor = Menu.AddOptionBool(settingsPath, Translation.optionCursor[language], true)
Menu.AddOptionIcon(OD.optionCursor, "~/MenuIcons/cursor.png")


OD.optionIsTargetParticleEnabled = Menu.AddOptionBool(settingsPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(OD.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
OD.optionRangeToTarget = Menu.AddOptionSlider(settingsPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(OD.optionRangeToTarget, "~/MenuIcons/edit.png")

OD.optionBlink = Menu.AddOptionBool(itemsPath, "Use Blink", true)
Menu.AddOptionIcon(OD.optionBlink, "panorama/images/items/".."blink".."_png.vtex_c")
OD.optionBlinkSlider = Menu.AddOptionSlider(itemsPath, Translation.optionBlinkSlider[language], 1, 2000, 1400) 
Menu.AddOptionIcon(OD.optionBlinkSlider, "~/MenuIcons/edit.png")
---------------------------------------------------------------------------------------------------------------------------
OD.optionOrb = Menu.AddOptionBool(skillsPath, "Arcane Orb", true)
Menu.AddOptionIcon(OD.optionOrb, "panorama/images/spellicons/".."obsidian_destroyer_arcane_orb".."_png.vtex_c")
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

OD.optionOrbSlider = Menu.AddOptionSlider(skillsPath, Translation.optionOrbSlider[language], 1, 100, 30)
Menu.AddOptionIcon(OD.optionOrbSlider, "~/MenuIcons/edit.png")

OD.optionAstral = Menu.AddOptionBool(skillsPath, "Astral Imprisonment", true)
Menu.AddOptionIcon(OD.optionAstral, "panorama/images/spellicons/".."obsidian_destroyer_astral_imprisonment".."_png.vtex_c")
OD.optionTurn = Menu.AddOptionCombo(skillsPath, Translation.optionTurn[language], { Translation.Turn1[language], Translation.Turn2[language] }, 0)
Menu.AddOptionIcon(OD.optionTurn, "~/MenuIcons/lists/list_combo.png")
OD.optionAstralMove = Menu.AddOptionBool(skillsPath, Translation.optionAstralMove[language], true)
Menu.AddOptionIcon(OD.optionAstralMove, "~/MenuIcons/enable/enable_ios.png")
OD.optionCurrent = Menu.AddOptionBool(skillsPath, Translation.optionCurrent[language], true)
Menu.AddOptionIcon(OD.optionCurrent, "~/MenuIcons/enable/enable_ios.png")

OD.optionFlux = Menu.AddOptionBool(skillsPath, "Essence Flux", true)
Menu.AddOptionIcon(OD.optionFlux, "panorama/images/spellicons/".."obsidian_destroyer_equilibrium".."_png.vtex_c")


---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

OD.itemsSelection = Menu.AddOptionMultiSelect(itemsPath, "Items Selection:", 
{
{"sheepstick", "panorama/images/items/sheepstick_png.vtex_c", true},
{"bloodthorn", "panorama/images/items/bloodthorn_png.vtex_c", true},
{"orchid", "panorama/images/items/orchid_png.vtex_c", true},
{"shivasguard", "panorama/images/items/shivas_guard_png.vtex_c", true},
{"veil", "panorama/images/items/veil_of_discord_png.vtex_c", true},
{"hurricanepike", "panorama/images/items/hurricane_pike_png.vtex_c", false},
{"blackkingbar", "panorama/images/items/black_king_bar_png.vtex_c", false},
{"manta", "panorama/images/items/manta_png.vtex_c", true},
{"atos", "panorama/images/items/rod_of_atos_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")



------------------------------------------------------------------------------------------------------------------------
OD.linkenSelection = Menu.AddOptionMultiSelect(linkenPath, "Linken Breaker Selection:", 
{
{"hurricanepike", "panorama/images/items/hurricane_pike_png.vtex_c", false},
{"atos", "panorama/images/items/rod_of_atos_png.vtex_c", true},
{"astral", "panorama/images/spellicons/".."obsidian_destroyer_astral_imprisonment".."_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(linkenPath, "panorama/images/items/".."sphere".."_png.vtex_c")

-----------------------------------------------------------------------------------------------------------------------

local turn = {
    [0] = Translation.Turn1[language],
    [1] = Translation.Turn2[language]
}


function OD.OnUpdate()

    if (not Menu.IsEnabled(OD.optionEnable)) then
        myHero = nil
        return
    end

    if (not myHero) then
        myHero = Heroes.GetLocal()
        return
    end 

    if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_obsidian_destroyer" then 
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

    if (not orb) then
        orb = NPC.GetAbility(myHero, "obsidian_destroyer_arcane_orb")
        return
    end

    if (not astral) then
        astral = NPC.GetAbility(myHero, "obsidian_destroyer_astral_imprisonment")
        return
    end
    
    if (not flux) then
        flux = NPC.GetAbility(myHero, "obsidian_destroyer_equilibrium")
        return
    end

----------------------------------------------------------------------------



--Предметы

    local sheepstick = OD.CheckItem("item_sheepstick")

    local bloodthorn = OD.CheckItem("item_bloodthorn")

    local orchid = OD.CheckItem("item_orchid")

    local shivasguard = OD.CheckItem("item_shivas_guard")

    local blackkingbar = OD.CheckItem("item_black_king_bar")

    local atos = OD.CheckItem("item_rod_of_atos")

    local veil = OD.CheckItem("item_veil_of_discord")

    local hurricanepike = OD.CheckItem("item_hurricane_pike")

    local manta = OD.CheckItem("item_manta")

    local blink = OD.CheckItem("item_blink")

    local scepter = OD.CheckItem("item_ultimate_scepter")


--------------------------------------------------------------------------------

    local items = {
    ["atos"] = atos,
    ["astral"] = astral,
    ["hurricanepike"] = hurricanepike
    }


--Врага ищем
    if not enemy then
        enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
    end
    if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(OD.optionRangeToTarget), 0) then
        enemy = nil
    end
    if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
        enemy = nil
    end
---------------------------------------------------------------------------------------------------

--Полное комбо

    if Menu.IsKeyDown(OD.optionFullCombo) and enemy and (not NPC.IsChannellingAbility(myHero)) and (not NPC.GetModifier(enemy, "modifier_black_king_bar_immune")) and (not NPC.GetModifier(enemy, "modifier_life_stealer_rage")) and (not NPC.GetModifier(enemy, "modifier_juggernaut_blade_fury")) and not NPC.GetModifier(enemy, "modifier_item_lotus_orb_active") and not NPC.GetModifier(enemy, "modifier_antimage_counterspell")  then
        local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
        local origin = Entity.GetOrigin(enemy)
        local value = Menu.GetValue(OD.optionBlinkSlider)
        local orbvalue = Menu.GetValue(OD.optionOrbSlider)

        if not NPC.GetModifier(myHero, "modifier_item_hurricane_pike_range") and Ability.GetAutoCastState(orb) and not accept  then  
            Ability.ToggleMod(orb)
            accept = 1
            return
        end

        if not Ability.GetAutoCastState(orb) then
            accept = nil  
        end     

        if OD.Blink(blink, origin, distance, value) == true then
            return
        end

        if NPC.IsLinkensProtected(enemy) then
            local TableLinken = Menu.GetItems(OD.linkenSelection)
            for i = 1, #TableLinken do
                local item = items[TableLinken[i]]
                if (Menu.IsSelected(OD.linkenSelection, TableLinken[i])) then
                	if OD.SleepReady(orderDelay7, lastMoveOrder7) then
                    	if OD.Breaker(item, enemy, mana) == true then
                    	    return
                    	end 
                    	lastMoveOrder7 = os.clock()
                    end	    
                end
            end  
        end

        if NPC.IsLinkensProtected(enemy) then 
        	return
        end	

        if scepter or NPC.GetModifier(myHero, "modifier_item_ultimate_scepter_consumed") then
            if Menu.IsEnabled(OD.optionCurrent) then
                if Ability.GetCurrentCharges(astral) > 1 then
                    if Menu.IsEnabled(OD.optionAstral) and Menu.GetValue(OD.optionTurn) == 0 and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and not NPC.GetModifier(enemy, "modifier_sheepstick_debuff") and not NPC.GetModifier(enemy, "modifier_rod_of_atos_debuff") and not NPC.IsStunned(enemy) and OD.Astral(astral, mana, enemy) == true then
                        return
                    end
                end
            else
                if OD.SleepReady(orderDelay6, lastMoveOrder6) then
                    if Menu.IsEnabled(OD.optionAstral) and Menu.GetValue(OD.optionTurn) == 0 and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and not NPC.GetModifier(enemy, "modifier_sheepstick_debuff") and not NPC.GetModifier(enemy, "modifier_rod_of_atos_debuff") and not NPC.IsStunned(enemy) and OD.Astral(astral, mana, enemy) == true then
                        return
                    end
                    lastMoveOrder6 = os.clock()
                end        
            end
        end

        if not scepter and not NPC.GetModifier(myHero, "modifier_item_ultimate_scepter_consumed") then
            if Menu.IsEnabled(OD.optionAstral) and Menu.GetValue(OD.optionTurn) == 0 and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and not NPC.GetModifier(enemy, "modifier_sheepstick_debuff") and not NPC.GetModifier(enemy, "modifier_rod_of_atos_debuff") and not NPC.IsStunned(enemy) and OD.Astral(astral, mana, enemy) == true then
                return
            end 
        end    


        if Menu.IsEnabled(OD.optionAstralMove) and NPC.GetModifier(enemy, "modifier_obsidian_destroyer_astral_imprisonment_prison") then
            if OD.SleepReady(orderDelay4, lastMoveOrder4) then
                NPC.MoveTo(myHero, origin)
                lastMoveOrder4 = os.clock()
            end    
        end 

        if not NPC.GetModifier(enemy, "modifier_obsidian_destroyer_astral_imprisonment_prison") then
            if (Menu.IsSelected(OD.itemsSelection, "sheepstick")) and not NPC.IsStunned(enemy) and OD.ItemTarget(sheepstick, enemy, mana) == true then
                return
            end
    
            if  (Menu.IsSelected(OD.itemsSelection, "atos")) and not NPC.GetModifier(enemy, "modifier_sheepstick_debuff") and OD.ItemTarget(atos, enemy, mana) == true then 
                return
            end            
    
            if (Menu.IsSelected(OD.itemsSelection, "bloodthorn")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and OD.ItemTarget(bloodthorn, enemy, mana) == true then
                return
            end
    
            if  (Menu.IsSelected(OD.itemsSelection, "orchid")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and OD.ItemTarget(orchid, enemy, mana) == true then
                return
            end
    
            if  (Menu.IsSelected(OD.itemsSelection, "veil")) and OD.ItemOrigin(veil, origin, mana) == true then
                return
            end
    
            if (Menu.IsSelected(OD.itemsSelection, "shivasguard")) and  OD.ItemNoTarget(shivasguard, mana) == true then
                return
            end
    
            if (Menu.IsSelected(OD.itemsSelection, "manta")) and  OD.ItemNoTarget(manta, mana) == true then
                return
            end
    
            if (Menu.IsSelected(OD.itemsSelection, "blackkingbar")) and OD.ItemNoTarget(blackkingbar, mana) == true then
                return
            end
    
            if  Menu.IsEnabled(OD.optionFlux) and OD.Flux(flux, mana) == true then
                return
            end
        end

        if (Menu.IsSelected(OD.itemsSelection, "hurricanepike")) and OD.Hurricane(hurricanepike, enemy, distance, mana) == true then
            return
        end        

        if NPC.GetModifier(myHero, "modifier_item_hurricane_pike_range") then
            if OD.SleepReady(orderDelay5, lastMoveOrder5) then
                if not Ability.GetAutoCastState(orb) then
                    Ability.ToggleMod(orb)
                    return
                end
                lastMoveOrder5 = os.clock()
            end    
            if OD.SleepReady(orderDelay2, lastMoveOrder2) then
                if Ability.GetAutoCastState(orb) then
                    Player.AttackTarget(myPlayer, myHero, enemy)
                end    
                lastMoveOrder2 = os.clock()
            end 
            return   
        end 

        if scepter or NPC.GetModifier(myHero, "modifier_item_ultimate_scepter_consumed") then
            if Menu.IsEnabled(OD.optionCurrent) then
                if Ability.GetCurrentCharges(astral) > 1 then
                    if  Menu.IsEnabled(OD.optionAstral) and Menu.GetValue(OD.optionTurn) == 1 and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and not NPC.GetModifier(enemy, "modifier_sheepstick_debuff") and not NPC.GetModifier(enemy, "modifier_rod_of_atos_debuff") and not NPC.IsStunned(enemy) and OD.Astral(astral, mana, enemy) == true then
                        return
                    end
                end
            else
                if  Menu.IsEnabled(OD.optionAstral) and Menu.GetValue(OD.optionTurn) == 1 and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and not NPC.GetModifier(enemy, "modifier_sheepstick_debuff") and not NPC.GetModifier(enemy, "modifier_rod_of_atos_debuff") and not NPC.IsStunned(enemy) and OD.Astral(astral, mana, enemy) == true then
                    return
                end    
            end
        end 

        if not scepter and not NPC.GetModifier(myHero, "modifier_item_ultimate_scepter_consumed") then
            if  Menu.IsEnabled(OD.optionAstral) and Menu.GetValue(OD.optionTurn) == 1 and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and not NPC.GetModifier(enemy, "modifier_sheepstick_debuff") and not NPC.GetModifier(enemy, "modifier_rod_of_atos_debuff") and not NPC.IsStunned(enemy) and OD.Astral(astral, mana, enemy) == true then
                return
            end  
        end            

        if Menu.IsEnabled(OD.optionAstralMove) and NPC.GetModifier(enemy, "modifier_obsidian_destroyer_astral_imprisonment_prison") then
            if OD.SleepReady(orderDelay3, lastMoveOrder3) then
                NPC.MoveTo(myHero, origin)
                lastMoveOrder3 = os.clock()
            end    
        end    

        if  Menu.IsEnabled(OD.optionOrb) and (100/(NPC.GetMaxMana(myHero)/mana)) > orbvalue and OD.Orb(orb, mana, enemy) == true then
            return
        end

        if OD.SleepReady(orderDelay, lastMoveOrder) then
            Player.AttackTarget(myPlayer, myHero, enemy)
            lastMoveOrder = os.clock()
        end 
    end             

--Преследовать курсор
    if Menu.IsEnabled(OD.optionCursor) then
        if Menu.IsKeyDown(OD.optionFullCombo) then
            if (not enemy) and (not NPC.IsChannellingAbility(myHero)) then
                NPC.MoveTo(myHero, Input.GetWorldCursorPos())
            end     
        end 
    end         
------------------------------------------------------------------------------- 
end





----------------------------------------------------------------------------------------
--Рисуем Партикль
function OD.OnDraw()
    if (not myHero) then
        return
    end 

    if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_obsidian_destroyer" then 
        return
    end
    local particleEnemy = enemy
    if Menu.IsEnabled(OD.optionIsTargetParticleEnabled) then    
        if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(OD.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
            Particle.Destroy(targetParticle)            
            targetParticle = 0
            particleEnemy = enemy
        else
            if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(OD.optionRangeToTarget), 0) then
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

function OD.Orb(ability, mana, enemy)
    if Menu.IsEnabled(OD.optionOrb) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability) then
        Ability.CastTarget(ability, enemy)
        return true 
    end 
end

function OD.Astral(ability, mana, enemy)
    if Menu.IsEnabled(OD.optionAstral) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability) then
        Ability.CastTarget(ability, enemy)
        return true
    end 
end

function OD.Flux(ability, mana)
    if Menu.IsEnabled(OD.optionFlux) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
        Ability.CastNoTarget(ability, mana)
        return true
    end 
end





--Функции предметов

function OD.ItemTarget(item, enemy, mana)
    if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastTarget(item, enemy)
        return true  
    end   
end

function OD.ItemOrigin(item, origin, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastPosition(item, origin) 
        return true
    end   
end


function OD.ItemNoTarget(item, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastNoTarget(item)
        return true  
    end   
end

function OD.Blink(item, origin, distance, value)
    if Menu.IsEnabled(OD.optionBlink) and item and Ability.IsReady(item) and distance < value and distance > 500  then
        Ability.CastPosition(item, origin)
        return true
    end 
end

function OD.Hurricane(item, enemy, distance, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) and distance < 400 then
        Ability.CastTarget(item, enemy)  
        return true
    end   
end




--Проверка на слоты
function OD.CheckItem(item)
    for i = 0, 5 do
        local itemCheck = NPC.GetItemByIndex(myHero, i)
        if itemCheck and item == Ability.GetName(itemCheck) then
            return itemCheck
        end
    end
end


--Сбитие Линки
function OD.Breaker(item, enemy, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastTarget(item, enemy)  
        return true
    end   
end



function OD.OnEntityDestroy(entity)
    if not myHero then 
        return
    end 

    if entity == myHero then
        OD.Reinit()
        return
    end 
end 

function OD.Reinit()
    myHero, myPlayer, enemy, orb, astral, flux = nil, nil, nil, nil, nil, nil

    particleEnemy = nil
 
end 



return OD