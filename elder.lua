local Elder = {}

local myHero, myPlayer, enemy, echo, astral, splitter, returnSpirit = nil, nil, nil, nil, nil, nil, nil


--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1 

function Elder.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end

local lastMoveOrder2 = 0
local orderDelay2 = 0.1 
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
 
if Menu.GetLanguageOptionId then
    local LanguageItem = Menu.GetLanguageOptionId()
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
    ["optionSatanicSlider"] = {
    	[RU] = "Порог здоровья в %",
    	[EN] = "HPercent Threshold",
		[CN] = "生命值百分比",
    },
    ["optionReturnSpirit"] = {
    	[RU] = "Возвращать спирита в комбо",
    	[EN] = "Return spirit during combo",
		[CN] = "",
    },
    ["optionCombo2"] = {
    	[RU] = "Комбо стан + метеор",
    	[EN] = "Сombo stun + meteor",
		[CN] = "",
    },
    ["optionBlink"] = {
    	[RU] = "Блинк в комбо",
    	[EN] = "Blink in combo",
		[CN] = "",
    },
}




local rootPath = "Hero Specific"

local mainPath = {rootPath, "Elder Titan"}

local skillsPath = {rootPath, "Elder Titan", "Skills"}

local itemsPath = {rootPath, "Elder Titan", "Items"}


if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Elder Titan"}
    skillsPath = {rootPath, "Elder Titan", "Способности"}
    itemsPath = {rootPath, "Elder Titan", "Предметы"}
end 

if language == CN then
    rootPath = "独立英雄脚本"
    mainPath = {rootPath, "Elder Titan"}
    skillsPath = {rootPath, "Elder Titan", "技能"}
    itemsPath = {rootPath, "Elder Titan", "物品"}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------






-----------------------------------------------------------------------------------------------------------------------
Elder.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Elder.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_elder_titan_png.vtex_c")

Elder.optionFullCombo = Menu.AddKeyOption(mainPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Elder.optionFullCombo, "~/MenuIcons/enemy_evil.png")

Elder.optionCombo2 = Menu.AddKeyOption(mainPath, Translation.optionCombo2[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Elder.optionCombo2, "panorama/images/items/".."meteor_hammer".."_png.vtex_c")

Elder.optionReturnSpirit = Menu.AddOptionBool(mainPath, Translation.optionReturnSpirit[language], false)
Menu.AddOptionIcon(Elder.optionReturnSpirit, "panorama/images/spellicons/".."elder_titan_return_spirit".."_png.vtex_c")

Elder.optionBlink = Menu.AddOptionBool(mainPath, Translation.optionBlink[language], true)
Menu.AddOptionIcon(Elder.optionBlink, "panorama/images/items/".."blink".."_png.vtex_c")

Elder.optionIsTargetParticleEnabled = Menu.AddOptionBool(mainPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Elder.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Elder.optionRangeToTarget = Menu.AddOptionSlider(mainPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Elder.optionRangeToTarget, "~/MenuIcons/edit.png")
---------------------------------------------------------------------------------------------------------------------------
Elder.optionEcho = Menu.AddOptionBool(skillsPath, "Echo Stomp", true)
Menu.AddOptionIcon(Elder.optionEcho, "panorama/images/spellicons/".."elder_titan_echo_stomp".."_png.vtex_c")
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

Elder.optionAstral = Menu.AddOptionBool(skillsPath, "Astral Spirit", true)
Menu.AddOptionIcon(Elder.optionAstral, "panorama/images/spellicons/".."elder_titan_ancestral_spirit".."_png.vtex_c")

Elder.optionSplitter = Menu.AddOptionBool(skillsPath, "Earth Splitter", true)
Menu.AddOptionIcon(Elder.optionSplitter, "panorama/images/spellicons/".."elder_titan_earth_splitter".."_png.vtex_c")

---------------------------------------------------------------------------------------------------------------------------
Elder.optionSheepStick = Menu.AddOptionBool(itemsPath, "Scythe of Vyse", true)
Menu.AddOptionIcon(Elder.optionSheepStick, "panorama/images/items/".."sheepstick".."_png.vtex_c")
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

Elder.optionMeteorHammer = Menu.AddOptionBool(itemsPath, "Meteor Hammer", true)
Menu.AddOptionIcon(Elder.optionMeteorHammer, "panorama/images/items/".."meteor_hammer".."_png.vtex_c")

Elder.optionMjollnir = Menu.AddOptionBool(itemsPath, "Mjollnir", true)
Menu.AddOptionIcon(Elder.optionMjollnir, "panorama/images/items/".."mjollnir".."_png.vtex_c")

Elder.optionBloodthorn = Menu.AddOptionBool(itemsPath, "Bloodthorn", true)
Menu.AddOptionIcon(Elder.optionBloodthorn, "panorama/images/items/".."bloodthorn".."_png.vtex_c")

Elder.optionOrchidMalevolence = Menu.AddOptionBool(itemsPath, "Orchid Malevolence", true)
Menu.AddOptionIcon(Elder.optionOrchidMalevolence, "panorama/images/items/".."orchid".."_png.vtex_c")

Elder.optionShivasGuard = Menu.AddOptionBool(itemsPath, "Shivas Guard", true)
Menu.AddOptionIcon(Elder.optionShivasGuard, "panorama/images/items/".."shivas_guard".."_png.vtex_c")

Elder.optionBlackKingBar = Menu.AddOptionBool(itemsPath, "Black King Bar", false)
Menu.AddOptionIcon(Elder.optionBlackKingBar, "panorama/images/items/".."black_king_bar".."_png.vtex_c")

Elder.optionBladeMail = Menu.AddOptionBool(itemsPath, "Blade Mail", true)
Menu.AddOptionIcon(Elder.optionBladeMail, "panorama/images/items/".."blade_mail".."_png.vtex_c")

Elder.optionSatanic = Menu.AddOptionBool(itemsPath, "Satanic", true)
Menu.AddOptionIcon(Elder.optionSatanic, "panorama/images/items/".."satanic".."_png.vtex_c")
Elder.optionSatanicSlider = Menu.AddOptionSlider(itemsPath, Translation.optionSatanicSlider[language], 1, 100, 30)
Menu.AddOptionIcon(Elder.optionSatanicSlider, "~/MenuIcons/edit.png")

Elder.optionLotusOrb = Menu.AddOptionBool(itemsPath, "Lotus Orb", true)
Menu.AddOptionIcon(Elder.optionLotusOrb, "panorama/images/items/".."lotus_orb".."_png.vtex_c")

Elder.optionCrimson = Menu.AddOptionBool(itemsPath, "Crimson Guard", true)
Menu.AddOptionIcon(Elder.optionCrimson, "panorama/images/items/".."crimson_guard".."_png.vtex_c")

Elder.optionAtos = Menu.AddOptionBool(itemsPath, "Rod of Atos", true)
Menu.AddOptionIcon(Elder.optionAtos, "panorama/images/items/".."rod_of_atos".."_png.vtex_c")

Elder.optionRefresherOrb = Menu.AddOptionBool(itemsPath, "Refresher Orb", false)
Menu.AddOptionIcon(Elder.optionRefresherOrb, "panorama/images/items/".."refresher".."_png.vtex_c")

-----------------------------------------------------------------------------------------------------------------------

---------------------------------------------Главнвя функция------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
function Elder.OnUpdate()

	if (not Menu.IsEnabled(Elder.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_elder_titan" then 
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

	if (not echo) then
		echo = NPC.GetAbility(myHero, "elder_titan_echo_stomp")
		return
	end

	if (not astral) then
		astral = NPC.GetAbility(myHero, "elder_titan_ancestral_spirit")
		return
	end
	
	if (not splitter) then
		splitter = NPC.GetAbility(myHero, "elder_titan_earth_splitter")
		return
	end

	if (not returnSpirit) then
		returnSpirit = NPC.GetAbility(myHero, "elder_titan_return_spirit")
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

	local meteor = NPC.GetItem(myHero, "item_meteor_hammer")

	local refresher = NPC.GetItem(myHero, "item_refresher")

	local blink = NPC.GetItem(myHero, "item_blink")

	local crimson = NPC.GetItem(myHero, "item_crimson_guard")

	local atos = NPC.GetItem(myHero, "item_rod_of_atos")

--------------------------------------------------------------------------------


--Врага ищем
	if not enemy then
		enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	end
	if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Elder.optionRangeToTarget), 0) then
		enemy = nil
	end
	if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
		enemy = nil
	end
---------------------------------------------------------------------------------------------------

--Полное комбо

	if Menu.IsKeyDown(Elder.optionFullCombo) and enemy and (not NPC.IsChannellingAbility(myHero)) then
		if meteor then
			if (not Ability.IsChannelling(meteor)) then
				if Elder.SleepReady(orderDelay, lastMoveOrder) then
					Player.AttackTarget(myPlayer, myHero, enemy)
					lastMoveOrder = os.clock()
				end	

				local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
				position =  Elder.GetPredictedPosition(enemy, 1)
				if Elder.Blink(blink, position, distance, mana) == true then
					return
				end
				position =  Elder.GetPredictedPosition(enemy, 1.8)
				if Elder.Astral(astral, position, distance, mana) == true then
					return
				end

				if Menu.IsEnabled(Elder.optionSheepStick) and Elder.ItemTarget(sheepstick, enemy, mana) == true then
					return
				end	

				if  Menu.IsEnabled(Elder.optionAtos) and Elder.ItemTarget(atos, enemy, mana) == true then
					return
				end

				if Elder.Echo(echo, mana) == true then
					return
				end	

				position =  Elder.GetPredictedPosition(enemy, 0.5)
				if Elder.Splitter(splitter, position, distance, mana) == true then
					return
				end		

				if Menu.IsEnabled(Elder.optionBloodthorn) and Elder.ItemTarget(bloodthorn, enemy, mana) == true then
					return
				end

				if  Menu.IsEnabled(Elder.optionOrchidMalevolence) and Elder.ItemTarget(orchid, enemy, mana) == true then
					return
				end

				if Menu.IsEnabled(Elder.optionMeteorHammer) and Elder.ItemOrigin(meteor, Entity.GetAbsOrigin(enemy), mana) == true then
					return
				end

				if Menu.IsEnabled(Elder.optionShivasGuard) and  Elder.ItemNoTarget(shivasguard, mana) == true then
					return
				end
			
				if Menu.IsEnabled(Elder.optionMjollnir) and Elder.ItemTarget(mjollnir, myHero, mana) == true then
					return
				end


				if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(Elder.optionSatanicSlider) then
					if Menu.IsEnabled(Elder.optionSatanic) and  Elder.ItemNoTarget(satanic, mana) == true then
						return
					end
				end	


			
				if  Menu.IsEnabled(Elder.optionLotusOrb) and  Elder.ItemTarget(lotusorb, myHero, mana) == true then
					return
				end

				if Menu.IsEnabled(Elder.optionCrimson) and Elder.ItemNoTarget(crimson, mana) == true then
					return
				end	
			

				if Menu.IsEnabled(Elder.optionBlackKingBar) and Elder.ItemNoTarget(blackkingbar, mana) == true then
					return
				end

				if Menu.IsEnabled(Elder.optionBladeMail) and Elder.ItemNoTarget(blademail, mana) == true then
					return
				end

				if Menu.IsEnabled(Elder.optionReturnSpirit) and Ability.IsReady(returnSpirit) and Ability.IsCastable(returnSpirit, mana) then
					Ability.CastNoTarget(returnSpirit)
				end

				if Menu.IsEnabled(Elder.optionRefresherOrb) and Elder.ItemNoTarget(refresher, mana) == true then
					return
				end
			end	
		else
			if Elder.SleepReady(orderDelay, lastMoveOrder) then
				Player.AttackTarget(myPlayer, myHero, enemy)
				lastMoveOrder = os.clock()
			end	

			local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
			position =  Elder.GetPredictedPosition(enemy, 1)
			if Elder.Blink(blink, position, distance, mana) == true then
				return
			end
			position =  Elder.GetPredictedPosition(enemy, 1.8)
			if Elder.Astral(astral, position, distance, mana) == true then
				return
			end

			if Menu.IsEnabled(Elder.optionSheepStick) and Elder.ItemTarget(sheepstick, enemy, mana) == true then
				return
			end	

			if  Menu.IsEnabled(Elder.optionAtos) and Elder.ItemTarget(atos, enemy, mana) == true then
				return
			end

			if Elder.Echo(echo, mana) == true then
				return
			end	

			position =  Elder.GetPredictedPosition(enemy, 0.5)
			if Elder.Splitter(splitter, position, distance, mana) == true then
				return
			end		

			if Menu.IsEnabled(Elder.optionBloodthorn) and Elder.ItemTarget(bloodthorn, enemy, mana) == true then
				return
			end

			if  Menu.IsEnabled(Elder.optionOrchidMalevolence) and Elder.ItemTarget(orchid, enemy, mana) == true then
				return
			end

			if Menu.IsEnabled(Elder.optionMeteorHammer) and Elder.ItemOrigin(meteor, Entity.GetAbsOrigin(enemy), mana) == true then
				return
			end

			if Menu.IsEnabled(Elder.optionShivasGuard) and  Elder.ItemNoTarget(shivasguard, mana) == true then
				return
			end
		
			if Menu.IsEnabled(Elder.optionMjollnir) and Elder.ItemTarget(mjollnir, myHero, mana) == true then
				return
			end


			if satanic and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < Menu.GetValue(Elder.optionSatanicSlider) then
				if Menu.IsEnabled(Elder.optionSatanic) and  Elder.ItemNoTarget(satanic, mana) == true then
					return
				end
			end	


		
			if  Menu.IsEnabled(Elder.optionLotusOrb) and  Elder.ItemTarget(lotusorb, myHero, mana) == true then
				return
			end

			if Menu.IsEnabled(Elder.optionCrimson) and Elder.ItemNoTarget(crimson, mana) == true then
				return
			end	
		

			if Menu.IsEnabled(Elder.optionBlackKingBar) and Elder.ItemNoTarget(blackkingbar, mana) == true then
				return
			end

			if Menu.IsEnabled(Elder.optionBladeMail) and Elder.ItemNoTarget(blademail, mana) == true then
				return
			end

			if Menu.IsEnabled(Elder.optionReturnSpirit) and Ability.IsReady(returnSpirit) and Ability.IsCastable(returnSpirit, mana) then
				Ability.CastNoTarget(returnSpirit)
			end

			if Menu.IsEnabled(Elder.optionRefresherOrb) and Elder.ItemNoTarget(refresher, mana) == true then
				return
			end
		end				
	end



--Второе комбо
	if Menu.IsKeyDown(Elder.optionCombo2) and enemy and (not NPC.IsChannellingAbility(myHero)) then
		if meteor then
			if (not Ability.IsChannelling(meteor)) then

				if Elder.SleepReady(orderDelay2, lastMoveOrder2) then
					Player.AttackTarget(myPlayer, myHero, enemy)
					lastMoveOrder2 = os.clock()
				end

				local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
				if Elder.Blink(blink, Entity.GetAbsOrigin(enemy), distance, mana) == true then
					return
				end	

				position =  Elder.GetPredictedPosition(enemy, 1.8)
				if Elder.Astral(astral, position, distance, mana) == true then
					return
				end

				if Elder.Echo(echo, mana) == true then
					return
				end	

				if Menu.IsEnabled(Elder.optionMeteorHammer) and Elder.ItemOrigin(meteor, Entity.GetAbsOrigin(enemy), mana) == true then
					return
				end

				if Menu.IsEnabled(Elder.optionReturnSpirit) and Ability.IsReady(returnSpirit) and Ability.IsCastable(returnSpirit, mana) then
					Ability.CastNoTarget(returnSpirit)
				end
			end	
		else
			if Elder.SleepReady(orderDelay2, lastMoveOrder2) then
				Player.AttackTarget(myPlayer, myHero, enemy)
				lastMoveOrder2 = os.clock()
			end

			local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
			if Elder.Blink(blink, Entity.GetAbsOrigin(enemy), distance, mana) == true then
				return
			end	

			position =  Elder.GetPredictedPosition(enemy, 1.8)
			if Elder.Astral(astral, position, distance, mana) == true then
				return
			end

			if Elder.Echo(echo, mana) == true then
				return
			end	

			if Menu.IsEnabled(Elder.optionMeteorHammer) and Elder.ItemOrigin(meteor, Entity.GetAbsOrigin(enemy), mana) == true then
				return
			end

			if Menu.IsEnabled(Elder.optionReturnSpirit) and Ability.IsReady(returnSpirit) and Ability.IsCastable(returnSpirit, mana) then
				Ability.CastNoTarget(returnSpirit)
			end
		end		
	end		
-------------------------------------------------------------------------------			
end



----------------------------------------------------------------------------------------
--Рисуем Партикль
function Elder.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_elder_titan" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(Elder.optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Elder.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Elder.optionRangeToTarget), 0) then
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


--Предикшн
function Elder.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc)
    if not NPC.IsRunning(npc) or not delay  then return pos end

    local dir = Entity.GetRotation(npc):GetForward():Normalized()
    local speed = NPC.GetMoveSpeed(npc)

    return pos + dir:Scaled(speed * delay)
end


--Функции способностей

function Elder.Echo(ability, mana)
	if Menu.IsEnabled(Elder.optionEcho) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastNoTarget(ability)
    	return true 
    end	
end

function Elder.Astral(ability, origin, distance, mana)
	if Menu.IsEnabled(Elder.optionAstral) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana)  then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Elder.Splitter(ability, origin, distance, mana)
	if Menu.IsEnabled(Elder.optionSplitter) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and  distance < 2400 then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end



-----------------------------------------------------------------------------------------------------------------------------


--Функции предметов

function Elder.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Elder.ItemOrigin(item, origin, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastPosition(item, origin) 
    	return true
    end	  
end


function Elder.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end

function Elder.Blink(ability, origin, distance, mana)
	if ability and Menu.IsEnabled(Elder.optionBlink) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and distance > 700 then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end














return Elder