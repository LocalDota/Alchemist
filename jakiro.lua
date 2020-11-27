local Jakiro = {}

local myHero, myPlayer, enemy, dual, ice, liquid, macropyre = nil, nil, nil, nil, nil, nil, nil


------------------------------------------------
local targetParticle = 0
------------------------------------------------



--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1 

function Jakiro.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end
--------------------------------------------------









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
    ["optionCursor"] = {
    	[RU] = "Двигаться к курсору если нет врага в комбо", 
    	[EN] = "Move to cursor if no enemy in combo",
		[CN] = "无目标时移动到鼠标",
    },
    ["optionEul"] = {
    	[RU] = "Использовать еул", 
    	[EN] = "Use eul",
		[CN] = "",
    },
}




local rootPath = "Hero Specific"

local mainPath = {rootPath, "Jakiro"}

local skillsPath = {rootPath, "Jakiro", "Skills"}

local itemsPath = {rootPath, "Jakiro", "Items"}


if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Jakiro"}
    skillsPath = {rootPath, "Jakiro", "Способности"}
    itemsPath = {rootPath, "Jakiro", "Предметы"}
end 

if language == CN then
    rootPath = "独立英雄脚本"
    mainPath = {rootPath, "Jakiro"}
    skillsPath = {rootPath, "Jakiro", ""}
    itemsPath = {rootPath, "Jakiro", ""}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------
Jakiro.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Jakiro.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_jakiro_png.vtex_c")

Jakiro.optionFullCombo = Menu.AddKeyOption(mainPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Jakiro.optionFullCombo, "~/MenuIcons/enemy_evil.png")

Jakiro.optionEul = Menu.AddOptionBool(mainPath, Translation.optionEul[language], false)
Menu.AddOptionIcon(Jakiro.optionEul, "panorama/images/items/".."cyclone".."_png.vtex_c")

Jakiro.optionCursor = Menu.AddOptionBool(mainPath, Translation.optionCursor[language], true)
Menu.AddOptionIcon(Jakiro.optionCursor, "~/MenuIcons/cursor.png")


Jakiro.optionIsTargetParticleEnabled = Menu.AddOptionBool(mainPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Jakiro.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Jakiro.optionRangeToTarget = Menu.AddOptionSlider(mainPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Jakiro.optionRangeToTarget, "~/MenuIcons/edit.png")
---------------------------------------------------------------------------------------------------------------------------
Jakiro.optionDual = Menu.AddOptionBool(skillsPath, "Dual Breath", true)
Menu.AddOptionIcon(Jakiro.optionDual, "panorama/images/spellicons/".."jakiro_dual_breath".."_png.vtex_c")
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

Jakiro.optionIce = Menu.AddOptionBool(skillsPath, "Ice Path", true)
Menu.AddOptionIcon(Jakiro.optionIce, "panorama/images/spellicons/".."jakiro_ice_path".."_png.vtex_c")

Jakiro.optionLiquid = Menu.AddOptionBool(skillsPath, "Liquid Fire", true)
Menu.AddOptionIcon(Jakiro.optionLiquid, "panorama/images/spellicons/".."jakiro_liquid_fire".."_png.vtex_c")

Jakiro.optionMacropyre = Menu.AddOptionBool(skillsPath, "Macropyre", true)
Menu.AddOptionIcon(Jakiro.optionMacropyre, "panorama/images/spellicons/".."jakiro_macropyre".."_png.vtex_c")

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
Jakiro.optionSheepStick = Menu.AddOptionBool(itemsPath, "Scythe of Vyse", true)
Menu.AddOptionIcon(Jakiro.optionSheepStick, "panorama/images/items/".."sheepstick".."_png.vtex_c")
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

Jakiro.optionMjollnir = Menu.AddOptionBool(itemsPath, "Mjollnir", true)
Menu.AddOptionIcon(Jakiro.optionMjollnir, "panorama/images/items/".."mjollnir".."_png.vtex_c")

Jakiro.optionBloodthorn = Menu.AddOptionBool(itemsPath, "Bloodthorn", true)
Menu.AddOptionIcon(Jakiro.optionBloodthorn, "panorama/images/items/".."bloodthorn".."_png.vtex_c")

Jakiro.optionOrchidMalevolence = Menu.AddOptionBool(itemsPath, "Orchid Malevolence", true)
Menu.AddOptionIcon(Jakiro.optionOrchidMalevolence, "panorama/images/items/".."orchid".."_png.vtex_c")

Jakiro.optionShivasGuard = Menu.AddOptionBool(itemsPath, "Shivas Guard", true)
Menu.AddOptionIcon(Jakiro.optionShivasGuard, "panorama/images/items/".."shivas_guard".."_png.vtex_c")

Jakiro.optionBlackKingBar = Menu.AddOptionBool(itemsPath, "Black King Bar", false)
Menu.AddOptionIcon(Jakiro.optionBlackKingBar, "panorama/images/items/".."black_king_bar".."_png.vtex_c")

Jakiro.optionAtos = Menu.AddOptionBool(itemsPath, "Rod of Atos", true)
Menu.AddOptionIcon(Jakiro.optionAtos, "panorama/images/items/".."rod_of_atos".."_png.vtex_c")

Jakiro.optionVeil = Menu.AddOptionBool(itemsPath, "Veil of discord", true)
Menu.AddOptionIcon(Jakiro.optionVeil, "panorama/images/items/".."veil_of_discord".."_png.vtex_c")

Jakiro.optionSolar = Menu.AddOptionBool(itemsPath, "Solar Crest", true)
Menu.AddOptionIcon(Jakiro.optionSolar, "panorama/images/items/".."solar_crest".."_png.vtex_c")

Jakiro.optionMedalion = Menu.AddOptionBool(itemsPath, "Medalion of courage", true)
Menu.AddOptionIcon(Jakiro.optionMedalion, "panorama/images/items/".."medallion_of_courage".."_png.vtex_c")

-----------------------------------------------------------------------------------------------------------------------







function Jakiro.OnUpdate()

	if (not Menu.IsEnabled(Jakiro.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_jakiro" then 
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

	if (not dual) then
		dual = NPC.GetAbility(myHero, "jakiro_dual_breath")
		return
	end

	if (not ice) then
		ice = NPC.GetAbility(myHero, "jakiro_ice_path")
		return
	end
	
	if (not liquid) then
		liquid = NPC.GetAbility(myHero, "jakiro_liquid_fire")
		return
	end

	if (not macropyre) then
		macropyre = NPC.GetAbility(myHero, "jakiro_macropyre")
		return
	end
----------------------------------------------------------------------------



--Предметы

	local sheepstick = Jakiro.CheckItem("item_sheepstick")

	local mjollnir = Jakiro.CheckItem("item_mjollnir")

	local bloodthorn = Jakiro.CheckItem("item_bloodthorn")

	local orchid = Jakiro.CheckItem("item_orchid")

	local shivasguard = Jakiro.CheckItem("item_shivas_guard")

	local blackkingbar = Jakiro.CheckItem("item_black_king_bar")

	local atos = Jakiro.CheckItem("item_rod_of_atos")

	local veil = Jakiro.CheckItem("item_veil_of_discord")

	local solar = Jakiro.CheckItem("item_solar_crest")

	local medallionofcourage = Jakiro.CheckItem("item_medallion_of_courage")

	local eul = Jakiro.CheckItem("item_cyclone")


--------------------------------------------------------------------------------




--Врага ищем
	if not enemy then
		enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	end
	if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Jakiro.optionRangeToTarget), 0) then
		enemy = nil
	end
	if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
		enemy = nil
	end
---------------------------------------------------------------------------------------------------




--Полное комбо

	if Menu.IsKeyDown(Jakiro.optionFullCombo) and enemy and (not NPC.IsChannellingAbility(myHero)) and (not NPC.GetModifier(enemy, "modifier_black_king_bar_immune")) and (not NPC.GetModifier(enemy, "modifier_life_stealer_rage")) and (not NPC.GetModifier(enemy, "modifier_juggernaut_blade_fury"))  then
		local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
		local origin = Entity.GetOrigin(enemy)
		local modifierCyclone = NPC.GetModifier(enemy, 'modifier_eul_cyclone')	

		if Menu.IsEnabled(Jakiro.optionSheepStick) and not modifierCyclone and Jakiro.ItemTarget(sheepstick, enemy, mana) == true then
			return
		end	

		if  Menu.IsEnabled(Jakiro.optionAtos) and not NPC.GetModifier(enemy, 'modifier_sheepstick_debuff') and Jakiro.ItemTarget(atos, enemy, mana) == true then
			return
		end	

		if Menu.IsEnabled(Jakiro.optionEul) and not NPC.GetModifier(enemy, 'modifier_sheepstick_debuff') and not NPC.GetModifier(enemy, 'modifier_rod_of_atos_debuff') and not NPC.IsStunned(enemy) and Jakiro.ItemTarget(eul, enemy, mana) == true then
			return
		end

		if modifierCyclone then
			local timer = Modifier.GetDieTime(modifierCyclone) - GameRules.GetGameTime()
			if timer < (1.2 - NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) then
				if Jakiro.Ice(ice, origin, mana) then
					return
				end	
			end
			return 
		end	

		if Menu.IsEnabled(Jakiro.optionBloodthorn) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Jakiro.ItemTarget(bloodthorn, enemy, mana) == true then
			return
		end

		if  Menu.IsEnabled(Jakiro.optionOrchidMalevolence) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and Jakiro.ItemTarget(orchid, enemy, mana) == true then
			return
		end

		if  Menu.IsEnabled(Jakiro.optionVeil) and Jakiro.ItemOrigin(veil, origin, mana) == true then
			return
		end

		position =  Jakiro.GetPredictedPosition(enemy, 1.4)
		if  atos and not Ability.IsReady(atos) then
			position =  Jakiro.GetPredictedPosition(enemy, 0)
		end
		if not newpos then
			newpos = Jakiro.GetPredictedPosition(enemy, 1.4)
		end	
		if  Menu.IsEnabled(Jakiro.optionIce) and Jakiro.Ice(ice, position, mana) == true then
			if newpos and ((newpos - position):Length2D()) > 450  then
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_HOLD_POSITION, nil, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, myHero)
				newpos = nil
			end	
			return
		end

		if NPC.GetModifier(enemy, "modifier_jakiro_ice_path_stun") then
			if  Menu.IsEnabled(Jakiro.optionMacropyre) and Jakiro.Macropyre(macropyre, origin, mana) == true then
				return
			end
		end	

		if  Menu.IsEnabled(Jakiro.optionDual) and Jakiro.Dual(dual, mana, enemy) == true then
			return
		end

		if  Menu.IsEnabled(Jakiro.optionLiquid) and Jakiro.Liquid(liquid, mana, enemy) == true then
			return
		end

		if  Menu.IsEnabled(Jakiro.optionSolar) and Jakiro.ItemTarget(solar, enemy, mana) == true then
			return
		end	

		if  Menu.IsEnabled(Jakiro.optionMedalion) and Jakiro.ItemTarget(medallionofcourage, enemy, mana) == true then
			return
		end	

		if Menu.IsEnabled(Jakiro.optionShivasGuard) and  Jakiro.ItemNoTarget(shivasguard, mana) == true then
			return
		end
		
		if Menu.IsEnabled(Jakiro.optionMjollnir) and Jakiro.ItemTarget(mjollnir, myHero, mana) == true then
			return
		end

		if Menu.IsEnabled(Jakiro.optionBlackKingBar) and Jakiro.ItemNoTarget(blackkingbar, mana) == true then
			return
		end

		if Jakiro.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, myHero, enemy)
			lastMoveOrder = os.clock()
		end	
	end				

--Преследовать курсор
	if Menu.IsEnabled(Jakiro.optionCursor) then
		if Menu.IsKeyDown(Jakiro.optionFullCombo) then
			if (not enemy) and (not NPC.IsChannellingAbility(myHero)) then
				NPC.MoveTo(myHero, Input.GetWorldCursorPos())
			end		
		end	
	end			
-------------------------------------------------------------------------------		
end





----------------------------------------------------------------------------------------
--Рисуем Партикль
function Jakiro.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_jakiro" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(Jakiro.optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Jakiro.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Jakiro.optionRangeToTarget), 0) then
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
function Jakiro.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc)
    if not NPC.IsRunning(npc) or not delay  then return pos end

    local dir = Entity.GetRotation(npc):GetForward():Normalized()
    local speed = NPC.GetMoveSpeed(npc)

    return pos + dir:Scaled(speed * delay)
end





--Функции способностей

function Jakiro.Dual(ability, mana, enemy)
	if Menu.IsEnabled(Jakiro.optionDual) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastTarget(ability, enemy)
    	return true 
    end	
end

function Jakiro.Ice(ability, origin, mana)
	if Menu.IsEnabled(Jakiro.optionIce) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana)  then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Jakiro.Liquid(ability, mana, enemy)
	if Menu.IsEnabled(Jakiro.optionLiquid) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastTarget(ability, enemy)
    	return true
    end	
end

function Jakiro.Macropyre(ability, origin, mana)
	if Menu.IsEnabled(Jakiro.optionMacropyre) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana)  then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end




--Функции предметов

function Jakiro.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Jakiro.ItemOrigin(item, origin, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastPosition(item, origin) 
    	return true
    end	  
end


function Jakiro.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end




--Проверка на слоты
function Jakiro.CheckItem(item)
	for i = 0, 5 do
        local itemCheck = NPC.GetItemByIndex(myHero, i)
        if itemCheck and item == Ability.GetName(itemCheck) then
            return itemCheck
        end
	end
end



function Jakiro.OnEntityDestroy(entity)
    if not myHero then 
        return
    end 

    if entity == myHero then
        Jakiro.Reinit()
        return
    end 
end 

function Jakiro.Reinit()
    myHero, myPlayer, enemy, dual, ice, liquid, macropyre = nil, nil, nil, nil, nil, nil, nil

    particleEnemy = nil
 
end 





return Jakiro