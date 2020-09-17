local Druid = {}

local myHero, myPlayer, enemy, bear = nil, nil, nil, nil


--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1 

function Druid.SleepReady(sleep, lastTick)
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
 
 
local language = EN
 
local LanguageItem = Menu.GetLanguageOptionId()
local menuLang = Menu.GetValue(LanguageItem)
if menuLang == 1 then -- ru
	language = RU
elseif menuLang == 0 then -- en
	language = EN
end




local Translation = {
    ["optionEnable"] = {
        [RU] = "Включение",
        [EN] = "Enable",
    },
    ["optionRangeToTarget"] = {
        [RU] = "Расстояние  от мышки до врага для комбо",
        [EN] = "Distance from mouse to enemy for combo",
    },
    ["optionFullCombo"] = {
    	[RU] = "Кнопка для полного комбо",
    	[EN] = "Button for full combo",
    },
    ["optionIsTargetParticleEnabled"] = {
    	[RU] = "Рисовать партикль захваченной цели",
    	[EN] = "Draws particle for current target",
    },
    ["optionAutoPhaseB"] = {
    	[RU] = "Авто-Фейзы",
    	[EN] = "Auto-Phase Boots",
    },
    ["optionSatanicSlider"] = {
    	[RU] = "Порог здоровья в %",
    	[EN] = "HPercent Threshold",
    },
    ["optionComboB"] = {
    	[RU] = "Кнопка для комбо медведем",
    	[EN] = "Button for combo bear",
    },
}


local rootPath = "Hero Specific"

local mainPath = {rootPath, "Lone Druid"}

local bearPath = {rootPath, "Lone Druid", "Bear"}

local particlePath = {rootPath, "Lone Druid", "Target of attack"}

local itemPathB = {rootPath, "Lone Druid", "Bear", "Items"}

local druidPath = {rootPath, "Lone Druid", "Druid"}



if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Lone Druid"}
    bearPath = {rootPath, "Lone Druid", "Медведь"}
    particlePath = {rootPath, "Lone Druid", "Цель атаки"}
    itemPathB = {rootPath, "Lone Druid", "Медведь", "Предметы"}
    druidPath = {rootPath, "Lone Druid", "Друид"}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------




-----------------------------------------------------------------------------------------------------------------------
Druid.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Druid.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_lone_druid_png.vtex_c")

Druid.optionFullCombo = Menu.AddKeyOption(mainPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Druid.optionFullCombo, "~/MenuIcons/enemy_evil.png")

Druid.optionComboB = Menu.AddKeyOption(mainPath, Translation.optionComboB[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Druid.optionComboB, "~/MenuIcons/enemy_evil.png")

Druid.optionIsTargetParticleEnabled = Menu.AddOptionBool(particlePath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Druid.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Druid.optionRangeToTarget = Menu.AddOptionSlider(particlePath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Druid.optionRangeToTarget, "~/MenuIcons/edit.png")
Menu.AddMenuIcon(particlePath, "~/MenuIcons/utils_wheel.png")
---------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------
--Медведь
Druid.optionAutoPhaseB = Menu.AddOptionBool(bearPath, Translation.optionAutoPhaseB[language], true)
Menu.AddOptionIcon(Druid.optionAutoPhaseB, "panorama/images/items/".."phase_boots".."_png.vtex_c")
Menu.AddMenuIcon(bearPath, "panorama\\images\\spellicons\\lone_druid_spirit_bear_png.vtex_c")


Druid.optionMjollnirB = Menu.AddOptionBool(itemPathB, "Mjollnir", true)
Menu.AddOptionIcon(Druid.optionMjollnirB, "panorama/images/items/".."mjollnir".."_png.vtex_c")
Menu.AddMenuIcon(itemPathB, "~/MenuIcons/utils_wheel.png")

Druid.optionBloodthornB = Menu.AddOptionBool(itemPathB, "Bloodthorn", true)
Menu.AddOptionIcon(Druid.optionBloodthornB, "panorama/images/items/".."bloodthorn".."_png.vtex_c")

Druid.optionOrchidMalevolenceB = Menu.AddOptionBool(itemPathB, "Orchid Malevolence", true)
Menu.AddOptionIcon(Druid.optionOrchidMalevolenceB, "panorama/images/items/".."orchid".."_png.vtex_c")

Druid.optionBladeMailB = Menu.AddOptionBool(itemPathB, "Blade Mail", true)
Menu.AddOptionIcon(Druid.optionBladeMailB, "panorama/images/items/".."blade_mail".."_png.vtex_c")

Druid.optionSatanicB = Menu.AddOptionBool(itemPathB, "Satanic", true)
Menu.AddOptionIcon(Druid.optionSatanicB, "panorama/images/items/".."satanic".."_png.vtex_c")
Druid.optionSatanicSliderB = Menu.AddOptionSlider(itemPathB, Translation.optionSatanicSlider[language], 1, 100, 30)
Menu.AddOptionIcon(Druid.optionSatanicSliderB, "~/MenuIcons/edit.png")

Druid.optionSolarCrestB = Menu.AddOptionBool(itemPathB, "Solar Crest", true) 
Menu.AddOptionIcon(Druid.optionSolarCrestB, "panorama/images/items/".."solar_crest".."_png.vtex_c")

Druid.optionMedallionOfCourageB = Menu.AddOptionBool(itemPathB, "Medallion Of Couragea", true)
Menu.AddOptionIcon(Druid.optionMedallionOfCourageB, "panorama/images/items/".."medallion_of_courage".."_png.vtex_c")

Druid.optionAbyssalBladeB = Menu.AddOptionBool(itemPathB, "Abyssal Blade", true)
Menu.AddOptionIcon(Druid.optionAbyssalBladeB, "panorama/images/items/".."abyssal_blade".."_png.vtex_c")

Druid.optionMaskOfMadnessB = Menu.AddOptionBool(itemPathB, "Mask Of Madness", true)
Menu.AddOptionIcon(Druid.optionMaskOfMadnessB, "panorama/images/items/".."mask_of_madness".."_png.vtex_c")
---------------------------------------------------------------------------------------------------------------------------
--Друид
Druid.optionMjollnir = Menu.AddOptionBool(druidPath, "Mjollnir", true)
Menu.AddOptionIcon(Druid.optionMjollnir, "panorama/images/items/".."mjollnir".."_png.vtex_c")
Menu.AddMenuIcon(druidPath, "panorama/images/heroes/icons/npc_dota_hero_lone_druid_png.vtex_c")

Druid.optionBloodthorn = Menu.AddOptionBool(druidPath, "Bloodthorn", true)
Menu.AddOptionIcon(Druid.optionBloodthorn, "panorama/images/items/".."bloodthorn".."_png.vtex_c")

Druid.optionOrchidMalevolence = Menu.AddOptionBool(druidPath, "Orchid Malevolence", true)
Menu.AddOptionIcon(Druid.optionOrchidMalevolence, "panorama/images/items/".."orchid".."_png.vtex_c")

Druid.optionBladeMail = Menu.AddOptionBool(druidPath, "Blade Mail", true)
Menu.AddOptionIcon(Druid.optionBladeMail, "panorama/images/items/".."blade_mail".."_png.vtex_c")

Druid.optionSatanic = Menu.AddOptionBool(druidPath, "Satanic", true)
Menu.AddOptionIcon(Druid.optionSatanic, "panorama/images/items/".."satanic".."_png.vtex_c")
Druid.optionSatanicSlider = Menu.AddOptionSlider(druidPath, Translation.optionSatanicSlider[language], 1, 100, 30)
Menu.AddOptionIcon(Druid.optionSatanicSlider, "~/MenuIcons/edit.png")

Druid.optionSolarCrest = Menu.AddOptionBool(druidPath, "Solar Crest", true) 
Menu.AddOptionIcon(Druid.optionSolarCrest, "panorama/images/items/".."solar_crest".."_png.vtex_c")

Druid.optionMedallionOfCourage = Menu.AddOptionBool(druidPath, "Medallion Of Couragea", true)
Menu.AddOptionIcon(Druid.optionMedallionOfCourage, "panorama/images/items/".."medallion_of_courage".."_png.vtex_c")

Druid.optionAbyssalBlade = Menu.AddOptionBool(druidPath, "Abyssal Blade", true)
Menu.AddOptionIcon(Druid.optionAbyssalBlade, "panorama/images/items/".."abyssal_blade".."_png.vtex_c")

Druid.optionMaskOfMadness = Menu.AddOptionBool(druidPath, "Mask Of Madness", true)
Menu.AddOptionIcon(Druid.optionMaskOfMadness, "panorama/images/items/".."mask_of_madness".."_png.vtex_c")

Druid.optionLotusOrb = Menu.AddOptionBool(druidPath, "Lotus Orb", true)
Menu.AddOptionIcon(Druid.optionLotusOrb, "panorama/images/items/".."lotus_orb".."_png.vtex_c")

Druid.optionBlackKingBar = Menu.AddOptionBool(druidPath, "Black King Bar", false)
Menu.AddOptionIcon(Druid.optionBlackKingBar, "panorama/images/items/".."black_king_bar".."_png.vtex_c")

Druid.optionSheepStick = Menu.AddOptionBool(druidPath, "Scythe of Vyse", true)
Menu.AddOptionIcon(Druid.optionSheepStick, "panorama/images/items/".."sheepstick".."_png.vtex_c")



---------------------------------------------Главнвя функция------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
function Druid.OnUpdate()

	if (not Menu.IsEnabled(Druid.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_lone_druid" then 
		return
	end

	if (not myPlayer) then
		myPlayer = Players.GetLocal()
		return
	end



	for index, npc in pairs(NPCs.GetAll()) do
		for i = 1, 4 do 
			if NPC.GetUnitName(npc) == ("npc_dota_lone_druid_bear" .. i) then
				bear = npc
			end
 		end		
	end

	
---------------------------------------
--Мана
	local mana = NPC.GetMana(myHero)

	local manaB = NPC.GetMana(bear)
	

--Предметы Мишки

	local phasebootsB = NPC.GetItem(bear, "item_phase_boots")

	local mjollnirB = NPC.GetItem(bear, "item_mjollnir")

	local abyssalbladeB = NPC.GetItem(bear, "item_abyssal_blade")

	local bloodthornB = NPC.GetItem(bear, "item_bloodthorn")

	local solarcrestB = NPC.GetItem(bear, "item_solar_crest") 

	local blademailB = NPC.GetItem(bear, "item_blade_mail")

	local satanicB = NPC.GetItem(bear, "item_satanic")

	local medallionofcourageB = NPC.GetItem(bear, "item_medallion_of_courage")

	local maskofmadnessB = NPC.GetItem(bear, "item_mask_of_madness")




--Предметы Друида

	local mjollnir = NPC.GetItem(myHero, "item_mjollnir")

	local abyssalblade = NPC.GetItem(myHero, "item_abyssal_blade")

	local bloodthorn = NPC.GetItem(myHero, "item_bloodthorn")

	local solarcrest = NPC.GetItem(myHero, "item_solar_crest") 

	local blademail = NPC.GetItem(myHero, "item_blade_mail")

	local satanic = NPC.GetItem(myHero, "item_satanic")

	local medallionofcourage = NPC.GetItem(myHero, "item_medallion_of_courage")

	local maskofmadness = NPC.GetItem(myHero, "item_mask_of_madness")

	local blackkingbar = NPC.GetItem(myHero, "item_black_king_bar")

	local lotusorb = NPC.GetItem(myHero, "item_lotus_orb")	

	local sheepstick = NPC.GetItem(myHero, "item_sheepstick")






--Врага ищем
	if not enemy then
		enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	end
	if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Druid.optionRangeToTarget), 0) then
		enemy = nil
	end
	if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
		enemy = nil
	end
---------------------------------------------------------------------------------------------------	

	
	if  Menu.IsEnabled(Druid.optionAutoPhaseB) and phasebootsB and NPC.IsRunning(bear) and Ability.IsReady(phasebootsB) then
		Ability.CastNoTarget(phasebootsB)
	end


--Полное комбо

	if Menu.IsKeyDown(Druid.optionFullCombo) and enemy then

		if Druid.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, myHero, enemy)
			Player.AttackTarget(myPlayer, bear, enemy)
			lastMoveOrder = os.clock()
		end

		if Menu.IsEnabled(Druid.optionMaskOfMadnessB) and Druid.ItemNoTarget(maskofmadnessB, manaB) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionBloodthornB) and Druid.ItemTarget(bloodthornB, enemy, manaB) == true then
			return
		end

		if  Menu.IsEnabled(Druid.optionOrchidMalevolenceB) and Druid.ItemTarget(orchidB, enemy, manaB) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionAbyssalBladeB) and Druid.ItemTarget(abyssalbladeB, enemy, manaB) == true then
			return
		end
		
		if Menu.IsEnabled(Druid.optionMjollnirB) and Druid.ItemTarget(mjollnirB, bear, manaB) == true then
			return
		end

		if satanicB and (100/(Entity.GetMaxHealth(bear)/Entity.GetHealth(bear))) < Menu.GetValue(Druid.optionSatanicSliderB) then
			if Menu.IsEnabled(Druid.optionSatanicB) and  Druid.ItemNoTarget(satanicB, manaB) == true then
				return
			end
		end	

		if Menu.IsEnabled(Druid.optionBladeMailB) and Druid.ItemNoTarget(blademailB, manaB) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionSolarCrestB) and Druid.ItemTarget(solarcrestB, enemy, manaB) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionMedallionOfCourageB) and Druid.ItemTarget(medallionofcourageB, enemy, manaB) == true then
			return
		end




		if Menu.IsEnabled(Druid.optionSheepStick) and Druid.ItemTarget(sheepstick, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionBlackKingBar) and Druid.ItemNoTarget(blackkingbar, mana) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionMaskOfMadness) and Druid.ItemNoTarget(maskofmadness, mana) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionBloodthorn) and Druid.ItemTarget(bloodthorn, enemy, mana) == true then
			return
		end

		if  Menu.IsEnabled(Druid.optionOrchidMalevolence) and Druid.ItemTarget(orchid, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionAbyssalBlade) and Druid.ItemTarget(abyssalblade, enemy, mana) == true then
			return
		end
		
		if Menu.IsEnabled(Druid.optionMjollnir) and Druid.ItemTarget(mjollnir, myHero, mana) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionLotusOrb) and Druid.ItemTarget(lotusorb, myHero, mana) == true then
			return
		end


		if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(Druid.optionSatanicSlider) then
			if Menu.IsEnabled(Druid.optionSatanic) and  Druid.ItemNoTarget(satanic, mana) == true then
				return
			end
		end	

		if Menu.IsEnabled(Druid.optionBladeMail) and Druid.ItemNoTarget(blademail, mana) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionSolarCrest) and Druid.ItemTarget(solarcrest, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionMedallionOfCourage) and Druid.ItemTarget(medallionofcourage, enemy, mana) == true then
			return
		end
	end



	if Menu.IsKeyDown(Druid.optionComboB) and enemy then

		if Druid.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, bear, enemy)
			lastMoveOrder = os.clock()
		end

		if Menu.IsEnabled(Druid.optionMaskOfMadnessB) and Druid.ItemNoTarget(maskofmadnessB, manaB) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionBloodthornB) and Druid.ItemTarget(bloodthornB, enemy, manaB) == true then
			return
		end

		if  Menu.IsEnabled(Druid.optionOrchidMalevolenceB) and Druid.ItemTarget(orchidB, enemy, manaB) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionAbyssalBladeB) and Druid.ItemTarget(abyssalbladeB, enemy, manaB) == true then
			return
		end
		
		if Menu.IsEnabled(Druid.optionMjollnirB) and Druid.ItemTarget(mjollnirB, bear, manaB) == true then
			return
		end

		if satanicB and (100/(Entity.GetMaxHealth(bear)/Entity.GetHealth(bear))) < Menu.GetValue(Druid.optionSatanicSliderB) then
			if Menu.IsEnabled(Druid.optionSatanicB) and  Druid.ItemNoTarget(satanicB, manaB) == true then
				return
			end
		end	

		if Menu.IsEnabled(Druid.optionBladeMailB) and Druid.ItemNoTarget(blademailB, manaB) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionSolarCrestB) and Druid.ItemTarget(solarcrestB, enemy, manaB) == true then
			return
		end

		if Menu.IsEnabled(Druid.optionMedallionOfCourageB) and Druid.ItemTarget(medallionofcourageB, enemy, manaB) == true then
			return
		end
	end		
end	







----------------------------------------------------------------------------------------
--Рисуем Партикль
function Druid.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_lone_druid" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(Druid.optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Druid.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Druid.optionRangeToTarget), 0) then
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


-------------------------------------------------------------------------------------------------------------------
--Функции предметов 
function Druid.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Druid.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end










return Druid