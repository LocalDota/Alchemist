local Venomancer = {}

local myHero, myPlayer, enemy, gale, ward, nova = nil, nil, nil, nil, nil, nil


------------------------------------------------
local targetParticle = 0
------------------------------------------------



--------------------------------------------------
--Задержка
local lastMoveOrder = 0
local orderDelay = 0.1 

function Venomancer.SleepReady(sleep, lastTick)
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
    ["optionBlink"] = {
    	[RU] = "Использовать блинк", 
    	[EN] = "Use blink",
		[CN] = "",
    },
}




local rootPath = "Hero Specific"

local mainPath = {rootPath, "Venomancer"}

local skillsPath = {rootPath, "Venomancer", "Skills"}

local itemsPath = {rootPath, "Venomancer", "Items"}


if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Venomancer"}
    skillsPath = {rootPath, "Venomancer", "Способности"}
    itemsPath = {rootPath, "Venomancer", "Предметы"}
end 

if language == CN then
    rootPath = "独立英雄脚本"
    mainPath = {rootPath, "Venomancer"}
    skillsPath = {rootPath, "Venomancer", ""}
    itemsPath = {rootPath, "Venomancer", ""}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------
Venomancer.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Venomancer.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_venomancer_png.vtex_c")

Venomancer.optionFullCombo = Menu.AddKeyOption(mainPath, Translation.optionFullCombo[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Venomancer.optionFullCombo, "~/MenuIcons/enemy_evil.png")

Venomancer.optionCursor = Menu.AddOptionBool(mainPath, Translation.optionCursor[language], true)
Menu.AddOptionIcon(Venomancer.optionCursor, "~/MenuIcons/cursor.png")

Venomancer.optionBlink = Menu.AddOptionBool(mainPath, Translation.optionBlink[language], true)
Menu.AddOptionIcon(Venomancer.optionBlink, "panorama/images/items/".."blink".."_png.vtex_c")


Venomancer.optionIsTargetParticleEnabled = Menu.AddOptionBool(mainPath, Translation.optionIsTargetParticleEnabled[language], true)
Menu.AddOptionIcon(Venomancer.optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
Venomancer.optionRangeToTarget = Menu.AddOptionSlider(mainPath, Translation.optionRangeToTarget[language], 1, 3000, 500)
Menu.AddOptionIcon(Venomancer.optionRangeToTarget, "~/MenuIcons/edit.png")
---------------------------------------------------------------------------------------------------------------------------
Venomancer.optionGale = Menu.AddOptionBool(skillsPath, "Venomous Gale", true)
Menu.AddOptionIcon(Venomancer.optionGale, "panorama/images/spellicons/".."venomancer_venomous_gale".."_png.vtex_c")
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")

Venomancer.optionWard = Menu.AddOptionBool(skillsPath, "Plague Ward", true)
Menu.AddOptionIcon(Venomancer.optionWard, "panorama/images/spellicons/".."venomancer_plague_ward".."_png.vtex_c")

Venomancer.optionNova = Menu.AddOptionBool(skillsPath, "Poison Nova", true)
Menu.AddOptionIcon(Venomancer.optionNova, "panorama/images/spellicons/".."venomancer_poison_nova".."_png.vtex_c")

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
Venomancer.optionSheepStick = Menu.AddOptionBool(itemsPath, "Scythe of Vyse", true)
Menu.AddOptionIcon(Venomancer.optionSheepStick, "panorama/images/items/".."sheepstick".."_png.vtex_c")
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

Venomancer.optionBloodthorn = Menu.AddOptionBool(itemsPath, "Bloodthorn", true)
Menu.AddOptionIcon(Venomancer.optionBloodthorn, "panorama/images/items/".."bloodthorn".."_png.vtex_c")

Venomancer.optionOrchidMalevolence = Menu.AddOptionBool(itemsPath, "Orchid Malevolence", true)
Menu.AddOptionIcon(Venomancer.optionOrchidMalevolence, "panorama/images/items/".."orchid".."_png.vtex_c")

Venomancer.optionShivasGuard = Menu.AddOptionBool(itemsPath, "Shivas Guard", true)
Menu.AddOptionIcon(Venomancer.optionShivasGuard, "panorama/images/items/".."shivas_guard".."_png.vtex_c")

Venomancer.optionBlackKingBar = Menu.AddOptionBool(itemsPath, "Black King Bar", false)
Menu.AddOptionIcon(Venomancer.optionBlackKingBar, "panorama/images/items/".."black_king_bar".."_png.vtex_c")

Venomancer.optionVeil = Menu.AddOptionBool(itemsPath, "Veil of discord", true)
Menu.AddOptionIcon(Venomancer.optionVeil, "panorama/images/items/".."veil_of_discord".."_png.vtex_c")

Venomancer.optionSolar = Menu.AddOptionBool(itemsPath, "Solar Crest", true)
Menu.AddOptionIcon(Venomancer.optionSolar, "panorama/images/items/".."solar_crest".."_png.vtex_c")

Venomancer.optionMedalion = Menu.AddOptionBool(itemsPath, "Medalion of courage", true)
Menu.AddOptionIcon(Venomancer.optionMedalion, "panorama/images/items/".."medallion_of_courage".."_png.vtex_c")

Venomancer.optionAtos = Menu.AddOptionBool(itemsPath, "Rod of Atos", true)
Menu.AddOptionIcon(Venomancer.optionAtos, "panorama/images/items/".."rod_of_atos".."_png.vtex_c")

Venomancer.optionUrn = Menu.AddOptionBool(itemsPath, "Urn of shadows", true)
Menu.AddOptionIcon(Venomancer.optionUrn, "panorama/images/items/".."urn_of_shadows".."_png.vtex_c")

Venomancer.optionSpirit = Menu.AddOptionBool(itemsPath, "Spirit vessel", true)
Menu.AddOptionIcon(Venomancer.optionSpirit, "panorama/images/items/".."spirit_vessel".."_png.vtex_c")

-----------------------------------------------------------------------------------------------------------------------






function Venomancer.OnUpdate()

	if (not Menu.IsEnabled(Venomancer.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_venomancer" then 
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

	if (not gale) then
		gale = NPC.GetAbility(myHero, "venomancer_venomous_gale")
		return
	end

	if (not ward) then
		ward = NPC.GetAbility(myHero, "venomancer_plague_ward")
		return
	end
	
	if (not nova) then
		nova = NPC.GetAbility(myHero, "venomancer_poison_nova")
		return
	end
----------------------------------------------------------------------------



--Предметы

	local sheepstick = Venomancer.CheckItem("item_sheepstick")

	local bloodthorn = Venomancer.CheckItem("item_bloodthorn")

	local orchid = Venomancer.CheckItem("item_orchid")

	local shivasguard = Venomancer.CheckItem("item_shivas_guard")

	local blackkingbar = Venomancer.CheckItem("item_black_king_bar")

	local veil = Venomancer.CheckItem("item_veil_of_discord")

	local solar = Venomancer.CheckItem("item_solar_crest")

	local medallionofcourage = Venomancer.CheckItem("item_medallion_of_courage")

	local blink = Venomancer.CheckItem("item_blink")

	local urn = Venomancer.CheckItem("item_urn_of_shadows")

	local spirit = Venomancer.CheckItem("item_spirit_vessel")

	local atos = Venomancer.CheckItem("item_rod_of_atos")



--------------------------------------------------------------------------------




--Врага ищем
	if not enemy then
		enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	end
	if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Venomancer.optionRangeToTarget), 0) then
		enemy = nil
	end
	if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
		enemy = nil
	end
---------------------------------------------------------------------------------------------------






--Полное комбо

	if Menu.IsKeyDown(Venomancer.optionFullCombo) and enemy and (not NPC.IsChannellingAbility(myHero)) and (not NPC.GetModifier(enemy, "modifier_black_king_bar_immune")) and (not NPC.GetModifier(enemy, "modifier_life_stealer_rage")) and (not NPC.GetModifier(enemy, "modifier_juggernaut_blade_fury"))  then
		local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
		local origin = Entity.GetOrigin(enemy)


		if Venomancer.Blink(blink, origin, distance, mana) == true then
			return
		end


		if Menu.IsEnabled(Venomancer.optionSheepStick) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(enemy)):Length2D()) < 800 and not NPC.IsStunned(enemy) and not modifierCyclone and Venomancer.ItemTarget(sheepstick, enemy, mana) == true then
			return
		end	

		if  Menu.IsEnabled(Venomancer.optionAtos) and not NPC.GetModifier(enemy, 'modifier_sheepstick_debuff') and Venomancer.ItemTarget(atos, enemy, mana) == true then
			return
		end	

		if Menu.IsEnabled(Venomancer.optionBloodthorn) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Venomancer.ItemTarget(bloodthorn, enemy, mana) == true then
			return
		end

		if  Menu.IsEnabled(Venomancer.optionOrchidMalevolence) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and Venomancer.ItemTarget(orchid, enemy, mana) == true then
			return
		end

		if  Menu.IsEnabled(Venomancer.optionVeil) and Venomancer.ItemOrigin(veil, origin, mana) == true then
			return
		end

		if  Menu.IsEnabled(Venomancer.optionWard) and Venomancer.Ward(ward, origin, mana) == true then
			return
		end

		position =  Venomancer.GetPredictedPosition(enemy, 0.7)
		if  atos and not Ability.IsReady(atos) then
			position =  Venomancer.GetPredictedPosition(enemy, 0)
		end

		if  Menu.IsEnabled(Venomancer.optionGale) and Venomancer.Gale(gale, position, mana) == true then
			return
		end

		if  Menu.IsEnabled(Venomancer.optionNova) and Venomancer.Nova(nova, mana, distance) == true then
			return
		end

		if  Menu.IsEnabled(Venomancer.optionSolar) and Venomancer.ItemTarget(solar, enemy, mana) == true then
			return
		end	

		if  Menu.IsEnabled(Venomancer.optionMedalion) and Venomancer.ItemTarget(medallionofcourage, enemy, mana) == true then
			return
		end	

		if Menu.IsEnabled(Venomancer.optionShivasGuard) and  Venomancer.ItemNoTarget(shivasguard, mana) == true then
			return
		end

		if  Menu.IsEnabled(Venomancer.optionUrn) and urn and Item.GetCurrentCharges(urn) > 0 and Venomancer.ItemTarget(urn, enemy, mana) == true then
			return
		end	

		if  Menu.IsEnabled(Venomancer.optionSpirit) and spirit and Item.GetCurrentCharges(spirit) > 0 and Venomancer.ItemTarget(spirit, enemy, mana) == true then
			return
		end	

		if Menu.IsEnabled(Venomancer.optionBlackKingBar) and Venomancer.ItemNoTarget(blackkingbar, mana) == true then
			return
		end

		if Venomancer.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, myHero, enemy)
			lastMoveOrder = os.clock()
		end	
	end				

--Преследовать курсор
	if Menu.IsEnabled(Venomancer.optionCursor) then
		if Menu.IsKeyDown(Venomancer.optionFullCombo) then
			if (not enemy) and (not NPC.IsChannellingAbility(myHero)) then
				NPC.MoveTo(myHero, Input.GetWorldCursorPos())
			end		
		end	
	end			
-------------------------------------------------------------------------------		
end






----------------------------------------------------------------------------------------
--Рисуем Партикль
function Venomancer.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_venomancer" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(Venomancer.optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Venomancer.optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(Venomancer.optionRangeToTarget), 0) then
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
function Venomancer.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc)
    if not NPC.IsRunning(npc) or not delay  then return pos end

    local dir = Entity.GetRotation(npc):GetForward():Normalized()
    local speed = NPC.GetMoveSpeed(npc)

    return pos + dir:Scaled(speed * delay)
end






--Функции способностей

function Venomancer.Gale(ability, origin, mana)
	if Menu.IsEnabled(Venomancer.optionGale) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) then
    	Ability.CastPosition(ability, origin)
    	return true 
    end	
end

function Venomancer.Ward(ability, origin, mana)
	if Menu.IsEnabled(Venomancer.optionWard) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana)  then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Venomancer.Nova(ability, mana, distance)
	if Menu.IsEnabled(Venomancer.optionNova) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and distance < 830 then
    	Ability.CastNoTarget(ability)
    	return true
    end	
end



--Функции предметов

function Venomancer.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Venomancer.ItemOrigin(item, origin, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastPosition(item, origin) 
    	return true
    end	  
end


function Venomancer.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end

function Venomancer.Blink(ability, origin, distance, mana)
	if ability and Menu.IsEnabled(Venomancer.optionBlink) and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and distance > 700 then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end




--Проверка на слоты
function Venomancer.CheckItem(item)
	for i = 0, 5 do
        local itemCheck = NPC.GetItemByIndex(myHero, i)
        if itemCheck and item == Ability.GetName(itemCheck) then
            return itemCheck
        end
	end
end



function Venomancer.OnEntityDestroy(entity)
    if not myHero then 
        return
    end 

    if entity == myHero then
        Venomancer.Reinit()
        return
    end 
end 

function Venomancer.Reinit()
    myHero, myPlayer, enemy, gale, ward, nova = nil, nil, nil, nil, nil, nil

    particleEnemy = nil
 
end 



return Venomancer
