local Diretide = {}

local myHero, myPlayer, mySide = nil, nil, nil, nil, nil, nil, nil

local protobuf = require('protobuf')
local JSON = require('assets.JSON')


local fountainTable = {
	[2] = Vector(-4998.208984375, 237.77935791016, 384.0),
	[3] = Vector(5023.5107421875, 405.19989013672, 384.0)
}

local lastBuyOrder = 0
local lastMoveOrder = 0
local lastCentered = 0
local orderDelay = 1.2

function Diretide.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end

local lastMoveOrder2 = 0
local orderDelay2 = 1.4

local lastLearnOrder = 0;
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
        [RU] = "Бот",
        [EN] = "Bot",
		[CN] = "Bot",
    },
    ["optionFind"] = {
        [RU] = "Поиск игры",
        [EN] = "Find Match",
		[CN] = "Find Match",
    },
    ["optionPick"] = {
        [RU] = "Автопик",
        [EN] = "AutoPick",
		[CN] = "AutoPick",
    },
    ['optionCandys'] = {
    	[RU] = "Возращаться на базу если конфет больше",
        [EN] = "Drop candys if amount more",
		[CN] = "Drop candys if amount more",
    }
} 



local rootPath = "D"

local mainPath = {rootPath}


if language == RU then
    rootPath = "D"
    mainPath = {rootPath}
end 

local function Stringify( string, ... )
	string = '[' .. string .. ']'
	return string
end

local function ToJSON( tbl, ... )
	if type(tbl) == "table" then 
		local message = '{'
		for k, v in pairs(tbl) do
			if type(v) == "table" then
				message = message .. '"' .. k .. '": ' .. Stringify(ToJSON(v)) .. ','
			else
				message = message .. '"' .. k .. '": "' .. tostring(v) .. '",'
			end
		end 
		if string.len(message) ~= 1 then
			message = string.sub(message, 1 , string.len(message) - 1) .. '}'
		else
			message = '{}'
		end
		return message
	end
	return (tostring(tbl))
end

_G.log = function( msg, ... )
	if type(msg) == "table" then
		return Log.Write(ToJSON(msg))
	end
	if select(1, ... ) == nil then
		return Log.Write(tostring(msg))
	else
		local message = tostring(msg)
		local i = 1
		local lastTable = false
		repeat
			if type(select(i, ...)) == "table" then
				message = message  .. '\n' .. Stringify(ToJSON(select(i, ...))) .. '\n'
				lastTable = true
			else
				if lastTable == false then
					message = message  .. ' | ' .. tostring(select(i, ...))
				else
					message = message  .. tostring(select(i, ...))
					lastTable = false
				end
			end
			i = i + 1
		until select(i, ... ) == nil
		Log.Write(message)
	end
end

Diretide.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Diretide.optionEnable, "panorama/images/bot_icon_unfair_png.vtex_c")

Menu.AddMenuIcon(mainPath, "~/MenuIcons/diretide.png")


Diretide.optionFind = Menu.AddOptionBool(mainPath, Translation.optionFind[language], false)
Menu.AddOptionIcon(Diretide.optionFind, "~/MenuIcons/search.png")

Diretide.optionPick = Menu.AddOptionBool(mainPath, Translation.optionPick[language], false)
Menu.AddOptionIcon(Diretide.optionPick, "~/MenuIcons/search.png")


Diretide.optionCandys = Menu.AddOptionSlider(mainPath, Translation.optionCandys[language], 0, 10, 0);
Menu.AddOptionIcon(Diretide.optionCandys, "panorama\\images\\events\\diretide\\2020\\candy_icon_small_psd.vtex_c")


local abilityArray = {};
local currentAbilityIndex = 0;

local itemOrder = {
		{
			["item_name"] = "item_phase_boots",
			["recipe"] = {
				{29, "item_boots"},
				{2, "item_blades_of_attack"},
				{4, "item_chainmail"},
			}
			
		},
		{
			["item_name"] = "item_blade_mail",
			["recipe"] = {
				{4, "item_chainmail"},
				{3, "item_broadsword"},
				{126, "item_recipe_blade_mail"},
			}
			
		},
		{
			["item_name"] = "item_radiance",
			["recipe"] = {
				{54, "item_relic"},
				{136, "item_recipe_radiance"},
			}
			
		},
		{
			["item_name"] = "item_heart",
			["recipe"] = {
				{279, "item_ring_of_tarrasque"},
				{61, "item_vitality_booster"},
				{53, "item_reaver"},
				{113, "item_recipe_heart"},
			}
			
		},
		{
			["item_name"] = "item_shivas_guard",
			["recipe"] = {
				{9, "item_platemail"},
				{58, "item_mystic_staff"},
				{118, "item_recipe_shivas_guard"},
			}
			
		},
		{
			["item_name"] = "item_satanic",
			["recipe"] = {
				{26, "item_lifesteal"},
				{53, "item_reaver"},
				{5, "item_claymore"},
				{155, "item_recipe_satanic"},
			}
			
		},

	}


local abilityUsage = {
	["npc_dota_hero_bristleback"] = {
		[1] = {Ability.CastNoTarget, 650},
		[0] = {Ability.CastTarget, 300},
	},
	["npc_dota_hero_necrolyte"] = {
		[0] = {Ability.CastNoTarget, 450},
	},
	["npc_dota_hero_razor"] = {
		[0] = {Ability.CastNoTarget, 700},
		[1] = {Ability.CastTarget, 600},
		[5] = {Ability.CastNoTarget, 700},
	},
	["npc_dota_hero_spectre"] = {
		[5] = {Ability.CastNoTarget, 10000},
		[0] = {Ability.CastTarget, 700},
	},
	["npc_dota_hero_axe"] = {
		[0] = {Ability.CastNoTarget, 250},
		[1] = {Ability.CastTarget, 500},
	},
	["npc_dota_hero_centaur"] = {
		[0] = {Ability.CastNoTarget, 250},
		[1] = {Ability.CastTarget, 233},
		[5] = {Ability.CastNoTarget, 1500},
	},

}
local lastAbilityUsage = 0;

local font = Renderer.LoadFont("Tahome", 25, 0)

function Diretide.DrawUnderHero(unit, text, font, yOffset)
    if not unit or not Entity.IsNPC(unit) then
        return
    end

    local pos = Entity.GetAbsOrigin(unit)
    local x, y, v = Renderer.WorldToScreen(pos)
    if v then
        local HBO = NPC.GetHealthBarOffset(unit)
        local z = pos:GetZ()
        if not yOffset then
           z =  pos:GetZ()+HBO
        end
        local origin = Vector(pos:GetX(),pos:GetY(), z)
        local hx, hy = Renderer.WorldToScreen(origin)
        Renderer.DrawText(font, hx, hy, text)
    end
end


local lastBmCast = 0;
function Diretide.OnEntityHurt(obj)
	if GameRules.GetGameMode() ~= 19 or not Menu.IsEnabled(Diretide.optionEnable) then
		return	
	end

    if not obj.target or not obj.source or not obj.damage then
        return
    end

    if (obj.target == Heroes.GetLocal() and obj.damage > 50 and NPC.IsHero(obj.source)) then
    	local bm = NPC.GetItem(Heroes.GetLocal(), "item_blade_mail");
    	if bm and Ability.IsReady(bm) and Ability.IsCastable(bm, NPC.GetMana(Heroes.GetLocal())) and Diretide.SleepReady(1, lastBmCast) then
    		Ability.CastNoTarget(bm)
    		lastBmCast = os.clock()
    	end
    end 
        
end


function Diretide.getItem(hero, name)
	for i = 0, 20 do
		local item = NPC.GetItemByIndex(hero, i)
		if item and Ability.GetName(item) == name then
			return item
		end
	end
	return false
end

local function freeSlotCount()
	local count = 0;
	for i = 0, 8 do
		if not NPC.GetItemByIndex(Heroes.GetLocal(), i) then
			count = count + 1
		end
	end
	return count
end

local function getFreeSlot()
	for i = 0, 8 do
		if not NPC.GetItemByIndex(Heroes.GetLocal(), i) then
			return i
		end
	end
	return false
end

local function getCandyBucket()
	for i, npc in pairs(NPCs.GetAll()) do
		if npc and Entity.IsSameTeam(npc, Heroes.GetLocal()) and NPC.GetUnitName(npc) == 'home_candy_bucket' and Entity.IsAlive(npc) then
			return npc
		end
 	end
 	return false;
end


function Diretide.GetFromBackPack()
	local slots = freeSlotCount();
	if slots == 0 then
		return
	end
	for i = 9, 14 do 
		local item = NPC.GetItemByIndex(Heroes.GetLocal(), i)
		if item then
			local slot = getFreeSlot()
			if slot then
				Player.PrepareUnitOrders(Players.GetLocal(), 19, slot, Vector(0, 0, 0), item, 0, Heroes.GetLocal());
				return
			end
		end

	end
end

local lastItemMove = 0;
local lastPhaseCast = 0;
local lastGiveCandy = 0;
local lastUnpause = 0;
local lastshivaCast = 0;

function Diretide.OnEntityDestroy(ent)
	if ent == myHero then
		myHero = nil;
		myPlayer = nil;
		mySide = nil;
	end
end

function Diretide.OnUpdate()

	if GameRules.GetGameMode() ~= 19 then
		return
	end

	if (not Menu.IsEnabled(Diretide.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end	

	if (not myPlayer) then
		myPlayer = Players.GetLocal()
		return
	end

	if (not mySide) then
		mySide = Entity.GetTeamNum(myPlayer)
		return
	end

	if GameRules.GetGameStartTime() < 1 then
		return
	end

	if (not Entity.IsAlive(myHero)) then
		return
	end

	if (NPC.IsChannellingAbility(myHero)) then
		return
	end
	if NPC.HasModifier(Heroes.GetLocal(), "modifier_fountain_aura_buff") and Diretide.SleepReady(1, lastItemMove) then 
		Diretide.GetFromBackPack()
		lastItemMove = os.clock();
	end


	local heroName = NPC.GetUnitName(myHero);

--Абилки
	
	abilityArray = {}
	for i = 0, 16 do
		abilityArray[i] = NPC.GetAbilityByIndex(myHero, i);
	end

	local phase = NPC.GetItem(myHero, "item_phase_boots");
	if phase and NPC.IsRunning(myHero) and Ability.IsReady(phase) and Diretide.SleepReady(1, lastPhaseCast) then
		Ability.CastNoTarget(phase)
		lastPhaseCast = os.clock()
	end

	if GameRules.IsPaused() and Diretide.SleepReady(2, lastUnpause) then
		Engine.ExecuteCommand("dota_pause")
		lastUnpause = os.clock()
	end

	if Diretide.SleepReady(4, lastCentered) then
		Engine.ExecuteCommand("+dota_camera_center_on_hero");
		lastCentered = os.clock()
	end

---------------------------------------
--Мана героя
	local mana = NPC.GetMana(myHero)
--Хп героя
	local hp = (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero)))
-----------------------------------------
--Место сбора
	local place = Vector(-162.16220092773, -2939.4790039062, 256.0)
	local nearestHero, distance = Diretide.FindNearestHero(myHero)

	

	local candys = NPC.GetAbility(Heroes.GetLocal(), "hero_candy_bucket")
	local bucket = getCandyBucket()

	-- {"npc": "userdata: 0000026D91085400","orderIssuer": "3","order": "6","queue": "false","showEffects": "true","position": "Vector(0.0, 0.0, 0.0)","player": "userdata: 0000026C64441800","target": "userdata: 0000026DE2133800","ability": "userdata: 0000026C95642A00"}
	-- home_candy_bucket

	local shiva = NPC.GetItem(myHero, "item_shivas_guard");
	if shiva and nearestHero and distance < 700 and Ability.IsReady(shiva) and Diretide.SleepReady(1, lastshivaCast) then
		Ability.CastNoTarget(shiva)
		lastshivaCast = os.clock()
	end
	
	
	if candys and Ability.GetCurrentCharges(candys) > Menu.GetValue(Diretide.optionCandys) and Menu.GetValue(Diretide.optionCandys) > 0 and bucket then
		if nearestHero then
			Renderer.SetDrawColor(255,255,255,255)
			Diretide.DrawUnderHero(bucket, "TARGET", font)
		end

		if Diretide.SleepReady(1, lastGiveCandy) then
			Ability.CastTarget(candys, bucket);
			lastGiveCandy = os.clock();
		end
	else
		if nearestHero then
			Renderer.SetDrawColor(255,255,255,255)
			Diretide.DrawUnderHero(nearestHero, "TARGET", font)
		end
		if hp > 60 then
			if Diretide.SleepReady(orderDelay, lastMoveOrder) then
				if nearestHero then
					if (Entity.GetAbsOrigin(nearestHero) - Entity.GetAbsOrigin(myHero)):Length2D() < 750 then
						Player.AttackTarget(myPlayer, myHero, nearestHero)
					else
						local absOrigin = Entity.GetAbsOrigin(myHero);
						local vector = absOrigin + (Entity.GetAbsOrigin(nearestHero) - absOrigin):Normalized():Scaled(580);
						Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, vector, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero, false, true)
					end
					lastMoveOrder = os.clock()
				end	
			end	
		else
			if Diretide.SleepReady(orderDelay2, lastMoveOrder2) then
				local absOrigin = Entity.GetAbsOrigin(myHero);
				local vector = absOrigin + (fountainTable[mySide] - absOrigin):Normalized():Scaled(580);
				Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, vector, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero, false, true)
				--NPC.MoveTo(myHero, fountainTable[mySide])
				lastMoveOrder2 = os.clock()
			end	
		end

	end


	

	if (hp > 60 or heroName == "npc_dota_hero_necrolyte") and nearestHero and abilityUsage[heroName] and Diretide.SleepReady(1, lastAbilityUsage) then
		for index, ability_struct in pairs(abilityUsage[heroName]) do
			if abilityArray[index] and Entity.IsAbility(abilityArray[index]) and Ability.GetLevel(abilityArray[index]) > 0 and distance < ability_struct[2] then
				if Ability.IsCastable(abilityArray[index], mana) and Ability.IsReady(abilityArray[index]) then
					if (Ability.CastTarget == ability_struct[1]) then
						ability_struct[1](abilityArray[index], nearestHero)
					end

					if (Ability.CastNoTarget == ability_struct[1]) then
						ability_struct[1](abilityArray[index])
					end
					lastAbilityUsage = os.clock()
				end
			end
		end
	end



--Прокачка абилок
	if Diretide.SleepReady(3, lastLearnOrder) then
		if currentAbilityIndex > 16 then
			currentAbilityIndex = 0;
		end

		if abilityArray[currentAbilityIndex] and Entity.IsAbility(abilityArray[currentAbilityIndex]) and not Ability.IsHidden(abilityArray[currentAbilityIndex]) and Ability.GetLevel(abilityArray[currentAbilityIndex]) < 4 then
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_TRAIN_ABILITY, abilityArray[currentAbilityIndex], Vector(0,0,0), abilityArray[currentAbilityIndex], Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
		end
		currentAbilityIndex = currentAbilityIndex + 1;
		lastLearnOrder = os.clock()
	end

	if Diretide.SleepReady(3, lastBuyOrder) then
		lastBuyOrder = os.clock()
		for index, recipe_table in pairs(itemOrder) do
			local item = Diretide.getItem(myHero, recipe_table.item_name);
			if not item then
				for i, item_struct in pairs(recipe_table.recipe) do
					local recipe_item = Diretide.getItem(myHero, item_struct[2]);
					if not recipe_item then
						Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_PURCHASE_ITEM, item_struct[1], Vector(0,0,0), item_struct[1], Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
						return;
					end
				end

				break
			end
		end
	end
end


--Блиайший герой

function Diretide.FindNearestHero(myHero)
	local enemyNew2, enemyNewDistance, enemyNewDistance2 = nil, nil, 99999999999

	if Entity.IsAlive(myHero) then 
		for index, hero in pairs(NPCs.GetAll()) do
			if not Entity.IsDormant(hero) and Entity.IsAlive(hero) and NPC.IsHero(hero) and not NPC.IsIllusion(hero) and not Entity.IsSameTeam(hero, myHero) and not NPC.HasState(hero,Enum.ModifierState.MODIFIER_STATE_OUT_OF_GAME) -- 
				and not NPC.HasState(hero,Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasState(hero,Enum.ModifierState.MODIFIER_STATE_ATTACK_IMMUNE) then
				enemyNewDistance = ((Entity.GetOrigin(myHero) - Entity.GetOrigin(hero)):Length2D())
				if enemyNewDistance < enemyNewDistance2   then
					enemyNewDistance2 = enemyNewDistance 
					enemyNew2 = hero
				end	
			end		
		end
		return enemyNew2, enemyNewDistance2
	end	
end	

local lastPickOrder = 0;
local lastFindingMatchOrder = 0;
--Пик героя + поиск
local heroes_names = {"npc_dota_hero_spectre", "npc_dota_hero_bristleback", "npc_dota_hero_razor", "npc_dota_hero_centaur", "npc_dota_hero_necrolyte", "npc_dota_hero_axe"}
local heroIndex = 1;
local banPhaseStart = 0;
local state = GameRules.GetGameState();
function Diretide.OnFrame()
	if state ~= GameRules.GetGameState() and GameRules.GetGameState() == 2 then
		state = GameRules.GetGameState();
		banPhaseStart = GameRules.GetGameTime();
	end

	if Menu.IsEnabled(Diretide.optionPick) and GameRules.GetGameState() == 2 and Diretide.SleepReady(15, banPhaseStart) and not GameRules.IsInBanPhase() and GameRules.GetGameMode() == 19 then
		if Diretide.SleepReady(2, lastPickOrder) then
			lastPickOrder = os.clock();
			Engine.ExecuteCommand("dota_select_hero ".. heroes_names[heroIndex]) --  .. heroes_names[math.random(0, 6)]
			heroIndex = heroIndex  + 1;
			if (heroIndex == 7) then
				Engine.ExecuteCommand("dota_select_hero random")
				heroIndex = 1;
			end
		end
	end	

	if Menu.IsEnabled(Diretide.optionFind) and GameRules.GetGameState() == 6 and GameRules.GetGameMode() == 19 then
		if Diretide.SleepReady(5, lastPickOrder) then
			lastPickOrder = os.clock();
			Engine.ExecuteCommand("disconnect")
		end
	end 

	if Menu.IsEnabled(Diretide.optionFind) and GameRules.GetGameState() == -1 then
		if Diretide.SleepReady(3, lastFindingMatchOrder) then
			lastFindingMatchOrder = os.clock()
		    local enc_message = protobuf.encodeFromJSON('CMsgStartFindingMatch', JSON:encode({
		        game_modes = "524288",
		        matchlanguages = "0",
		        solo_queue = "false",
		        bot_difficulty = "BOT_DIFFICULTY_EASY",
		        team_id = "0",
		        is_challenge_match = "false",
		        bot_script_index = "0",
		        match_type = "MATCH_TYPE_EVENT",
		        steam_clan_account_id = "0",
		        matchgroups = "388",
		        custom_game_difficulty_mask = "1",
		        disable_experimental_gameplay = "false",
		        high_priority_disabled = "false",
		        lane_selection_flags = "0",
		        key = "",
		    }))
		    GC.SendMessage( enc_message.binary, 7033, enc_message.size )
		end
	end
end

return Diretide