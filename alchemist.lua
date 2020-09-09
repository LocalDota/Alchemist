
local Alchemist = {}

local myHero, myPlayer, enemy, acid, concoction, rage, concoctionThrow = nil, nil, nil, nil, nil, nil, nil
------------------------------------------------------------
--Задержка

local lastMoveOrder = 0
local orderDelay = 0.1 

function Alchemist.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end


local lastMoveOrder2 = 0
local orderDelay2 = 0.2 
-------------------------------------------------------------
--Таргет Партикль
	local targetParticle = 0
--------------------------------------------------------------
--------------------------------------------------------------
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
    	[RU] = "Кнопка для комбо",
    	[EN] = "Combo button",
    },
    ["optionConcoctionSlider"] = {
    	[RU] = "Кол-во секунд до броска",
    	[EN] = "How many seconds to throw",
    },
    ["optionSatanicSlider"] = {
    	[RU] = "Порог здоровья в %",
    	[EN] = "HPercent Threshold",
    },
    ["optionBlinkSlider"] = {
    	[RU] = "Минимальная дистанция до врага",
    	[EN] = "Min distance to enemy",
    },
    ["optionIsTargetParticleEnabled"] = {
    	[RU] = "Рисовать партикль захваченной цели",
    	[EN] = "Draws particle for current target",
    },
    ["optionAutoDisable"] = {
    	[RU] = "Сбрасывать врагам колбочкой кастующиеся заклинания",
    	[EN] = "Interrupt enemies casting spells with a concoction",
    },
    ["optionDodge"] = {
    	[RU] = "Уворачиваться от колбочки",
    	[EN] = "Dodge a concoction",
    },
}


local rootPath = "Hero Specific"

local mainPath = {rootPath, "Alchemist"}

local skillsPath = {rootPath, "Alchemist", "Skills"}

local itemsPath = {rootPath, "Alchemist", "Items"}

if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Alchemist"}
    skillsPath = {rootPath, "Alchemist", "Способности"}
    itemsPath = {rootPath, "Alchemist", "Предметы"}
end 

-------------------------------------------------------------------------------------------------

Alchemist.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Alchemist.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_alchemist_png.vtex_c")

Alchemist.optionFullCombo = Menu.AddKeyOption(mainPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Alchemist.optionFullCombo, "~/MenuIcons/enemy_evil.png")

Alchemist.optionIsTargetParticleEnabled = Menu.AddOptionBool(mainPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Alchemist.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Alchemist.optionRangeToTarget = Menu.AddOptionSlider(mainPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Alchemist.optionRangeToTarget, "~/MenuIcons/edit.png")


Alchemist.optionAutoDisable = Menu.AddOptionBool(mainPath, Translation.optionAutoDisable[language], true)
Menu.AddOptionIcon(Alchemist.optionAutoDisable, "~/MenuIcons/mute_guy.png")

Alchemist.optionDodge = Menu.AddOptionBool(mainPath, Translation.optionDodge[language], true)
Menu.AddOptionIcon(Alchemist.optionDodge, "~/MenuIcons/delete.png")
---------------------------------------------------------------------------------------------------------------------


Alchemist.optionAcid = Menu.AddOptionBool(skillsPath, "Acid", true)
Menu.AddOptionIcon(Alchemist.optionAcid, "panorama/images/spellicons/".."alchemist_acid_spray".."_png.vtex_c")
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

Alchemist.optionConcoction = Menu.AddOptionBool(skillsPath, "Concoction", true)
Menu.AddOptionIcon(Alchemist.optionConcoction, "panorama/images/spellicons/".."alchemist_unstable_concoction".."_png.vtex_c")
Alchemist.optionConcoctionSlider = Menu.AddOptionSlider(skillsPath, Translation.optionConcoctionSlider[language], 0, 5, 5)
Menu.AddOptionIcon(Alchemist.optionConcoctionSlider, "~/MenuIcons/edit.png")

Alchemist.optionRage = Menu.AddOptionBool(skillsPath, "Rage", true)
Menu.AddOptionIcon(Alchemist.optionRage, "panorama/images/spellicons/".."alchemist_chemical_rage".."_png.vtex_c")

-----------------------------------------------------------------------------------------


Alchemist.optionSheepStick = Menu.AddOptionBool(itemsPath, "Scythe of Vyse", true)
Menu.AddOptionIcon(Alchemist.optionSheepStick, "panorama/images/items/".."sheepstick".."_png.vtex_c")
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

Alchemist.optionManta = Menu.AddOptionBool(itemsPath, "Manta", true)
Menu.AddOptionIcon(Alchemist.optionManta, "panorama/images/items/".."manta".."_png.vtex_c")

Alchemist.optionMjollnir = Menu.AddOptionBool(itemsPath, "Mjollnir", true)
Menu.AddOptionIcon(Alchemist.optionMjollnir, "panorama/images/items/".."mjollnir".."_png.vtex_c")

Alchemist.optionAbyssalBlade = Menu.AddOptionBool(itemsPath, "Abyssal Blade", true)
Menu.AddOptionIcon(Alchemist.optionAbyssalBlade, "panorama/images/items/".."abyssal_blade".."_png.vtex_c")

Alchemist.optionBloodthorn = Menu.AddOptionBool(itemsPath, "Bloodthorn", true)
Menu.AddOptionIcon(Alchemist.optionBloodthorn, "panorama/images/items/".."bloodthorn".."_png.vtex_c")

Alchemist.optionSolarCrest = Menu.AddOptionBool(itemsPath, "Solar Crest", true) 
Menu.AddOptionIcon(Alchemist.optionSolarCrest, "panorama/images/items/".."solar_crest".."_png.vtex_c")

Alchemist.optionShivasGuard = Menu.AddOptionBool(itemsPath, "Shivas Guard", true)
Menu.AddOptionIcon(Alchemist.optionShivasGuard, "panorama/images/items/".."shivas_guard".."_png.vtex_c")

Alchemist.optionBlackKingBar = Menu.AddOptionBool(itemsPath, "Black King Bar", false)
Menu.AddOptionIcon(Alchemist.optionBlackKingBar, "panorama/images/items/".."black_king_bar".."_png.vtex_c")

Alchemist.optionBladeMail = Menu.AddOptionBool(itemsPath, "Blade Mail", true)
Menu.AddOptionIcon(Alchemist.optionBladeMail, "panorama/images/items/".."blade_mail".."_png.vtex_c")

Alchemist.optionSatanic = Menu.AddOptionBool(itemsPath, "Satanic", true)
Menu.AddOptionIcon(Alchemist.optionSatanic, "panorama/images/items/".."satanic".."_png.vtex_c")
Alchemist.optionSatanicSlider = Menu.AddOptionSlider(itemsPath, Translation.optionSatanicSlider[language], 1, 100, 30)
Menu.AddOptionIcon(Alchemist.optionSatanicSlider, "~/MenuIcons/edit.png")

Alchemist.optionLotusOrb = Menu.AddOptionBool(itemsPath, "Lotus Orb", true)
Menu.AddOptionIcon(Alchemist.optionLotusOrb, "panorama/images/items/".."lotus_orb".."_png.vtex_c")

Alchemist.optionMedallionOfCourage = Menu.AddOptionBool(itemsPath, "Medallion Of Couragea", true)
Menu.AddOptionIcon(Alchemist.optionMedallionOfCourage, "panorama/images/items/".."medallion_of_courage".."_png.vtex_c")

Alchemist.optionArmlet = Menu.AddOptionBool(itemsPath, "Armlet", true)
Menu.AddOptionIcon(Alchemist.optionArmlet, "panorama/images/items/".."armlet".."_png.vtex_c")

Alchemist.optionBlink = Menu.AddOptionBool(itemsPath, "Blink", true)
Menu.AddOptionIcon(Alchemist.optionBlink, "panorama/images/items/".."blink".."_png.vtex_c")
Alchemist.optionBlinkSlider = Menu.AddOptionSlider(itemsPath, Translation.optionBlinkSlider[language], 1, 2000, 1400) 
Menu.AddOptionIcon(Alchemist.optionBlinkSlider, "~/MenuIcons/edit.png")



----------------------------------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
function Alchemist.OnUpdate()

	if (not Menu.IsEnabled(Alchemist.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_alchemist" then 
		return
	end

	if (not myPlayer) then
		myPlayer = Players.GetLocal()
		return
	end
---------------------------------------
--Мана героя
	local mana = NPC.GetMana(myHero)


--Пинг
--	local TOTAL_LATENCY = NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)



------------------------------------------------------------------------------------------------------------------
--Способности ищем

	if (not acid) then
		acid = NPC.GetAbility(myHero, "alchemist_acid_spray")
		return
	end

	if (not concoction) then
		concoction = NPC.GetAbility(myHero, "alchemist_unstable_concoction")
		return
	end
	
	if (not concoctionThrow) then
		concoctionThrow = NPC.GetAbility(myHero, "alchemist_unstable_concoction_throw")
		return
	end

	if (not rage) then
		rage = NPC.GetAbility(myHero, "alchemist_chemical_rage")
		return
	end

-------------------------------------------------------------------------------------------------------------------
--Предметы

	local sheepstick = NPC.GetItem(myHero, "item_sheepstick")

	local manta = NPC.GetItem(myHero, "item_manta")

	local mjollnir = NPC.GetItem(myHero, "item_mjollnir")

	local abyssalblade = NPC.GetItem(myHero, "item_abyssal_blade")

	local bloodthorn = NPC.GetItem(myHero, "item_bloodthorn")

	local solarcrest = NPC.GetItem(myHero, "item_solar_crest") 

	local shivasguard = NPC.GetItem(myHero, "item_shivas_guard")

	local blackkingbar = NPC.GetItem(myHero, "item_black_king_bar")

	local blademail = NPC.GetItem(myHero, "item_blade_mail")

	local satanic = NPC.GetItem(myHero, "item_satanic")

	local lotusorb = NPC.GetItem(myHero, "item_lotus_orb")

	local medallionofcourage = NPC.GetItem(myHero, "item_medallion_of_courage")

	local armlet = NPC.GetItem(myHero, "item_armlet")

	local blink = NPC.GetItem(myHero, "item_blink")

-------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------------------------------------------
--Врага ищем
	if not enemy then
		enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	end
	if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Alchemist.optionRangeToTarget), 0) then
		enemy = nil
	end
--Сбрасываем кастуемые спеллы врагов колбочкой
	if  Menu.IsEnabled(Alchemist.optionAutoDisable) then
		for index, ability in pairs(Abilities.GetAll()) do 
			if Ability.IsChannelling(ability) then
				badability = Ability.GetName(ability)
				badguy = Ability.GetOwner(ability)
				if (not Entity.IsSameTeam(badguy, myHero)) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(badguy)):Length2D()) < Ability.GetCastRange(NPC.GetAbility(myHero, "alchemist_unstable_concoction_throw")) and badability ~= "item_trusty_shovel" and badability ~= "item_meteor_hammer" and badability ~= "windrunner_powershot" and badability ~= "enraged_wildkin_tornado" and badability ~= "riki_tricks_of_the_trade" and badability ~= "tinker_rearm" and badability ~= "puck_phase_shift" and badability ~= "ability_capture" and badability ~= "monkey_king_primal_spring" and badability ~= "oracle_fortunes_end" and badability ~= "keeper_of_the_light_illuminate" and badability ~= "elder_titan_echo_stomp" then
					if Alchemist.Concoction(concoction, mana) == true then
						return
					end

					if Alchemist.ConcoctionThrow(concoctionThrow, badguy) == true then
						return
					end
				end		
			end	
		end
	end	
--------------------------------------------------------------------------------------------------------------------------
--Полное комбо

	if Menu.IsKeyDown(Alchemist.optionFullCombo) and enemy then

		if Alchemist.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, myHero, enemy)
			lastMoveOrder = os.clock()
		end				

		local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
		local value = Menu.GetValue(Alchemist.optionBlinkSlider)
		if Alchemist.Blink(blink, Entity.GetAbsOrigin(enemy), distance, value) == true then
			return
		end

		if ((Entity.GetOrigin(myHero) - Entity.GetOrigin(enemy)):Length2D()) < 2000 then
			if blink then
				if Alchemist.Concoction(concoction, mana) == true then
					return
				end
			end	
		end		

		if ((Entity.GetOrigin(myHero) - Entity.GetOrigin(enemy)):Length2D()) < 1000 then
			if Alchemist.Concoction(concoction, mana) == true then
				return
			end
		end

		if Alchemist.SheepStick(sheepstick, enemy, mana) == true then
			return
		end

		if Alchemist.AbyssalBlade(abyssalblade, enemy, mana) == true then
			return
		end
	
		if Alchemist.SleepReady(orderDelay2, lastMoveOrder2) then
			if Menu.IsEnabled(Alchemist.optionArmlet) and armlet and Ability.IsReady(armlet) and Ability.GetToggleState(armlet) == false then
    			Ability.Toggle(armlet)	     	
    		end	
			lastMoveOrder2 = os.clock()
			return
		end

		if Alchemist.BladeMail(blademail, mana) == true then
			return
		end

		if Alchemist.ShivasGuard(shivasguard, mana) == true then
			return
		end


		if Alchemist.Rage(rage, mana) == true then
			return
		end


		if Alchemist.Manta(manta, mana) == true then
			return
		end


		if Alchemist.Bloodthorn(bloodthorn, enemy, mana) == true then
			return
		end

		
		if Alchemist.Mjollnir(mjollnir, myHero, mana) == true then
			return
		end


		
		if Alchemist.SolarCrest(solarcrest, enemy, mana) == true then
			return
		end


		if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(Alchemist.optionSatanicSlider) then
			if Alchemist.Satanic(satanic, mana) == true then
				return
			end
		end	


	
		if Alchemist.LotusOrb(lotusorb, myHero, mana) == true then
			return
		end
	

		if Alchemist.MedallionOfCouragea(medallionofcourage, enemy, mana) == true then
			return
		end	

		if Alchemist.BlackKingBar(blackkingbar, mana) == true then
			return
		end


		if Alchemist.Acid(acid, Entity.GetAbsOrigin(enemy), mana) == true then
			return
		end	
	
	end

--Кидаем колбочку в ближайшего или таргет героя через заданное время

	local concoctionModifier = NPC.GetModifier(myHero, 'modifier_alchemist_unstable_concoction')
	
	if concoctionModifier then
		local timer = GameRules.GetGameTime() - Modifier.GetDieTime(concoctionModifier) - 1
		if timer > Menu.GetValue(Alchemist.optionConcoctionSlider) then
			local nearestHero = Alchemist.FindNearestHero(myHero)
			if enemy then
				if Alchemist.ConcoctionThrow(concoctionThrow, enemy) == true then
					return
				end
			else
				if nearestHero and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(nearestHero)):Length2D()) < Ability.GetCastRange(NPC.GetAbility(myHero, "alchemist_unstable_concoction_throw")) then 
					if Alchemist.ConcoctionThrow(concoctionThrow, nearestHero) == true then
						return
					end
				else
					if Menu.IsEnabled(Alchemist.optionDodge) and  manta and timer > (5.4 - NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) then
						if Alchemist.Manta(manta, mana) == true then
							return
						end
					end		 	
				end	
			end	
		end
	end
-------------------------------------------------------------------------------------------------------------------------	
end	
--------------------------------------------------------------------------------------------------------------------------------
--Рисуем Партикль
function Alchemist.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_alchemist" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(Alchemist.optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Alchemist.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Alchemist.optionRangeToTarget), 0) then
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
----------------------------------------------------------------------------------------------------------------------------
--Функции способностей

function Alchemist.Concoction(ability, mana)
	if Menu.IsEnabled(Alchemist.optionConcoction) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastNoTarget(ability)
    	return true 
    end	
end

function Alchemist.Acid(ability, origin, mana)
	if Menu.IsEnabled(Alchemist.optionAcid) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Alchemist.Rage(ability, mana)
	if Menu.IsEnabled(Alchemist.optionRage) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastNoTarget(ability)
    	return true
    end	 
end

function Alchemist.ConcoctionThrow(ability, enemy)
	if Menu.IsEnabled(Alchemist.optionConcoction) then
    	Ability.CastTarget(ability, enemy)
    	return true
    end	
end

---------------------------------------------------------------------------------------------------------------------------------
--Функции предметов

function Alchemist.SheepStick(item, enemy, mana)
	if Menu.IsEnabled(Alchemist.optionSheepStick) and item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end


function Alchemist.Manta(item, mana)
	if Menu.IsEnabled(Alchemist.optionManta) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)	 
    	return true
    end	  
end

function Alchemist.Mjollnir(item, enemy, mana)
	if Menu.IsEnabled(Alchemist.optionMjollnir) and item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)	 
    	return true
    end	  
end

function Alchemist.AbyssalBlade(item, enemy, mana)
	if Menu.IsEnabled(Alchemist.optionAbyssalBlade) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)	 
    	return true
    end	  
end

function Alchemist.Bloodthorn(item, enemy, mana)
	if Menu.IsEnabled(Alchemist.optionBloodthorn) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)	 
    	return true
    end	  
end

function Alchemist.SolarCrest(item, enemy, mana)
	if Menu.IsEnabled(Alchemist.optionSolarCrest) and item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Alchemist.ShivasGuard(item, mana)
	if Menu.IsEnabled(Alchemist.optionShivasGuard) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end

function Alchemist.BlackKingBar(item, mana)
	if Menu.IsEnabled(Alchemist.optionBlackKingBar) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)	
    	return true 
    end	  
end

function Alchemist.BladeMail(item, mana)
	if Menu.IsEnabled(Alchemist.optionBladeMail) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)	 
    	return true
    end	  
end

function Alchemist.Satanic(item, mana)
	if Menu.IsEnabled(Alchemist.optionSatanic) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)	 
    	return true
    end	  
end

function Alchemist.LotusOrb(item, enemy, mana)
	if Menu.IsEnabled(Alchemist.optionLotusOrb) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)	
    	return true 
    end	  
end


function Alchemist.MedallionOfCouragea(item, enemy, mana)
	if Menu.IsEnabled(Alchemist.optionMedallionOfCourage) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)	 
    	return true
    end	  
end

function Alchemist.Blink(item, origin, distance, value)
	if Menu.IsEnabled(Alchemist.optionBlink) and item and Ability.IsReady(item) and distance < value  then
    	Ability.CastPosition(item, origin)
    	return true
    end	
end

---------------------------------------------------------------------------------------------------------------------------------
--Находим ближайшего вражеского героя к своему герою
function Alchemist.FindNearestHero(myHero)
	local enemyNew2, enemyNewDistance, enemyNewDistance2 = nil, nil, 99999999999

	if Entity.IsAlive(myHero) then 
		for index, hero in pairs(Heroes.GetAll()) do
			if (not Entity.IsSameTeam(hero, myHero)) then
				enemyNewDistance = ((Entity.GetOrigin(myHero) - Entity.GetOrigin(hero)):Length2D())
				if enemyNewDistance < enemyNewDistance2   then
					enemyNewDistance2 = enemyNewDistance 
					enemyNew2 = hero
				end	
			end		
		end
		return enemyNew2
	end	
end	
return Alchemist