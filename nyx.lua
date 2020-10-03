local Nyx = {}

local myHero, myPlayer, enemy, impale, burn, carapace, vendetta = nil, nil, nil, nil, nil, nil, nil


--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1 

function Nyx.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end
--------------------------------------------------



------------------------------------------------
local targetParticle = 0
------------------------------------------------

------------------
local blinked = {}
------------------





-------------------------------------------------------------------------------------------------------------------------------------------------
--Перевод
local RU = "russian"
local EN = "english" 
local CN = "Chinese" 
 
 
local language = EN
 
local LanguageItem = Menu.GetLanguageOptionId()
local menuLang = Menu.GetValue(LanguageItem)
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
    	[RU] = "Кнопка для комбо",
    	[EN] = "Combo button",
		[CN] = "Combo Key - combo键",
    },
    ["optionIsTargetParticleEnabled"] = {
    	[RU] = "Рисовать партикль захваченной цели",
    	[EN] = "Draws particle for current target",
		[CN] = "目标指示器",
    },
    ["optionCursor"] = {
    	[RU] = "Двигаться к курсору если нет врага в комбо",
    	[EN] = "Move to cursor if no enemy in combo",
		[CN] = "Move to cursor if no enemy in combo",
    },
    ["optionCarapaseDis"] = {
    	[RU] = "Анти-Инициация",
    	[EN] = "Anti-Initiation",
		[EN] = "Anti-Initiation",
    },
    ["optionVendetta"] = {
    	[RU] = "Атака из Vendetta",
    	[EN] = "Attack from Vendetta",
		[EN] = "",
    },
}




local rootPath = "Hero Specific"

local mainPath = {rootPath, "Nyx"}

local skillsPath = {rootPath, "Nyx", "Skills for Combo"}

local itemsPath = {rootPath, "Nyx", "Items"}

local linkenPath = {rootPath, "Nyx", "Linken Breaker"}

if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Nyx"}
    skillsPath = {rootPath, "Nyx", "Способности для Комбо"}
    itemsPath = {rootPath, "Nyx", "Предметы"}
    linkenPath = {rootPath, "Nyx", "Сбитие Линки"}
end 

if language == CN then
    rootPath = "独立英雄脚本"
    mainPath = {rootPath, "Nyx"}
    skillsPath = {rootPath, "Nyx", "技能"}
    itemsPath = {rootPath, "Nyx", "物品"}
    linkenPath = {rootPath, "Nyx", "自动破林肯"}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------
Nyx.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Nyx.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_nyx_assassin_png.vtex_c")

Nyx.optionFullCombo = Menu.AddKeyOption(mainPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Nyx.optionFullCombo, "~/MenuIcons/enemy_evil.png")

Nyx.optionCursor = Menu.AddOptionBool(mainPath, Translation.optionCursor[language], true)
Menu.AddOptionIcon(Nyx.optionCursor, "~/MenuIcons/cursor.png")

Nyx.optionIsTargetParticleEnabled = Menu.AddOptionBool(mainPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Nyx.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Nyx.optionRangeToTarget = Menu.AddOptionSlider(mainPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Nyx.optionRangeToTarget, "~/MenuIcons/edit.png")

Nyx.optionCarapaseDis = Menu.AddOptionBool(mainPath,  Translation.optionCarapaseDis[language], true)
Menu.AddOptionIcon(Nyx.optionCarapaseDis, "panorama/images/spellicons/".."nyx_assassin_spiked_carapace".."_png.vtex_c")
---------------------------------------------------------------------------------------------------------------------------
Nyx.optionImpale = Menu.AddOptionBool(skillsPath, "Impale", true)
Menu.AddOptionIcon(Nyx.optionImpale, "panorama/images/spellicons/".."nyx_assassin_impale".."_png.vtex_c")
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

Nyx.optionBurn = Menu.AddOptionBool(skillsPath, "Mana Burn", true)
Menu.AddOptionIcon(Nyx.optionBurn, "panorama/images/spellicons/".."nyx_assassin_mana_burn".."_png.vtex_c")

Nyx.optionCarapase = Menu.AddOptionBool(skillsPath, "Spiked Carapace", false)
Menu.AddOptionIcon(Nyx.optionCarapase, "panorama/images/spellicons/".."nyx_assassin_spiked_carapace".."_png.vtex_c")

Nyx.optionVendetta = Menu.AddOptionBool(skillsPath, Translation.optionVendetta[language], true)
Menu.AddOptionIcon(Nyx.optionVendetta, "panorama/images/spellicons/".."nyx_assassin_vendetta".."_png.vtex_c")
---------------------------------------------------------------------------------------------------------------------------
Nyx.optionSheepStick = Menu.AddOptionBool(itemsPath, "Scythe of Vyse", true)
Menu.AddOptionIcon(Nyx.optionSheepStick, "panorama/images/items/".."sheepstick".."_png.vtex_c")
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

Nyx.optionBloodthorn = Menu.AddOptionBool(itemsPath, "Bloodthorn", true)
Menu.AddOptionIcon(Nyx.optionBloodthorn, "panorama/images/items/".."bloodthorn".."_png.vtex_c")

Nyx.optionOrchidMalevolence = Menu.AddOptionBool(itemsPath, "Orchid Malevolence", true)
Menu.AddOptionIcon(Nyx.optionOrchidMalevolence, "panorama/images/items/".."orchid".."_png.vtex_c")

Nyx.optionShivasGuard = Menu.AddOptionBool(itemsPath, "Shivas Guard", true)
Menu.AddOptionIcon(Nyx.optionShivasGuard, "panorama/images/items/".."shivas_guard".."_png.vtex_c")

Nyx.optionBlackKingBar = Menu.AddOptionBool(itemsPath, "Black King Bar", false)
Menu.AddOptionIcon(Nyx.optionBlackKingBar, "panorama/images/items/".."black_king_bar".."_png.vtex_c")

Nyx.optionBladeMail = Menu.AddOptionBool(itemsPath, "Blade Mail", true)
Menu.AddOptionIcon(Nyx.optionBladeMail, "panorama/images/items/".."blade_mail".."_png.vtex_c")

Nyx.optionLotusOrb = Menu.AddOptionBool(itemsPath, "Lotus Orb", true)
Menu.AddOptionIcon(Nyx.optionLotusOrb, "panorama/images/items/".."lotus_orb".."_png.vtex_c")

Nyx.optionVeilOfDiscord = Menu.AddOptionBool(itemsPath, "Veil Of Discord", true)
Menu.AddOptionIcon(Nyx.optionVeilOfDiscord, "panorama/images/items/".."veil_of_discord".."_png.vtex_c")

Nyx.optionEthereal = Menu.AddOptionBool(itemsPath, "Ethereal Blade", true)
Menu.AddOptionIcon(Nyx.optionEthereal, "panorama/images/items/".."ethereal_blade".."_png.vtex_c")

Nyx.optionDagon = Menu.AddOptionBool(itemsPath, "Dagon", true)
Menu.AddOptionIcon(Nyx.optionDagon, "panorama/images/items/".."dagon".."_png.vtex_c")
-----------------------------------------------------------------------------------------------------------------------
Nyx.optionBurnL = Menu.AddOptionBool(linkenPath, "Mana Burn", true)
Menu.AddOptionIcon(Nyx.optionBurnL, "panorama/images/spellicons/".."nyx_assassin_mana_burn".."_png.vtex_c")
Menu.AddMenuIcon(linkenPath, "panorama/images/items/".."sphere".."_png.vtex_c")

Nyx.optionDagonL = Menu.AddOptionBool(linkenPath, "Dagon", false)
Menu.AddOptionIcon(Nyx.optionDagonL, "panorama/images/items/".."dagon".."_png.vtex_c")

Nyx.optionOrchidMalevolenceL = Menu.AddOptionBool(linkenPath, "Orchid Malevolence", false)
Menu.AddOptionIcon(Nyx.optionOrchidMalevolenceL, "panorama/images/items/".."orchid".."_png.vtex_c")

---------------------------------------------Главнвя функция------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
function Nyx.OnUpdate()

	if (not Menu.IsEnabled(Nyx.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_nyx_assassin" then 
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

	if (not impale) then
		impale = NPC.GetAbility(myHero, "nyx_assassin_impale")
		return
	end

	if (not burn) then
		burn = NPC.GetAbility(myHero, "nyx_assassin_mana_burn")
		return
	end
	
	if (not carapace) then
		carapace = NPC.GetAbility(myHero, "nyx_assassin_spiked_carapace")
		return
	end

	if (not vendetta) then
		vendetta = NPC.GetAbility(myHero, "nyx_assassin_vendetta")
		return
	end
----------------------------------------------------------------------------




--Предметы

	local sheepstick = NPC.GetItem(myHero, "item_sheepstick")

	local bloodthorn = NPC.GetItem(myHero, "item_bloodthorn")

	local orchid = NPC.GetItem(myHero, "item_orchid")

	local shivasguard = NPC.GetItem(myHero, "item_shivas_guard")

	local blackkingbar = NPC.GetItem(myHero, "item_black_king_bar")

	local blademail = NPC.GetItem(myHero, "item_blade_mail")

	local lotusorb = NPC.GetItem(myHero, "item_lotus_orb")

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
	if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Nyx.optionRangeToTarget), 0) then
		enemy = nil
	end
	if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
		enemy = nil
	end
---------------------------------------------------------------------------------------------------
	
--Преследовать курсор
	if Menu.IsEnabled(Nyx.optionCursor) then
		if Menu.IsKeyDown(Nyx.optionFullCombo) and (not enemy) and (not NPC.IsChannellingAbility(myHero)) then
			NPC.MoveTo(myHero, Input.GetWorldCursorPos())	
		end
	end	


	--Анти-врыв
	if Menu.IsEnabled(Nyx.optionCarapaseDis) and blinked[#blinked] and blinked[#blinked].unit and  blinked[#blinked].time and ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(blinked[#blinked].unit))):Length2D()) < 700 and (GameRules.GetGameTime() - blinked[#blinked].time) < 0.1  then
		if Ability.IsReady(carapace) and Ability.IsCastable(carapace, mana) then
    		Ability.CastNoTarget(carapace)
    	end	
	end		

--Полное комбо

	if Menu.IsKeyDown(Nyx.optionFullCombo) and enemy then

		if Nyx.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, myHero, enemy)
			lastMoveOrder = os.clock()
		end

		local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
		if Menu.IsEnabled(Nyx.optionVendetta) and Nyx.Vendetta(vendetta, mana, myHero, myPlayer, enemy, distance) == true then
			return
		end

		if NPC.IsLinkensProtected(enemy) then

			if Menu.IsEnabled(Nyx.optionBurnL) then
				if Nyx.Burn(burn, mana, enemy) == true then
					return
				end
			end	

			if Menu.IsEnabled(Nyx.optionDagonL) then
				if Nyx.ItemTarget(dagon, enemy, mana) == true then
					return
				end
			end

			if Menu.IsEnabled(Nyx.optionOrchidMalevolenceL) then
				if Nyx.ItemTarget(orchid, enemy, mana) == true then
					return
				end
			end		
		end					

		if Menu.IsEnabled(Nyx.optionSheepStick) and Nyx.ItemTarget(sheepstick, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Nyx.optionBloodthorn) and Nyx.ItemTarget(bloodthorn, enemy, mana) == true then
			return
		end

		if  Menu.IsEnabled(Nyx.optionOrchidMalevolence) and Nyx.ItemTarget(orchid, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Nyx.optionVeilOfDiscord) and Nyx.ItemOrigin(veilofdiscord, Entity.GetAbsOrigin(enemy), mana) == true then
			return
		end

		if Menu.IsEnabled(Nyx.optionEthereal) and Nyx.ItemTarget(etherealblade, enemy, mana) == true then
			return
		end

		if Menu.IsEnabled(Nyx.optionDagon) and Nyx.ItemTarget(dagon, enemy, mana) == true then
			return
		end

		if Nyx.Impale(impale, Entity.GetAbsOrigin(enemy), mana) == true then
			return
		end

		if Menu.IsEnabled(Nyx.optionShivasGuard) and  Nyx.ItemNoTarget(shivasguard, mana) == true then
			return
		end

		if Nyx.Burn(burn, mana, enemy) == true then
			return
		end


	
		if  Menu.IsEnabled(Nyx.optionLotusOrb) and  Nyx.ItemTarget(lotusorb, myHero, mana) == true then
			return
		end
	

		if Menu.IsEnabled(Nyx.optionBlackKingBar) and Nyx.ItemNoTarget(blackkingbar, mana) == true then
			return
		end

		if Menu.IsEnabled(Nyx.optionBladeMail) and Nyx.ItemNoTarget(blademail, mana) == true then
			return
		end

		if Menu.IsEnabled(Nyx.optionCarapase) and Nyx.Carapace(carapace, mana) == true then
			return
		end
	end	
-------------------------------------------------------------------------------	
end







----------------------------------------------------------------------------------------
--Рисуем Партикль
function Nyx.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_nyx_assassin" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(Nyx.optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Nyx.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Nyx.optionRangeToTarget), 0) then
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

function Nyx.Impale(ability, origin, mana)
	if Menu.IsEnabled(Nyx.optionImpale) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Nyx.Burn(ability, mana, enemy)
	if Menu.IsEnabled(Nyx.optionBurn) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastTarget(ability, enemy)
    	return true
    end	 
end

function Nyx.Carapace(ability, mana)
	if Menu.IsEnabled(Nyx.optionCarapase) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastNoTarget(ability)
    	return true
    end	 
end

function Nyx.Vendetta(ability, mana, myHero, myPlayer, enemy, distance)
	if Menu.IsEnabled(Nyx.optionVendetta) then
		if Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not NPC.GetModifier(myHero, "modifier_nyx_assassin_vendetta") and distance > 800 then
    		Ability.CastNoTarget(ability)	
    		return true
    	end
    	if NPC.GetModifier(myHero, "modifier_nyx_assassin_vendetta") then
    		Player.AttackTarget(myPlayer, myHero, enemy)
    		return true
    	end	
    end	
end
-----------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------
--Анти-врыв
Nyx.BlinkParticle = {
    ["blink_dagger_end"] = "entity", 
    ["phantom_assassin_phantom_strike_end"] = "entity",
    ["antimage_blink_end"] = "entity",  
    ["queen_blink_end"] = "entityForModifiers",
    ["faceless_void_time_walk_preimage"] = "entityForModifiers",
}
 
function Nyx.OnParticleCreate(p1)
    if p1.name  and Nyx.BlinkParticle[p1.name] and p1[Nyx.BlinkParticle[p1.name]] then
        local temp = {}
        temp.unit = p1[Nyx.BlinkParticle[p1.name]]
        temp.time = GameRules.GetGameTime()
 
        -- долгая анимация прыжка
        if p1.name == "faceless_void_time_walk_preimage" then
            temp.time = temp.time + 0.2
        end
        blinked[#blinked+1] = temp
    end 
end



--Функции предметов

function Nyx.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Nyx.ItemOrigin(item, origin, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastPosition(item, origin) 
    	return true
    end	  
end


function Nyx.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end


return Nyx