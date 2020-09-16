local Queen = {}

local myHero, myPlayer, enemy, strike, blink, scream, sonic = nil, nil, nil, nil, nil, nil, nil


--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1 

function Queen.SleepReady(sleep, lastTick)
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
    	[RU] = "Кнопка для комбо",
    	[EN] = "Combo button",
    },
    ["optionIsTargetParticleEnabled"] = {
    	[RU] = "Рисовать партикль захваченной цели",
    	[EN] = "Draws particle for current target",
    },
    ["optionSatanicSlider"] = {
    	[RU] = "Порог здоровья в %",
    	[EN] = "HPercent Threshold",
    },
}




local rootPath = "Hero Specific"

local mainPath = {rootPath, "Queen"}

local skillsPath = {rootPath, "Queen", "Skills"}

local itemsPath = {rootPath, "Queen", "Items"}

local linkenPath = {rootPath, "Queen", "Linken Breaker"}

if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Queen"}
    skillsPath = {rootPath, "Queen", "Способности"}
    itemsPath = {rootPath, "Queen", "Предметы"}
    linkenPath = {rootPath, "Queen", "Сбитие Линки"}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------




-----------------------------------------------------------------------------------------------------------------------
Queen.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Queen.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_queenofpain_png.vtex_c")

Queen.optionFullCombo = Menu.AddKeyOption(mainPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Queen.optionFullCombo, "~/MenuIcons/enemy_evil.png")

Queen.optionIsTargetParticleEnabled = Menu.AddOptionBool(mainPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Queen.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Queen.optionRangeToTarget = Menu.AddOptionSlider(mainPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Queen.optionRangeToTarget, "~/MenuIcons/edit.png")
---------------------------------------------------------------------------------------------------------------------------
Queen.optionStrike = Menu.AddOptionBool(skillsPath, "Shadow Strike", true)
Menu.AddOptionIcon(Queen.optionStrike, "panorama/images/spellicons/".."queenofpain_shadow_strike".."_png.vtex_c")
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

Queen.optionBlink = Menu.AddOptionBool(skillsPath, "Blink", true)
Menu.AddOptionIcon(Queen.optionBlink, "panorama/images/spellicons/".."queenofpain_blink".."_png.vtex_c")

Queen.optionScream = Menu.AddOptionBool(skillsPath, "Scream Of Pain", true)
Menu.AddOptionIcon(Queen.optionScream, "panorama/images/spellicons/".."queenofpain_scream_of_pain".."_png.vtex_c")

Queen.optionSonic = Menu.AddOptionBool(skillsPath, "Sonic Wave", true)
Menu.AddOptionIcon(Queen.optionSonic, "panorama/images/spellicons/".."queenofpain_sonic_wave".."_png.vtex_c")
---------------------------------------------------------------------------------------------------------------------------
Queen.optionSheepStick = Menu.AddOptionBool(itemsPath, "Scythe of Vyse", true)
Menu.AddOptionIcon(Queen.optionSheepStick, "panorama/images/items/".."sheepstick".."_png.vtex_c")
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

Queen.optionMjollnir = Menu.AddOptionBool(itemsPath, "Mjollnir", true)
Menu.AddOptionIcon(Queen.optionMjollnir, "panorama/images/items/".."mjollnir".."_png.vtex_c")

Queen.optionBloodthorn = Menu.AddOptionBool(itemsPath, "Bloodthorn", true)
Menu.AddOptionIcon(Queen.optionBloodthorn, "panorama/images/items/".."bloodthorn".."_png.vtex_c")

Queen.optionOrchidMalevolence = Menu.AddOptionBool(itemsPath, "Orchid Malevolence", true)
Menu.AddOptionIcon(Queen.optionOrchidMalevolence, "panorama/images/items/".."orchid".."_png.vtex_c")

Queen.optionShivasGuard = Menu.AddOptionBool(itemsPath, "Shivas Guard", true)
Menu.AddOptionIcon(Queen.optionShivasGuard, "panorama/images/items/".."shivas_guard".."_png.vtex_c")

Queen.optionBlackKingBar = Menu.AddOptionBool(itemsPath, "Black King Bar", false)
Menu.AddOptionIcon(Queen.optionBlackKingBar, "panorama/images/items/".."black_king_bar".."_png.vtex_c")

Queen.optionBladeMail = Menu.AddOptionBool(itemsPath, "Blade Mail", true)
Menu.AddOptionIcon(Queen.optionBladeMail, "panorama/images/items/".."blade_mail".."_png.vtex_c")

Queen.optionSatanic = Menu.AddOptionBool(itemsPath, "Satanic", true)
Menu.AddOptionIcon(Queen.optionSatanic, "panorama/images/items/".."satanic".."_png.vtex_c")
Queen.optionSatanicSlider = Menu.AddOptionSlider(itemsPath, Translation.optionSatanicSlider[language], 1, 100, 30)
Menu.AddOptionIcon(Queen.optionSatanicSlider, "~/MenuIcons/edit.png")

Queen.optionLotusOrb = Menu.AddOptionBool(itemsPath, "Lotus Orb", true)
Menu.AddOptionIcon(Queen.optionLotusOrb, "panorama/images/items/".."lotus_orb".."_png.vtex_c")

Queen.optionHurricanePike = Menu.AddOptionBool(itemsPath, "Hurricane Pike", true)
Menu.AddOptionIcon(Queen.optionHurricanePike, "panorama/images/items/".."hurricane_pike".."_png.vtex_c")

Queen.optionVeilOfDiscord = Menu.AddOptionBool(itemsPath, "Veil Of Discord", true)
Menu.AddOptionIcon(Queen.optionVeilOfDiscord, "panorama/images/items/".."veil_of_discord".."_png.vtex_c")

Queen.optionEthereal = Menu.AddOptionBool(itemsPath, "Ethereal Blade", true)
Menu.AddOptionIcon(Queen.optionEthereal, "panorama/images/items/".."ethereal_blade".."_png.vtex_c")

Queen.optionDagon = Menu.AddOptionBool(itemsPath, "Dagon", true)
Menu.AddOptionIcon(Queen.optionDagon, "panorama/images/items/".."dagon".."_png.vtex_c")
-----------------------------------------------------------------------------------------------------------------------
Queen.optionStrikeL = Menu.AddOptionBool(linkenPath, "Shadow Strike", true)
Menu.AddOptionIcon(Queen.optionStrikeL, "panorama/images/spellicons/".."queenofpain_shadow_strike".."_png.vtex_c")
Menu.AddMenuIcon(linkenPath, "panorama/images/items/".."sphere".."_png.vtex_c")

Queen.optionDagonL = Menu.AddOptionBool(linkenPath, "Dagon", false)
Menu.AddOptionIcon(Queen.optionDagonL, "panorama/images/items/".."dagon".."_png.vtex_c")

Queen.optionHurricanePikeL = Menu.AddOptionBool(linkenPath, "Hurricane Pike", false)
Menu.AddOptionIcon(Queen.optionHurricanePikeL, "panorama/images/items/".."hurricane_pike".."_png.vtex_c")

Queen.optionOrchidMalevolenceL = Menu.AddOptionBool(linkenPath, "Orchid Malevolence", false)
Menu.AddOptionIcon(Queen.optionOrchidMalevolenceL, "panorama/images/items/".."orchid".."_png.vtex_c")

---------------------------------------------Главнвя функция------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
function Queen.OnUpdate()

	if (not Menu.IsEnabled(Queen.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_queenofpain" then 
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

	if (not strike) then
		strike = NPC.GetAbility(myHero, "queenofpain_shadow_strike")
		return
	end

	if (not blink) then
		blink = NPC.GetAbility(myHero, "queenofpain_blink")
		return
	end
	
	if (not scream) then
		scream = NPC.GetAbility(myHero, "queenofpain_scream_of_pain")
		return
	end

	if (not sonic) then
		sonic = NPC.GetAbility(myHero, "queenofpain_sonic_wave")
		return
	end
----------------------------------------------------------------------------


--Предметы

	local sheepstick = NPC.GetItem(myHero, "item_sheepstick")

	local mjollnir = NPC.GetItem(myHero, "item_mjollnir")

	local bloodthorn = NPC.GetItem(myHero, "item_bloodthorn")

	local orchid = NPC.GetItem(myHero, "item_orchid")

	local shivasguard = NPC.GetItem(myHero, "item_shivas_guard")

	local blackkingbar = NPC.GetItem(myHero, "item_black_king_bar")

	local blademail = NPC.GetItem(myHero, "item_blade_mail")

	local satanic = NPC.GetItem(myHero, "item_satanic")

	local lotusorb = NPC.GetItem(myHero, "item_lotus_orb")

	local hurricanepike = NPC.GetItem(myHero, "item_hurricane_pike")

	local veilofdiscord = NPC.GetItem(myHero, "item_veil_of_discord")

	local etherealblade = NPC.GetItem(myHero, "item_ethereal_blade")

	local dagon = NPC.GetItem(myHero, "item_dagon")
    if not dagon then          
 		for i = 2, 5 do           
   			dagon = NPC.GetItem(myHero, "item_dagon_" .. i)
   			if dagon then
   				break
   			end	
 		end
	end
--------------------------------------------------------------------------------



--Врага ищем
	if not enemy then
		enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	end
	if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Queen.optionRangeToTarget), 0) then
		enemy = nil
	end
	if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
		enemy = nil
	end
---------------------------------------------------------------------------------------------------
	
	if Menu.IsKeyDown(Queen.optionFullCombo) and enemy then
		if NPC.GetModifier(enemy, "modifier_black_king_bar_immune") then
			Queen.Sonic(sonic, Entity.GetAbsOrigin(enemy), mana)
		end
	end	


--Полное комбо

	if Menu.IsKeyDown(Queen.optionFullCombo) and enemy then

		if Queen.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, myHero, enemy)
			lastMoveOrder = os.clock()
		end	

		local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
		if Queen.Blink(blink, Entity.GetAbsOrigin(enemy), distance, mana) == true then
			return
		end

		if NPC.IsLinkensProtected(enemy) then

			if Menu.IsEnabled(Queen.optionStrikeL) then
				if Queen.Strike(strike, mana, enemy) == true then
					return
				end
			end

			if Menu.IsEnabled(Queen.optionHurricanePikeL) then
				if Queen.Hurricane(hurricanepike, enemy, distance, mana) == true then
					return
				end
			end		

			if Menu.IsEnabled(Queen.optionDagonL) then
				if Queen.ItemTarget(dagon, enemy, mana) == true then
					return
				end
			end

			if Menu.IsEnabled(Queen.optionOrchidMalevolenceL) then
				if Queen.ItemTarget(orchid, enemy, mana) == true then
					return
				end
			end		
		end					

		if Menu.IsEnabled(Queen.optionSheepStick) and Queen.ItemTarget(sheepstick, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Queen.optionBloodthorn) and Queen.ItemTarget(bloodthorn, enemy, mana) == true then
			return
		end

		if  Menu.IsEnabled(Queen.optionOrchidMalevolence) and Queen.ItemTarget(orchid, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Queen.optionVeilOfDiscord) and Queen.ItemOrigin(veilofdiscord, Entity.GetAbsOrigin(enemy), mana) == true then
			return
		end

		if Menu.IsEnabled(Queen.optionEthereal) and Queen.ItemTarget(etherealblade, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Queen.optionShivasGuard) and  Queen.ItemNoTarget(shivasguard, mana) == true then
			return
		end

		if Queen.Scream(scream, mana, enemy, myHero) == true then
			return
		end

		if Queen.Strike(strike, mana, enemy) == true then
			return
		end

		if Menu.IsEnabled(Queen.optionDagon) and Queen.ItemTarget(dagon, enemy, mana) == true then
			return
		end

		if Queen.Sonic(sonic, Entity.GetAbsOrigin(enemy), mana) == true then
			return
		end

		
		if Menu.IsEnabled(Queen.optionMjollnir) and Queen.ItemTarget(mjollnir, myHero, mana) == true then
			return
		end


		if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(Queen.optionSatanicSlider) then
			if Menu.IsEnabled(Queen.optionSatanic) and  Queen.ItemNoTarget(satanic, mana) == true then
				return
			end
		end	


	
		if  Menu.IsEnabled(Queen.optionLotusOrb) and  Queen.ItemTarget(lotusorb, myHero, mana) == true then
			return
		end
	

		if Menu.IsEnabled(Queen.optionBlackKingBar) and Queen.ItemNoTarget(blackkingbar, mana) == true then
			return
		end

		if Menu.IsEnabled(Queen.optionBladeMail) and Queen.ItemNoTarget(blademail, mana) == true then
			return
		end

		if Queen.Hurricane(hurricanepike, enemy, distance, mana) == true then
			return
		end
	end	
-------------------------------------------------------------------------------			
end


----------------------------------------------------------------------------------------
--Рисуем Партикль
function Queen.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_queenofpain" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(Queen.optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Queen.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Queen.optionRangeToTarget), 0) then
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

function Queen.Strike(ability, mana, enemy)
	if Menu.IsEnabled(Queen.optionStrike) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastTarget(ability, enemy)
    	return true 
    end	
end

function Queen.Blink(ability, origin, distance, mana)
	if Menu.IsEnabled(Queen.optionBlink) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and distance > 700 and distance < 1500 then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Queen.Scream(ability, mana, enemy, myHero)
	if Menu.IsEnabled(Queen.optionScream) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not NPC.GetModifier(enemy, "modifier_black_king_bar_immune") and #Entity.GetHeroesInRadius(myHero, 525, Enum.TeamType.TEAM_ENEMY) ~= 0 then
    	Ability.CastNoTarget(ability)
    	return true
    end	 
end

function Queen.Sonic(ability, origin, mana)
	if Menu.IsEnabled(Queen.optionSonic) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end
-----------------------------------------------------------------------------------------------------------------------------


--Функции предметов

function Queen.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Queen.ItemOrigin(item, origin, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastPosition(item, origin) 
    	return true
    end	  
end


function Queen.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end


function Queen.Hurricane(item, enemy, distance, mana)
	if Menu.IsEnabled(Queen.optionHurricanePike) and item and Ability.IsReady(item) and Ability.IsCastable(item, mana) and distance < 450 then
    	Ability.CastTarget(item, enemy)	 
    	return true
    end	  
end



return Queen