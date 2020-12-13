local Spectre = {}

local myHero, myPlayer, enemy, dagger, haunt, reality = nil, nil, nil, nil, nil, nil

local hasTeleported = false 
--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1 

local lastMoveOrder2 = 0
local orderDelay2 = 0.5

function Spectre.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end
--------------------------------------------------



------------------------------------------------
local targetParticle = 0
------------------------------------------------




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
    ["optionSatanicSlider"] = {
        [RU] = "Порог здоровья в %",
        [EN] = "HPercent Threshold",
        [CN] = "生命值百分比",
    },
}






-------------------------------------------------------------------------------------------------------------------------------------------------

 


local rootPath = "Hero Specific"

local mainPath = {rootPath, "Spectre"}

local settingsPath = {rootPath, "Spectre", "Settings"}

local skillsPath = {rootPath, "Spectre", "Skills"}

local itemsPath = {rootPath, "Spectre", "Items"}


if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Spectre"}
    skillsPath = {rootPath, "Spectre", "Способности"}
    itemsPath = {rootPath, "Spectre", "Предметы"}
end 


if language == CN then
    rootPath = "独立英雄脚本"
    mainPath = {rootPath, "Spectre"}
    settingsPath = {rootPath, "Spectre", ""}
    skillsPath = {rootPath, "Spectre", ""}
    itemsPath = {rootPath, "Spectre", ""}
end 

------------------------------------------------------------------------------------------------------------------------------------------------------------




-----------------------------------------------------------------------------------------------------------------------
Spectre.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Spectre.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_spectre_png.vtex_c")

Spectre.optionFullCombo = Menu.AddKeyOption(settingsPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Spectre.optionFullCombo, "~/MenuIcons/enemy_evil.png")
Menu.AddMenuIcon(settingsPath, "~/MenuIcons/utils_wheel.png")

Spectre.optionCursor = Menu.AddOptionBool(settingsPath, Translation.optionCursor[language], true)
Menu.AddOptionIcon(Spectre.optionCursor, "~/MenuIcons/cursor.png")

Spectre.optionIsTargetParticleEnabled = Menu.AddOptionBool(settingsPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Spectre.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Spectre.optionRangeToTarget = Menu.AddOptionSlider(settingsPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Spectre.optionRangeToTarget, "~/MenuIcons/edit.png")

---------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------


Spectre.skillsSelection = Menu.AddOptionMultiSelect(skillsPath, "Skills Selection:", 
{
{"dagger", "panorama/images/spellicons/".."spectre_spectral_dagger".."_png.vtex_c", true},
{"haunt", "panorama/images/spellicons/".."spectre_haunt".."_png.vtex_c", true},
{"reality", "panorama/images/spellicons/".."spectre_reality".."_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")



---------------------------------------------------------------------------------------------------


Spectre.optionSatanicSlider = Menu.AddOptionSlider(itemsPath, Translation.optionSatanicSlider[language], 1, 100, 30)
Menu.AddOptionIcon(Spectre.optionSatanicSlider, "panorama/images/items/satanic_png.vtex_c")
-----------------------------------------------------------------------------------------------
Spectre.itemsSelection = Menu.AddOptionMultiSelect(itemsPath, "Items Selection:", 
{
{"bloodthorn", "panorama/images/items/bloodthorn_png.vtex_c", true},
{"orchid", "panorama/images/items/orchid_png.vtex_c", true},
{"blackkingbar", "panorama/images/items/black_king_bar_png.vtex_c", false},
{"manta", "panorama/images/items/manta_png.vtex_c", true},
{"mjollnir", "panorama/images/items/mjollnir_png.vtex_c", true},
{"abyssal", "panorama/images/items/abyssal_blade_png.vtex_c", true},
{"satanic", "panorama/images/items/satanic_png.vtex_c", true},
{"blademail", "panorama/images/items/blade_mail_png.vtex_c", true},
{"diffusal", "panorama/images/items/diffusal_blade_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

---------------------------------------------Главнвя функция------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
function Spectre.OnUpdate()

	if (not Menu.IsEnabled(Spectre.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_spectre" then 
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

	if (not dagger) then
		dagger = NPC.GetAbility(myHero, "spectre_spectral_dagger")
		return
	end

	if (not haunt) then
		haunt = NPC.GetAbility(myHero, "spectre_haunt")
		return
	end

	if (not reality) then
		reality = NPC.GetAbility(myHero, "spectre_reality")
		return
	end
----------------------------------------------------------------------------


--Предметы

	local bloodthorn = Spectre.CheckItem("item_bloodthorn")

    local orchid = Spectre.CheckItem("item_orchid")

    local blackkingbar = Spectre.CheckItem("item_black_king_bar")

    local manta = Spectre.CheckItem("item_manta")

    local mjollnir = Spectre.CheckItem("item_mjollnir")

    local abyssal = Spectre.CheckItem("item_abyssal_blade")

    local satanic = Spectre.CheckItem("item_satanic")

    local blademail = Spectre.CheckItem("item_blade_mail")

    local diffusal = Spectre.CheckItem("item_diffusal_blade")


--------------------------------------------------------------------------------



--Врага ищем
	if not enemy then
		enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	end
	if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Spectre.optionRangeToTarget), 0) then
		hasTeleported = false
		enemy = nil
	end
	if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
		enemy = nil
	end

---------------------------------------------------------------------------------------------------
--Полное комбо

	if Menu.IsKeyDown(Spectre.optionFullCombo) and enemy then
		if Spectre.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, myHero, enemy)
			lastMoveOrder = os.clock()
		end	

		local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
		local origin = Entity.GetOrigin(enemy)

		if Spectre.Haunt(haunt, mana, enemy) == true then
			return
		end		

		if Spectre.SleepReady(orderDelay2, lastMoveOrder2) then
			if distance > 500 and Spectre.Reality(reality, mana, origin) == true then
				return
			end	
			lastMoveOrder2 = os.clock()
		end

		if (Menu.IsSelected(Spectre.itemsSelection, "bloodthorn")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Spectre.ItemTarget(bloodthorn, enemy, mana) == true then
			return
		end

		if  (Menu.IsSelected(Spectre.itemsSelection, "orchid")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and Spectre.ItemTarget(orchid, enemy, mana) == true then
			return
		end

		if Spectre.Dagger(dagger, mana, enemy) == true then
			return
		end

		if  (Menu.IsSelected(Spectre.itemsSelection, "abyssal")) and not NPC.IsStunned(enemy) and Spectre.ItemTarget(abyssal, enemy, mana) == true then
            return
        end

		if (Menu.IsSelected(Spectre.itemsSelection, "mjollnir")) and Spectre.ItemTarget(mjollnir, myHero, mana) == true then
			return
		end

		if (Menu.IsSelected(Spectre.itemsSelection, "manta")) and Spectre.ItemNoTarget(manta, mana) == true then
			return
		end

		if  (Menu.IsSelected(Spectre.itemsSelection, "diffusal")) and not NPC.IsStunned(enemy) and Spectre.ItemTarget(diffusal, enemy, mana) == true then
            return
        end
	
		if (Menu.IsSelected(Spectre.itemsSelection, "blackkingbar")) and Spectre.ItemNoTarget(blackkingbar, mana) == true then
			return
		end

		if (Menu.IsSelected(Spectre.itemsSelection, "blademail")) and Spectre.ItemNoTarget(blademail, mana) == true then
			return
		end

		if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(Spectre.optionSatanicSlider) then
            if (Menu.IsSelected(Spectre.itemsSelection, "satanic")) and not NPC.GetModifier(enemy, "modifier_oracle_false_promise") and  Spectre.ItemNoTarget(satanic, mana) == true then
                return
            end
        end 
	end	
-------------------------------------------------------------------------------	
	--Преследовать курсор
    if Menu.IsEnabled(Spectre.optionCursor) then
        if Menu.IsKeyDown(Spectre.optionFullCombo) then
            if (not enemy) and (not NPC.IsChannellingAbility(myHero)) then
                NPC.MoveTo(myHero, Input.GetWorldCursorPos())
            end     
        end 
    end		
end


----------------------------------------------------------------------------------------
--Рисуем Партикль
function Spectre.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_spectre" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(Spectre.optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Spectre.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Spectre.optionRangeToTarget), 0) then
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

function Spectre.Dagger(ability, mana, enemy)
	if (Menu.IsSelected(Spectre.skillsSelection, "dagger")) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastTarget(ability, enemy)
    	return true 
    end	
end


function Spectre.Haunt(ability, mana, enemy) 
	if (Menu.IsSelected(Spectre.skillsSelection, "haunt")) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
		Ability.CastNoTarget(ability)
		hasTeleported = false
    	return true
    end	 
end

function Spectre.Reality(ability, mana, origin) 
	if (Menu.IsSelected(Spectre.skillsSelection, "reality")) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not hasTeleported then
		Ability.CastPosition(ability, origin) 
		hasTeleported = true
    	return true
    end	 
end

-----------------------------------------------------------------------------------------------------------------------------


--Функции предметов

function Spectre.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Spectre.ItemOrigin(item, origin, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastPosition(item, origin) 
    	return true
    end	  
end


function Spectre.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end




--Проверка на слоты
function Spectre.CheckItem(item)
    for i = 0, 5 do
        local itemCheck = NPC.GetItemByIndex(myHero, i)
        if itemCheck and item == Ability.GetName(itemCheck) then
            return itemCheck
        end
    end
end


function Spectre.OnEntityDestroy(entity)
    if not myHero then 
        return
    end 

    if entity == myHero then
        Spectre.Reinit()
        return
    end 
end 

function Spectre.Reinit()
    myHero, myPlayer, enemy, dagger, haunt = nil, nil, nil, nil, nil

    particleEnemy = nil
end 



return Spectre