Disruptor = {}

local myHero, myPlayer, enemy, thunder, glimpse, kinetic, storm = nil, nil, nil, nil, nil, nil, nil

local x1, y1, x2, y2 = nil, nil, nil, nil

local blinked = {}

local glimpsed = {
	[0] = nil,
	[1] = nil,
	[2]	= nil
}

local targetParticle = 0

local lastMoveOrder = 0
local orderDelay = 0.1

local lastMoveOrder2 = 0
local orderDelay2 = 0.1 

local lastMoveOrder3 = 0
local orderDelay3 = 0.1 

function Disruptor.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end

local elements = {
	[1] = nil,
	[2] = nil,
	[3] = nil,
	[4] = nil,
	[5] = nil,
	[6] = nil,
	[7] = nil,
	[8] = nil,
	[9] = nil,
	[10] = nil,
	[11] = nil,
	[12] = nil,
	[13] = nil,
	[14] = nil,
	[15] = nil,
	[16] = nil,
	[17] = nil,
	[18] = nil,
	[19] = nil,
	[20] = nil,
	[21] = nil,
	[22] = nil,
	[23] = nil,
	[24] = nil,
	[25] = nil,
	[26] = nil,
	[27] = nil,
	[28] = nil,
	[29] = nil,
	[30] = nil,
	[31] = nil,
	[32] = nil,
	[33] = nil,
	[34] = nil,
	[35] = nil,
	[36] = nil,
	[37] = nil,
	[38] = nil,
	[39] = nil,
	[40] = nil
}

local rootPath = "Hero Specific"

local mainPath = {rootPath, "Disruptor"}

local settingsPath = {rootPath, "Disruptor", "Settings"}

local skillsPath = {rootPath, "Disruptor", "Skills"}

local itemsPath = {rootPath, "Disruptor", "Items"}

local glimpsePath = {rootPath, "Disruptor", "Glimpse"}

local originPath = {rootPath, "Disruptor", "Glimpse", "Origin"}

local thunderPath = {rootPath, "Disruptor", "Thunder"}

local linkenPath = {rootPath, "Disruptor", "Linken Breaker"}


local optionEnable = Menu.AddOptionBool(mainPath, "Enable", false)
Menu.AddOptionIcon(optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "panorama/images/heroes/icons/npc_dota_hero_disruptor_png.vtex_c")

local optionFullCombo = Menu.AddKeyOption(settingsPath, "Button for full combo", Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(optionFullCombo, "~/MenuIcons/enemy_evil.png")
Menu.AddMenuIcon(settingsPath, "~/MenuIcons/utils_wheel.png")

local optionCursor = Menu.AddOptionBool(settingsPath, "Move to cursor if no enemy in combo", true)
Menu.AddOptionIcon(optionCursor, "~/MenuIcons/cursor.png")

local optionSelector = Menu.AddOptionCombo(settingsPath, "Style", { "Free", "Locked" }, 0)
Menu.AddOptionIcon(optionSelector, "~/MenuIcons/text_panel.png")


local optionIsTargetParticleEnabled = Menu.AddOptionBool(settingsPath, "Draws particle for current target", true)
Menu.AddOptionIcon(optionIsTargetParticleEnabled, "~/MenuIcons/target.png")
local optionRangeToTarget = Menu.AddOptionSlider(settingsPath, "Distance from mouse to enemy for combo", 1, 3000, 800)
Menu.AddOptionIcon(optionRangeToTarget, "~/MenuIcons/edit.png")

Disruptor.itemsSelection = Menu.AddOptionMultiSelect(itemsPath, "Items Selection:", 
{
{"sheepstick", "panorama/images/items/sheepstick_png.vtex_c", true},
{"bloodthorn", "panorama/images/items/bloodthorn_png.vtex_c", true},
{"orchid", "panorama/images/items/orchid_png.vtex_c", true},
{"shivasguard", "panorama/images/items/shivas_guard_png.vtex_c", true},
{"blackkingbar", "panorama/images/items/black_king_bar_png.vtex_c", false},
{"atos", "panorama/images/items/rod_of_atos_png.vtex_c", true},
{"veil", "panorama/images/items/veil_of_discord_png.vtex_c", true},
{"bullwhip", "panorama/images/items/bullwhip_png.vtex_c", true},
{"blink", "panorama/images/items/blink_png.vtex_c", true},
{"cyclone", "panorama/images/items/cyclone_png.vtex_c", true},
{"urn", "panorama/images/items/urn_of_shadows_png.vtex_c", true},
{"spirit", "panorama/images/items/spirit_vessel_png.vtex_c", true},
{"glimmer", "panorama/images/items/glimmer_cape_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(itemsPath, "~/MenuIcons/utils_wheel.png")

local optionWhen = Menu.AddOptionCombo(itemsPath, "When to use:", { "Always", "Only in combo" }, 1)
Menu.AddOptionIcon(optionWhen, "panorama/images/items/".."bullwhip".."_png.vtex_c")

local optionBlinkSlider = Menu.AddOptionSlider(itemsPath, "Min distance to enemy", 1, 2000, 1400) 
Menu.AddOptionIcon(optionBlinkSlider, "panorama/images/items/".."blink".."_png.vtex_c")


Disruptor.skillsSelection = Menu.AddOptionMultiSelect(skillsPath, "Skills Selection:", 
{
{"thunder", "panorama/images/spellicons/".."disruptor_thunder_strike".."_png.vtex_c", true},
{"glimpse", "panorama/images/spellicons/".."disruptor_glimpse".."_png.vtex_c", true},
{"kinetic", "panorama/images/spellicons/".."disruptor_kinetic_field".."_png.vtex_c", true},
{"storm", "panorama/images/spellicons/".."disruptor_static_storm".."_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(skillsPath, "~/MenuIcons/utils_wheel.png")


local optionGlimpseEnable = Menu.AddOptionBool(originPath, "Draw where the enemy will return", false)
Menu.AddOptionIcon(optionGlimpseEnable, "~/MenuIcons/return.png")

local optionIcon = Menu.AddOptionBool(originPath, "Draw icon", false)
Menu.AddOptionIcon(optionIcon, "~/MenuIcons/anon.png")

local optionLine = Menu.AddOptionBool(originPath, "Draw line", false)
Menu.AddOptionIcon(optionLine, "~/MenuIcons/horizontal.png")
local color2 = Menu.AddOptionColorPicker(originPath, "Line color", 255, 255, 255, 255)

local optionCircle = Menu.AddOptionBool(originPath, "Draw circle", false)
Menu.AddOptionIcon(optionCircle, "~/MenuIcons/radius.png")

local slider = Menu.AddOptionSlider(originPath, "Radius range", 1, 100, 30)
Menu.AddOptionIcon(slider, "~/MenuIcons/edit.png")
local color = Menu.AddOptionColorPicker(originPath, "Radius color", 255, 255, 255, 255)

local optionAutoInitiation = Menu.AddOptionBool(glimpsePath, "Anti-Initiation", false)
Menu.AddOptionIcon(optionAutoInitiation, "~/MenuIcons/block_wall.png")
local optionAutoInitiationUse = Menu.AddOptionBool(glimpsePath, "Use in reflection spell", false)
Menu.AddOptionIcon(optionAutoInitiationUse, "~/MenuIcons/question.png")

local optionAutoDisable = Menu.AddOptionBool(glimpsePath, "Interrupt enemies casting spells", false)
Menu.AddOptionIcon(optionAutoDisable, "panorama/images/items/tpscroll_png.vtex_c")
Menu.AddMenuIcon(glimpsePath, "panorama/images/spellicons/".."disruptor_glimpse".."_png.vtex_c")


local optionAutoThunder = Menu.AddOptionBool(thunderPath, "Auto-use", false)
Menu.AddOptionIcon(optionAutoThunder, "panorama/images/items/".."aghanims_shard".."_png.vtex_c")

local optionWhenThunder = Menu.AddOptionCombo(thunderPath, "When to use:", { "Always", "When the enemy is near", "When not the enemy is near" }, 0)
Menu.AddOptionIcon(optionWhenThunder, "~/MenuIcons/ellipsis.png")

local optionTargetThunder = Menu.AddOptionCombo(thunderPath, "For whom to use:", { "Only for yourself", "Only for the allies", "On yourself and on your allies" }, 0)
Menu.AddOptionIcon(optionWhenThunder, "~/MenuIcons/ellipsis.png")

local optionManaSlider = Menu.AddOptionSlider(thunderPath, "How much percent to leave mana?", 1, 100, 30) 
Menu.AddOptionIcon(optionManaSlider, "~/MenuIcons/edit.png")
Menu.AddMenuIcon(thunderPath, "panorama/images/spellicons/".."disruptor_thunder_strike".."_png.vtex_c")


local linkenSelection = Menu.AddOptionMultiSelect(linkenPath, "Linken Breaker Selection:", 
{
{"thunder", "panorama/images/spellicons/".."disruptor_thunder_strike".."_png.vtex_c", true},
{"glimpse", "panorama/images/spellicons/".."disruptor_glimpse".."_png.vtex_c", true},	
{"hurricanepike", "panorama/images/items/hurricane_pike_png.vtex_c", false},
{"atos", "panorama/images/items/rod_of_atos_png.vtex_c", true},
}, false)
Menu.AddMenuIcon(linkenPath, "panorama/images/items/".."sphere".."_png.vtex_c")


function Disruptor.OnUpdate()

	if (not Menu.IsEnabled(optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_disruptor" then 
		return
	end

	if (not myPlayer) then
		myPlayer = Players.GetLocal()
		return
	end

	local mana = NPC.GetMana(myHero)

	if (not thunder) then
		thunder = NPC.GetAbility(myHero, "disruptor_thunder_strike")
		return
	end

	if (not glimpse) then
		glimpse = NPC.GetAbility(myHero, "disruptor_glimpse")
		return
	end
	
	if (not kinetic) then
		kinetic = NPC.GetAbility(myHero, "disruptor_kinetic_field")
		return
	end

	if (not storm) then
		storm = NPC.GetAbility(myHero, "disruptor_static_storm")
		return
	end

	local sheepstick = Disruptor.CheckItem("item_sheepstick")

	local bloodthorn = Disruptor.CheckItem("item_bloodthorn")

	local orchid = Disruptor.CheckItem("item_orchid")

	local shivasguard = Disruptor.CheckItem("item_shivas_guard")

	local blackkingbar = Disruptor.CheckItem("item_black_king_bar")

	local atos = Disruptor.CheckItem("item_rod_of_atos")

	local veil = Disruptor.CheckItem("item_veil_of_discord")

	local blink = Disruptor.CheckItem("item_blink")

	local blinkL = Disruptor.CheckItem("item_shift_blink")

	local blinkS = Disruptor.CheckItem("item_overwhelming_blink")

	local blinkI = Disruptor.CheckItem("item_arcane_blink")

	local bullwhip = NPC.GetItem(myHero, "item_bullwhip")
	if bullwhip and NPC.GetItemByIndex(myHero, 16) ~= bullwhip then
		bullwhip = nil
	end

	local hurricanepike = Disruptor.CheckItem("item_hurricane_pike")

	local cyclone = Disruptor.CheckItem("item_cyclone")

	local urn = Disruptor.CheckItem("item_urn_of_shadows")

	local spirit = Disruptor.CheckItem("item_spirit_vessel")

	local glimmer = Disruptor.CheckItem("item_glimmer_cape")

	local itemsBreakers = {
	["thunder"] = thunder,	
    ["glimpse"] = glimpse,
    ["hurricanepike"] = hurricanepike,
    ["atos"] = atos
    }

	if not enemy then
        enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
    end
    if enemy and not NPC.IsPositionInRange(enemy, Input.GetWorldCursorPos(), Menu.GetValue(optionRangeToTarget), 0) then
        enemy = nil
        if Menu.IsEnabled(optionGlimpseEnable) then
        	for i = 1, 40 do
        		elements[i] = nil
        	end
        end	
    end

    if Menu.GetValue(optionSelector) == 0 then
        if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
            enemy = nil
            if Menu.IsEnabled(optionGlimpseEnable) then
            	for i = 1, 40 do
            		elements[i] = nil
            	end
            end	
        end
    end

    if Menu.GetValue(optionSelector) == 1 then
        if not Menu.IsKeyDown(optionFullCombo) then
            if enemy and enemy ~= Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY) then
                enemy = nil
                if Menu.IsEnabled(optionGlimpseEnable) then
                	for i = 1, 40 do
                		elements[i] = nil
                	end
                end	
            end
        end    
    end

    if Menu.GetValue(optionWhen) == 0 and (Menu.IsSelected(Disruptor.itemsSelection, "bullwhip")) and bullwhip and  Item.IsItemEnabled(bullwhip) and (not NPC.IsChannellingAbility(myHero))  and Ability.IsReady(bullwhip) and not enemy and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
    	Ability.CastTarget(bullwhip, myHero)
    end


--Glimpse
    if Menu.IsEnabled(optionGlimpseEnable) and glimpse and Ability.GetLevel(glimpse) >= 1 then
    	if enemy then
    		if Disruptor.SleepReady(orderDelay2, lastMoveOrder2) then
    			for i = 1, 39 do
    				elements[i] = elements[i+1]
    			end	
    			elements[40] = Entity.GetOrigin(enemy)
    			lastMoveOrder2 = os.clock()
    		end
    	end
    end

    if Menu.IsEnabled(optionAutoInitiation) then
    	if  not Menu.IsEnabled(optionAutoInitiationUse) then
    		if blinked[#blinked] and blinked[#blinked].unit and  blinked[#blinked].time and ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(blinked[#blinked].unit))):Length2D()) < 700 and (GameRules.GetGameTime() - blinked[#blinked].time) < 0.1 and (not Entity.IsSameTeam(myHero, blinked[#blinked].unit)) and not NPC.GetModifier(blinked[#blinked].unit, "modifier_item_lotus_orb_active") and not NPC.GetModifier(blinked[#blinked].unit, "modifier_antimage_counterspell") then
    			local mirror = NPC.GetItem(blinked[#blinked].unit, "item_mirror_shield")
				if Ability.IsReady(glimpse) and Ability.IsCastable(glimpse, mana) and not mirror then
    				Ability.CastTarget(glimpse, blinked[#blinked].unit)
    			end
    		end
    	else
    		if blinked[#blinked] and blinked[#blinked].unit and  blinked[#blinked].time and ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(blinked[#blinked].unit))):Length2D()) < 700 and (GameRules.GetGameTime() - blinked[#blinked].time) < 0.1 and (not Entity.IsSameTeam(myHero, blinked[#blinked].unit)) then
				if Ability.IsReady(glimpse) and Ability.IsCastable(glimpse, mana) then
    				Ability.CastTarget(glimpse, blinked[#blinked].unit)
    			end
    		end			
		end
	end

	if  Menu.IsEnabled(optionAutoDisable) then
		for index, ability in pairs(Abilities.GetAll()) do 
			if Ability.IsChannelling(ability) then
				badability = Ability.GetName(ability)
				badguy = Ability.GetOwner(ability)
				if (not Entity.IsSameTeam(badguy, myHero)) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(badguy)):Length2D()) < Ability.GetCastRange(glimpse) and badability ~= "item_trusty_shovel" and badability ~= "item_meteor_hammer" and badability ~= "windrunner_powershot" and badability ~= "enraged_wildkin_tornado" and badability ~= "riki_tricks_of_the_trade" and badability ~= "tinker_rearm" and badability ~= "puck_phase_shift" and badability ~= "ability_capture" and badability ~= "monkey_king_primal_spring" and badability ~= "oracle_fortunes_end" and badability ~= "keeper_of_the_light_illuminate" and badability ~= "elder_titan_echo_stomp" then
					if Disruptor.Glimpse(glimpse, mana, badguy) == true then
						return
					end
				end		
			end	
		end
	end				
-------------------------------------------------------------------------------------------
--Thunder
	if  Menu.IsEnabled(optionAutoThunder) then
		if NPC.GetModifier(myHero, "modifier_item_aghanims_shard") then
			local whenthunder = Menu.GetValue(optionWhenThunder)
			local whothunder = Menu.GetValue(optionTargetThunder)
			if whenthunder == 0 then
				if whothunder == 0 then
					if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and not NPC.GetModifier(myHero, "modifier_disruptor_thunder_strike") and (not NPC.IsChannellingAbility(myHero)) and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) and Disruptor.Thunder(thunder, mana, myHero) == true then
					    return
					end
				elseif whothunder == 1 then
					for index, hero in pairs(Heroes.GetAll()) do 
						goodguy = hero
						if (Entity.IsSameTeam(goodguy, myHero)) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(goodguy)):Length2D()) < Ability.GetCastRange(thunder) and not NPC.GetModifier(goodguy, "modifier_disruptor_thunder_strike") and goodguy ~= myHero then
							if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and (not NPC.IsChannellingAbility(myHero)) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
								if Disruptor.Thunder(thunder, mana, goodguy) == true then
									return
								end
							end	
						end		
					end
				elseif whothunder == 2 then
					if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and not NPC.GetModifier(myHero, "modifier_disruptor_thunder_strike") and (not NPC.IsChannellingAbility(myHero)) and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) and Disruptor.Thunder(thunder, mana, myHero) == true then
					    return
					end
					for index, hero in pairs(Heroes.GetAll()) do 
						goodguy = hero
						if (Entity.IsSameTeam(goodguy, myHero)) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(goodguy)):Length2D()) < Ability.GetCastRange(thunder) and not NPC.GetModifier(goodguy, "modifier_disruptor_thunder_strike") and goodguy ~= myHero then
							if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and (not NPC.IsChannellingAbility(myHero)) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
								if Disruptor.Thunder(thunder, mana, goodguy) == true then
									return
								end
							end	
						end		
					end						
				end
			elseif whenthunder == 1 then
				if #Entity.GetHeroesInRadius(myHero, 1800, Enum.TeamType.TEAM_ENEMY) ~= 0 then
					if whothunder == 0 then
						if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and not NPC.GetModifier(myHero, "modifier_disruptor_thunder_strike") and (not NPC.IsChannellingAbility(myHero)) and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) and Disruptor.Thunder(thunder, mana, myHero) == true then
						    return
						end
					elseif whothunder == 1 then
						for index, hero in pairs(Heroes.GetAll()) do 
							goodguy = hero
							if (Entity.IsSameTeam(goodguy, myHero)) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(goodguy)):Length2D()) < Ability.GetCastRange(thunder) and not NPC.GetModifier(goodguy, "modifier_disruptor_thunder_strike") and goodguy ~= myHero then
								if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and (not NPC.IsChannellingAbility(myHero)) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
									if Disruptor.Thunder(thunder, mana, goodguy) == true then
										return
									end
								end	
							end		
						end
					elseif whothunder == 2 then
						if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and not NPC.GetModifier(myHero, "modifier_disruptor_thunder_strike") and (not NPC.IsChannellingAbility(myHero)) and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) and Disruptor.Thunder(thunder, mana, myHero) == true then
						    return
						end
						for index, hero in pairs(Heroes.GetAll()) do 
							goodguy = hero
							if (Entity.IsSameTeam(goodguy, myHero)) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(goodguy)):Length2D()) < Ability.GetCastRange(thunder) and not NPC.GetModifier(goodguy, "modifier_disruptor_thunder_strike") and goodguy ~= myHero then
								if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and (not NPC.IsChannellingAbility(myHero)) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
									if Disruptor.Thunder(thunder, mana, goodguy) == true then
										return
									end
								end	
							end		
						end						
					end
				end
			elseif whenthunder == 2 then
				if #Entity.GetHeroesInRadius(myHero, 1800, Enum.TeamType.TEAM_ENEMY) == 0 then
					if whothunder == 0 then
						if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and not NPC.GetModifier(myHero, "modifier_disruptor_thunder_strike") and (not NPC.IsChannellingAbility(myHero)) and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) and Disruptor.Thunder(thunder, mana, myHero) == true then
						    return
						end
					elseif whothunder == 1 then
						for index, hero in pairs(Heroes.GetAll()) do 
							goodguy = hero
							if (Entity.IsSameTeam(goodguy, myHero)) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(goodguy)):Length2D()) < Ability.GetCastRange(thunder) and not NPC.GetModifier(goodguy, "modifier_disruptor_thunder_strike") and goodguy ~= myHero then
								if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and (not NPC.IsChannellingAbility(myHero)) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
									if Disruptor.Thunder(thunder, mana, goodguy) == true then
										return
									end
								end	
							end		
						end
					elseif whothunder == 2 then
						if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and not NPC.GetModifier(myHero, "modifier_disruptor_thunder_strike") and (not NPC.IsChannellingAbility(myHero)) and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) and Disruptor.Thunder(thunder, mana, myHero) == true then
						    return
						end
						for index, hero in pairs(Heroes.GetAll()) do 
							goodguy = hero
							if (Entity.IsSameTeam(goodguy, myHero)) and ((Entity.GetOrigin(myHero) - Entity.GetOrigin(goodguy)):Length2D()) < Ability.GetCastRange(thunder) and not NPC.GetModifier(goodguy, "modifier_disruptor_thunder_strike") and goodguy ~= myHero then
								if (100/(NPC.GetMaxMana(myHero)/mana)) > Menu.GetValue(optionManaSlider) and (not NPC.IsChannellingAbility(myHero)) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
									if Disruptor.Thunder(thunder, mana, goodguy) == true then
										return
									end
								end	
							end		
						end						
					end
				end		
			end					
		end
	end


	if Menu.IsKeyDown(optionFullCombo) and enemy and (not NPC.IsChannellingAbility(myHero)) and (not NPC.GetModifier(enemy, "modifier_black_king_bar_immune")) then
        local distance = ((Entity.GetOrigin(myHero) - (Entity.GetOrigin(enemy))):Length2D())
        local origin = Entity.GetOrigin(enemy)
        local value = Menu.GetValue(optionBlinkSlider)

        if (Menu.IsSelected(Disruptor.itemsSelection, "blink")) and Disruptor.Blink(blink, origin, distance, value) == true then
            return
        end

        if (Menu.IsSelected(Disruptor.itemsSelection, "blink")) and Disruptor.Blink(blinkI, origin, distance, value) == true then
            return
        end

        if (Menu.IsSelected(Disruptor.itemsSelection, "blink")) and Disruptor.Blink(blinkS, origin, distance, value) == true then
            return
        end

        if (Menu.IsSelected(Disruptor.itemsSelection, "blink")) and Disruptor.Blink(blinkL, origin, distance, value) == true then
            return
        end

        if NPC.IsLinkensProtected(enemy) then
            local TableLinken = Menu.GetItems(linkenSelection)
            for i = 1, #TableLinken do
                local item = itemsBreakers[TableLinken[i]]
                if item then
                	if (Menu.IsSelected(linkenSelection, TableLinken[i])) then
                		if Disruptor.SleepReady(orderDelay3, lastMoveOrder3) then
                	    	if Disruptor.Breaker(item, enemy, mana) == true then
                	    	    return
                	    	end 
                	    	lastMoveOrder3 = os.clock()
                	    end	    
                	end
                end	
            end  
        end

        if NPC.IsLinkensProtected(enemy) then 
        	return
        end

        if (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and (not NPC.GetModifier(enemy, "modifier_item_sheepstick")) and (not NPC.GetModifier(enemy, "modifier_disruptor_static_storm"))  and Disruptor.ItemTarget(cyclone, enemy, mana) == true then
        	return
        end

        local modifierCyclone = NPC.GetModifier(enemy, 'modifier_eul_cyclone')	
        if modifierCyclone then
        	local timerCyclone = Modifier.GetDieTime(modifierCyclone) - GameRules.GetGameTime()
        	if timerCyclone < (1.2 - NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)) then
        		if (Menu.IsSelected(Disruptor.skillsSelection, "kinetic")) and Disruptor.Kinetic(kinetic, origin, mana) == true then
        			return
        		end

        		if (Menu.IsSelected(Disruptor.skillsSelection, "storm")) and Disruptor.Storm(storm, origin, mana) == true then
        			return
        		end	
        	end
        	return 
        end
        log(accept)
        if Ability.IsReady(kinetic) and Ability.IsCastable(kinetic, mana) and not accept and (Menu.IsSelected(Disruptor.skillsSelection, "glimpse")) and Disruptor.Glimpse(glimpse, mana, enemy) == true then
            return
        end	

        if glimpsed[1] and glimpsed[2] and (GameRules.GetGameTime() - glimpsed[2]) < 3 then
        	if (Menu.IsSelected(Disruptor.skillsSelection, "kinetic")) and Disruptor.Kinetic(kinetic, glimpsed[1], mana) == true then
        		return
        	end

        	if (Menu.IsSelected(Disruptor.skillsSelection, "storm")) and Disruptor.Storm(storm, glimpsed[1], mana) == true then
        		return
        	end	
        end

        if  (Menu.IsSelected(Disruptor.itemsSelection, "veil")) and Disruptor.ItemOrigin(veil, origin, mana) == true then
			return
		end

        if glimpsed[1] then
        	if (GameRules.GetGameTime() - glimpsed[2]) > 3 then
        		if (Menu.IsSelected(Disruptor.itemsSelection, "atos")) and Disruptor.ItemTarget(atos, enemy, mana) == true then
            		return
            	end
            end
        else
        	if (Menu.IsSelected(Disruptor.itemsSelection, "atos")) and Disruptor.ItemTarget(atos, enemy, mana) == true then
        	    return
        	end   		
        end


        local position =  Disruptor.GetPredictedPosition(enemy, 0.3)
        if (Menu.IsSelected(Disruptor.skillsSelection, "kinetic")) and position and Disruptor.Kinetic(kinetic, position, mana) == true then
        	return
        end	


        if (Menu.IsSelected(Disruptor.skillsSelection, "storm")) and Disruptor.Storm(storm, position, mana) == true then
        	return
        end		

        if (Menu.IsSelected(Disruptor.itemsSelection, "sheepstick")) and Disruptor.ItemTarget(sheepstick, enemy, mana) == true then
            return
        end

        if (Menu.IsSelected(Disruptor.itemsSelection, "bloodthorn")) and (not NPC.GetModifier(enemy, "modifier_bloodthorn_debuff")) and Disruptor.ItemTarget(bloodthorn, enemy, mana) == true then
            return
        end
        
        if (Menu.IsSelected(Disruptor.itemsSelection, "orchid")) and (not NPC.GetModifier(enemy, "modifier_orchid_malevolence_debuff")) and Disruptor.ItemTarget(orchid, enemy, mana) == true then
            return
        end

		if (Menu.IsSelected(Disruptor.skillsSelection, "thunder")) and Disruptor.Thunder(thunder, mana, enemy) == true then
            return
        end

		if (Menu.IsSelected(Disruptor.itemsSelection, "shivasguard")) and Disruptor.ItemNoTarget(shivasguard, mana) == true then
			return
		end

		if (Menu.IsSelected(Disruptor.itemsSelection, "urn")) and Item.GetCurrentCharges(urn) > 0 and not NPC.GetModifier(enemy, "modifier_item_spirit_vessel_damage") and not NPC.GetModifier(enemy, "modifier_item_urn_damage") and Disruptor.ItemTargetUrn(urn, enemy, mana) == true then
		    return
		end

		if (Menu.IsSelected(Disruptor.itemsSelection, "spirit")) and Item.GetCurrentCharges(spirit) > 0 and not NPC.GetModifier(enemy, "modifier_item_spirit_vessel_damage") and not NPC.GetModifier(enemy, "modifier_item_urn_damage") and Disruptor.ItemTargetUrn(spirit, enemy, mana) == true then
		    return
		end  

		if (Menu.IsSelected(Disruptor.itemsSelection, "bullwhip")) and Disruptor.ItemTarget(bullwhip, enemy, mana) == true then
            return
        end

        if (Menu.IsSelected(Disruptor.itemsSelection, "glimmer")) and Disruptor.ItemTargetUrn(glimmer, myHero, mana) == true then
            return
        end

		if (Menu.IsSelected(Disruptor.itemsSelection, "blackkingbar")) and  Disruptor.ItemNoTarget(blackkingbar, mana) == true then
			return
		end

		if Disruptor.SleepReady(orderDelay, lastMoveOrder) then
			Player.AttackTarget(myPlayer, myHero, enemy)
			lastMoveOrder = os.clock()
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

function Disruptor.OnMenuOptionChange(option, oldValue, newValue)
    if option == slider then
        if glimpseParticle then
            Particle.Destroy(glimpseParticle)
            glimpseParticle = nil

            local tempColor = Menu.GetValue(color)
            if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                tempColor.r = 50
                tempColor.g = 50
                tempColor.b = 50
            end
            glimpseParticle = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
        	Particle.SetControlPoint(glimpseParticle, 0, glimpseOrigin)
        	Particle.SetControlPoint(glimpseParticle, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
            Particle.SetControlPoint(glimpseParticle, 2, Vector(Menu.GetValue(slider)*1.0923, 255, 255))
            Particle.SetControlPoint(glimpseParticle, 3, Vector(255 - tempColor.a, 0, 0))
        end
    end
end        

function Disruptor.OnDraw()
	if (not myHero) then
		return
	end	

	if myHero and NPC.GetUnitName(myHero) ~= "npc_dota_hero_disruptor" then 
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

	if Menu.IsEnabled(optionGlimpseEnable) and glimpse and Ability.GetLevel(glimpse) >= 1 then
		local glimpseOrigin = elements[1]
		local tempColor = Menu.GetValue(color)
		local tempColor2 = Menu.GetValue(color2)
		if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
		    tempColor.r = 50
		    tempColor.g = 50
		    tempColor.b = 50
		end
		if not glimpseOrigin or elements[1] ~= glimpseOrigin or not enemy or not Ability.IsReady(glimpse) then
			Particle.Destroy(glimpseParticle)			
			glimpseParticle = 0
			glimpseOrigin = elements[1]
			image = nil
		else
			if glimpseParticle == 0 and enemy then
				glimpseParticle = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")				
			end
			if glimpseParticle ~= 0 then
				if Menu.IsEnabled(optionCircle) then
					Particle.SetControlPoint(glimpseParticle, 0, glimpseOrigin)
    	        	Particle.SetControlPoint(glimpseParticle, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
    	        	Particle.SetControlPoint(glimpseParticle, 2, Vector(Menu.GetValue(slider)*1.0923, 255, 0))
    	        	Particle.SetControlPoint(glimpseParticle, 3, Vector(255 - tempColor.a, 0, 0))
    	        end
    	        if not Ability.IsReady(glimpse) or not Menu.IsEnabled(optionCircle) then
    	        	Particle.SetControlPoint(glimpseParticle, 0, nil)	
    	        end	
    	        if Menu.IsEnabled(optionLine) then
    	        	x1, y1 = Renderer.WorldToScreen(glimpseOrigin)
    	        	x2, y2 = Renderer.WorldToScreen(Entity.GetOrigin(enemy))
    	        	Renderer.SetDrawColor(tempColor2.r, tempColor2.g, tempColor2.b)
    	        	Renderer.DrawLine(x1, y1, x2, y2)
    	        end
    	        if Menu.IsEnabled(optionIcon) then
    	        	x1, y1 = Renderer.WorldToScreen(glimpseOrigin)
    	        	x2, y2 = Renderer.WorldToScreen(Entity.GetOrigin(enemy))	
    	        	local image = Renderer.LoadImage("panorama/images/heroes/icons/"..NPC.GetUnitName(enemy).."_png.vtex_c")
    	        	Renderer.SetDrawColor(255, 255, 255)
    	        	Renderer.DrawImage(image, x1, y1)
    	        end	
			end
		end
	end	
end


function Disruptor.Thunder(ability, mana, enemy)
	if Menu.IsSelected(Disruptor.skillsSelection, "thunder") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability) then
    	Ability.CastTarget(ability, enemy)
    	return true
    end	
end

function Disruptor.Glimpse(ability, mana, enemy)
	if Menu.IsSelected(Disruptor.skillsSelection, "glimpse") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability) then
    	Ability.CastTarget(ability, enemy)
    	accept = 1
    	return true
    end	
end

function Disruptor.Kinetic(ability, origin, mana)
	if Menu.IsSelected(Disruptor.skillsSelection, "kinetic") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end

function Disruptor.Storm(ability, origin, mana)
	if Menu.IsSelected(Disruptor.skillsSelection, "storm") and Ability.IsReady(ability) and Ability.IsCastable(ability, mana) and not Ability.IsInAbilityPhase(ability)  then
    	Ability.CastPosition(ability, origin)
    	return true
    end	
end



function Disruptor.ItemTarget(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) and Item.IsItemEnabled(item) and (not NPC.GetModifier(enemy, "modifier_item_lotus_orb_active")) and (not NPC.GetModifier(enemy, "modifier_antimage_counterspell")) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Disruptor.ItemTargetUrn(item, enemy, mana)
	if item  and Ability.IsReady(item) and Ability.IsCastable(item, mana) and Item.IsItemEnabled(item) then
    	Ability.CastTarget(item, enemy)
    	return true	 
    end	  
end

function Disruptor.ItemOrigin(item, origin, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) and Item.IsItemEnabled(item) then
    	Ability.CastPosition(item, origin) 
    	return true
    end	  
end


function Disruptor.ItemNoTarget(item, mana)
	if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) and Item.IsItemEnabled(item) then
    	Ability.CastNoTarget(item)
    	return true	 
    end	  
end

function Disruptor.Blink(item, origin, distance, value)
    if Menu.IsSelected(Disruptor.itemsSelection, "blink") and item and Ability.IsReady(item) and distance < value and distance > 500 and Item.IsItemEnabled(item)  then
        Ability.CastPosition(item, origin)
        return true
    end 
end

function Disruptor.Breaker(item, enemy, mana)
    if item and Ability.IsReady(item) and Ability.IsCastable(item, mana) then
        Ability.CastTarget(item, enemy)  
        return true
    end   
end


function Disruptor.CheckItem(item)
	for i = 0, 5 do
        local itemCheck = NPC.GetItemByIndex(myHero, i)
        if itemCheck and item == Ability.GetName(itemCheck) then
            return itemCheck
        end
	end
end


function Disruptor.GetPredictedPosition(npc, delay)
    local pos = Entity.GetAbsOrigin(npc)
    if not NPC.IsRunning(npc) or not delay then return pos end

    local dir = Entity.GetRotation(npc):GetForward():Normalized()
    local speed = NPC.GetMoveSpeed(npc)

    return pos + dir:Scaled(speed * delay)
end

Disruptor.BlinkParticle = {
    ["blink_dagger_end"] = "entity", 
    ["phantom_assassin_phantom_strike_end"] = "entity",
    ["antimage_blink_end"] = "entity",  
    ["queen_blink_end"] = "entityForModifiers",
    ["faceless_void_time_walk_preimage"] = "entityForModifiers",
}

 
function Disruptor.OnParticleCreate(p1)
    if p1.name  and Disruptor.BlinkParticle[p1.name] and p1[Disruptor.BlinkParticle[p1.name]] then
        local temp = {}
        temp.unit = p1[Disruptor.BlinkParticle[p1.name]]
        temp.time = GameRules.GetGameTime()
 

        if p1.name == "faceless_void_time_walk_preimage" then
            temp.time = temp.time + 0.2
        end
        blinked[#blinked+1] = temp
    end

    if p1.name and p1.name == "disruptor_glimpse_travel" then
        glimpsed[0] = p1.index
        glimpsed[2] = GameRules.GetGameTime()
    end
end

function  Disruptor.OnParticleUpdate(p2)
	if p2.index  and glimpsed[0] and p2.index == glimpsed[0] then
		if p2.controlPoint == 1 then
        	glimpsed[1] = p2.position
        end	
    end
end

function Disruptor.OnEntityDestroy(entity)
    if not myHero then 
        return
    end 

    if entity == myHero then
        Disruptor.Reinit()
        return
    end 
end 

function Disruptor.Reinit()
    myHero, myPlayer, enemy, thunder, glimpse, kinetic, storm = nil, nil, nil, nil, nil, nil, nil

    particleEnemy = nil 
end

return Disruptor