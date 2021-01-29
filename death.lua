Death = {}

local myHero, myPlayer, enemy, crypt, silence, spirit, exorcism = nil, nil, nil, nil, nil, nil, nil

local targetParticle = 0


local lastMoveOrder = 0
local orderDelay = 0.1

local lastMoveOrder2 = 0
local orderDelay2 = 0.1 


function Death.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end

local rootPath = "Hero Specific"

local mainPath = {rootPath, "Death"}

local settingsPath = {rootPath, "Death", "Settings"}

local skillsPath = {rootPath, "Death", "Skills"}

local itemsPath = {rootPath, "Death", "Items"}

local unitsPath = {rootPath, "Death", "Units settings"}


local optionEnable = Menu.AddOptionBool(mainPath, "Enable", false)
Menu.AddOptionIcon(optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_death_prophet_png.vtex_c")

local optionFullCombo = Menu.AddKeyOption(settingsPath, "Button for full combo", Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(optionFullCombo, "~/MenuIcons/enemy_evil.png")
Menu.AddMenuIcon(settingsPath, "~/MenuIcons/utils_wheel.png")

local optionCursor = Menu.AddOptionBool(settingsPath, "Move to cursor if no enemy in combo", true)
Menu.AddOptionIcon(optionCursor, "~/MenuIcons/cursor.png")

local optionSelector = Menu.AddOptionCombo(settingsPath, "Style", { "Free", "Locked" }, 0)
Menu.AddOptionIcon(optionSelector, "~/MenuIcons/text_panel.png")


local optionIsTargetParticleEnabled = Menu.AddOptionBool(settingsPath, "Draws particle for current target", true)
Menu.AddOptionIcon(optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
local optionRangeToTarget = Menu.AddOptionSlider(settingsPath, "Distance from mouse to enemy for combo", 1, 3000, 500)
Menu.AddOptionIcon(optionRangeToTarget, "~/MenuIcons/edit.png")

local optionOrbWalker = Menu.AddOptionBool(settingsPath, "Orb Walker", true)
Menu.AddOptionIcon(optionOrbWalker, "~/MenuIcons/size.png")


Death.itemsSelection = Menu.AddOptionMultiSelect(itemsPath, "Items Selection:", 
{
{"sheepstick", "panorama/images/items/sheepstick_png.vtex_c", true},
{"bloodthorn", "panorama/images/items/bloodthorn_png.vtex_c", true},
{"orchid", "panorama/images/items/orchid_png.vtex_c", true},
{"shivasguard", "panorama/images/items/shivas_guard_png.vtex_c", true},
{"blackkingbar", "panorama/images/items/black_king_bar_png.vtex_c", false},
{"atos", "panorama/images/items/rod_of_atos_png.vtex_c", true},
{"veil", "panorama/images/items/veil_of_discord_png.vtex_c", true},
{"solar", "panorama/images/items/solar_crest_png.vtex_c", true},
{"medallionofcourage", "panorama/images/items/medallion_of_courage_png.vtex_c", true},
{"blink", "panorama/images/items/blink_png.vtex_c", true},
{"bullwhip", "panorama/images/items/bullwhip_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

local optionBlinkSlider = Menu.AddOptionSlider(itemsPath, "Min distance to enemy", 1, 2000, 1400) 
Menu.AddOptionIcon(optionBlinkSlider, "panorama/images/items/".."blink".."_png.vtex_c")

local optionWhen = Menu.AddOptionCombo(itemsPath, "When to use:", { "Always", "Only in combo" }, 1)
Menu.AddOptionIcon(optionWhen, "panorama/images/items/".."bullwhip".."_png.vtex_c")

local optionHit = Menu.AddOptionBool(itemsPath, "Strike before combo", true)
Menu.AddOptionIcon(optionHit, "panorama/images/items/silver_edge_png.vtex_c")

Death.skillsSelection = Menu.AddOptionMultiSelect(skillsPath, "Skills Selection:", 
{
{"crypt", "panorama/images/spellicons/".."death_prophet_carrion_swarm".."_png.vtex_c", true},
{"silence", "panorama/images/spellicons/".."death_prophet_silence".."_png.vtex_c", true},
{"spirit", "panorama/images/spellicons/".."death_prophet_spirit_siphon".."_png.vtex_c", true},
{"exorcism", "panorama/images/spellicons/".."death_prophet_exorcism".."_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")


function Death.OnUpdate()

	if (not Menu.IsEnabled(optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_death_prophet" then 
		return
	end

	if (not myPlayer) then
		myPlayer = Players.GetLocal()
		return
	end

	local mana = NPC.GetMana(myHero)

	if (not crypt) then
		crypt = NPC.GetAbility(myHero, "death_prophet_carrion_swarm")
		return
	end

	if (not silence) then
		silence = NPC.GetAbility(myHero, "death_prophet_silence")
		return
	end
	
	if (not spirit) then
		spirit = NPC.GetAbility(myHero, "death_prophet_spirit_siphon")
		return
	end

	if (not exorcism) then
		exorcism = NPC.GetAbility(myHero, "death_prophet_exorcism")
		return
	end

	local sheepstick = Death.CheckItem("item_sheepstick")

	local bloodthorn = Death.CheckItem("item_bloodthorn")

	local orchid = Death.CheckItem("item_orchid")

	local shivasguard = Death.CheckItem("item_shivas_guard")

	local blackkingbar = Death.CheckItem("item_black_king_bar")

	local atos = Death.CheckItem("item_rod_of_atos")

	local veil = Death.CheckItem("item_veil_of_discord")

	local solar = Death.CheckItem("item_solar_crest")

	local medallionofcourage = Death.CheckItem("item_medallion_of_courage")

	local blink = Death.CheckItem("item_blink")

	local blinkL = Death.CheckItem("item_shift_blink")

	local blinkS = Death.CheckItem("item_overwhelming_blink")

	local blinkI = Death.CheckItem("item_arcane_blink")

	local bullwhip = NPC.GetItem(myHero, "item_bullwhip")
	if bullwhip and NPC.GetItemByIndex(myHero, 16) ~= bullwhip then
		bullwhip = nil
	end	

	if not enemy then
        enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
    end
    if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(optionRangeToTarget), 0) then
        enemy = nil
    end

    if Menu.GetValue(optionSelector) == 0 then
        if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
            enemy = nil
        end
    end

    if Menu.GetValue(optionSelector) == 1 then
        if not Menu.IsKeyDown(optionFullCombo) then
            if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
                enemy = nil
            end
        end    
    end

    if Menu.GetValue(optionWhen) == 0 and (Menu.IsSelected(Death.itemsSelection, "bullwhip")) and bullwhip and  Item.IsItemEnabled(bullwhip) and (not NPC.IsChannellingAbility(myHero))  and Ability.IsReady(bullwhip) and not enemy and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
    	Ability.CastTarget(bullwhip, myHero)
    end    

    if Menu.IsKeyDown(optionFullCombo) and enemy and (not NPC.IsChannellingAbility(myHero)) and (not NPC.GetModifier(enemy, "modifier_black_king_bar_immune")) then
        local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
        local origin = Entity.GetOrigin(enemy)
        local value = Menu.GetValue(optionBlinkSlider)

        if Menu.IsEnabled(optionHit) then
        	if NPC.GetModifier(myHero, "modifier_item_silver_edge_windwalk") or NPC.GetModifier(myHero, "modifier_item_invisibility_edge_windwalk") then
        	    if Death.SleepReady(orderDelay2, lastMoveOrder2) then
        	        Player.AttackTarget(myPlayer, myHero, enemy)
        	        lastMoveOrder2 = os.clock()
        	    end
        	    return
        	end
        end	

        if (Menu.IsSelected(Death.skillsSelection, "exorcism")) and Death.Exorcism(exorcism, mana, enemy) == true then
            return
        end

        if (Menu.IsSelected(Death.itemsSelection, "blink")) and Death.Blink(blink, origin, distance, value) == true then
            return
        end

        if (Menu.IsSelected(Death.itemsSelection, "blink")) and Death.Blink(blinkI, origin, distance, value) == true then
            return
        end

        if (Menu.IsSelected(Death.itemsSelection, "blink")) and Death.Blink(blinkS, origin, distance, value) == true then
            return
        end

        if (Menu.IsSelected(Death.itemsSelection, "blink")) and Death.Blink(blinkL, origin, distance, value) == true then
            return
        end

        if (Menu.IsSelected(Death.itemsSelection, "sheepstick")) and Death.ItemTarget(sheepstick, enemy, mana) == true then
            return
        end

        if (Menu.IsSelected(Death.itemsSelection, "bloodthorn")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Death.ItemTarget(bloodthorn, enemy, mana) == true then
            return
        end
        
        if (Menu.IsSelected(Death.itemsSelection, "orchid")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and Death.ItemTarget(orchid, enemy, mana) == true then
            return
        end

        if (Menu.IsSelected(Death.skillsSelection, "silence")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Death.Silence(silence, origin, mana) == true then
            return
        end

        if (Menu.IsSelected(Death.itemsSelection, "atos")) and Death.ItemTarget(atos, enemy, mana) == true then
            return
        end

        if  (Menu.IsSelected(Death.itemsSelection, "veil")) and Death.ItemOrigin(veil, origin, mana) == true then
			return
		end

		if (Menu.IsSelected(Death.skillsSelection, "crypt")) and Death.Crypt(crypt, origin, mana) == true then
            return
        end

        if (Menu.IsSelected(Death.skillsSelection, "spirit")) and (not NPC.GetModifier(enemy, "modifier_death_prophet_spirit_siphon_slow")) and Death.Spirit(spirit, mana, enemy) == true then
            return
        end   	

		if (Menu.IsSelected(Death.itemsSelection, "solar")) and Death.ItemTarget(solar, enemy, mana) == true then
            return
        end

        if (Menu.IsSelected(Death.itemsSelection, "medallionofcourage")) and Death.ItemTarget(medallionofcourage, enemy, mana) == true then
            return
        end

		if (Menu.IsSelected(Death.itemsSelection, "shivasguard")) and Death.ItemNoTarget(shivasguard, mana) == true then
			return
		end

		if (Menu.IsSelected(Death.itemsSelection, "bullwhip")) and Death.ItemTarget(bullwhip, enemy, mana) == true then
            return
        end

		if (Menu.IsSelected(Death.itemsSelection, "blackkingbar")) and  Death.ItemNoTarget(blackkingbar, mana) == true then
			return
		end

        if Menu.IsEnabled(optionOrbWalker) then
            Death.OrbWalker(myHero, myPlayer, enemy)
        else    
            if Death.SleepReady(orderDelay, lastMoveOrder) then
                Player.AttackTarget(myPlayer, myHero, enemy)
                lastMoveOrder = os.clock()
            end
        end    
    end

    if Menu.IsEnabled(optionCursor) then
		if Menu.IsKeyDown(optionFullCombo) then
			if (not enemy) and (not NPC.IsChannellingAbility(myHero)) then
				NPC.MoveTo(myHero, Input.GetWorldCursorPos())
			end		
		end	
	end    
end



function Death.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_death_prophet" then 
		return
	end
	local particleEnemy = enemy
	if Menu.IsEnabled(optionIsTargetParticleEnabled) then	
		if not particleEnemy or(not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(optionRangeToTarget), 0) and targetParticle ~= 0) or enemy ~= particleEnemy then
			Particle.Destroy(targetParticle)			
			targetParticle = 0
			particleEnemy = enemy
		else
			if targetParticle == 0 and NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(optionRangeToTarget), 0) then
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






function Death.Crypt(ability, origin, mana)
	if Menu.IsSelected(Death.skillsSelection, "crypt") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Death.Silence(ability, origin, mana)
	if Menu.IsSelected(Death.skillsSelection, "silence") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Death.Spirit(ability, mana, enemy)
	if Menu.IsSelected(Death.skillsSelection, "spirit") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability) then
    	Ability.CastTarget(ability, enemy)
    	return true
    end	
end

function Death.Exorcism(ability, mana)
	if Menu.IsSelected(Death.skillsSelection, "exorcism") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
    	Ability.CastNoTarget(ability, mana)
    	return true
    end	
end




--Функции предметов

function Death.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) and Item.IsItemEnabled(item) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Death.ItemOrigin(item, origin, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) and Item.IsItemEnabled(item) then
    	Ability.CastPosition(item, origin) 
    	return true
    end	  
end


function Death.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) and Item.IsItemEnabled(item) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end

function Death.Blink(item, origin, distance, value)
    if Menu.IsSelected(Death.itemsSelection, "blink") and item and Ability.IsReady(item) and distance < value and distance > 500 and Item.IsItemEnabled(item)  then
        Ability.CastPosition(item, origin)
        return true
    end 
end


--Проверка на слоты
function Death.CheckItem(item)
	for i = 0, 5 do
        local itemCheck = NPC.GetItemByIndex(myHero, i)
        if itemCheck and item == Ability.GetName(itemCheck) then
            return itemCheck
        end
	end
end


function Death.OrbWalker(myHero, myPlayer, enemy)
    local AttackPoint = 0.3 / (0.3 + (NPC.GetIncreasedAttackSpeed(myHero) / 10))
    local AttackBackSwing = 0.7 / (1 + (NPC.GetIncreasedAttackSpeed(myHero))) + 0.1

    if not TimerAttack or not TimerMove then
        TimerAttack = 0
        TimerMove = 0
    end    

    if NPC.IsEntityInRange(myHero, enemy, NPC.GetAttackRange(myHero)) then
        if GameRules.GetGameTime() >= TimerAttack then
            Player.AttackTarget(myPlayer, myHero, enemy)
            TimerAttack = GameRules.GetGameTime() + AttackPoint + AttackBackSwing + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
            TimerMove = GameRules.GetGameTime() + AttackPoint + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
        elseif GameRules.GetGameTime() >= TimerMove then
            if ((Entity.GetOrigin(myHero) - Entity.GetOrigin(enemy)):Length2D()) > 200 then
                NPC.MoveTo(myHero, Entity.GetAbsOrigin(enemy))
            end    
            TimerMove = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
        end
    elseif GameRules.GetGameTime() >= TimerMove then
        NPC.MoveTo(myHero, Entity.GetAbsOrigin(enemy))
        TimerMove = GameRules.GetGameTime() + 0.1 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
    end
end        






function Death.OnEntityDestroy(entity)
    if not myHero then 
        return
    end 

    if entity == myHero then
        Death.Reinit()
        return
    end 
end 

function Death.Reinit()
    myHero, myPlayer, enemy, crypt, silence, spirit, exorcism = nil, nil, nil, nil, nil, nil, nil

    particleEnemy = nil 
end
return Death
