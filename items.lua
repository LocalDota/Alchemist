
local Items = {} 

local myHero = nil


---------------------------------------------------------------------------------------------


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
    ["optionSlider"] = {
        [RU] = "Порог здоровья в %",
        [EN] = "HPercent Threshold",
		[CN] = "生命值百分比",
    },
    ["optionSlider2"] = {
        [RU] = "Порог здорoвья в %", -- здоровья 2 o EN
        [EN] = "HPercent Threshold",
		[CN] = "生命值百分比",
    },
}

local rootPath = "Utility"

local mainPath = {rootPath, "Neutral Items"}

if language == RU then
    rootPath = "Утилиты"
    mainPath = {rootPath, "Нейтральные предметы"}
end   
if language == CN then
    rootPath = "通用"
    mainPath = {rootPath, "中立物品助手"}
end     





Items.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Items.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "~/MenuIcons/box_drop.png")



Items.optionArcaneRing = Menu.AddOptionBool(mainPath, "Acrane Ring", false)
Menu.AddOptionIcon(Items.optionArcaneRing, "panorama/images/items/".."arcane_ring".."_png.vtex_c")



Items.optionIronTalon = Menu.AddOptionBool(mainPath, "Iron Talon", false)
Menu.AddOptionIcon(Items.optionIronTalon, "panorama/images/items/".."iron_talon".."_png.vtex_c")



Items.optionSpiderLegs = Menu.AddOptionBool(mainPath, "Spider Legs", false)
Menu.AddOptionIcon(Items.optionSpiderLegs, "panorama/images/items/".."spider_legs".."_png.vtex_c")



Items.optionHavocHammer = Menu.AddOptionBool(mainPath, "Havoc Hammer", false)
Menu.AddOptionIcon(Items.optionHavocHammer, "panorama/images/items/".."havoc_hammer".."_png.vtex_c")



Items.optionEssenceRing = Menu.AddOptionBool(mainPath, "Essence Ring", false)
Items.optionSlider = Menu.AddOptionSlider(mainPath, Translation.optionSlider[language], 1, 100, 20)
Menu.AddOptionIcon(Items.optionEssenceRing, "panorama/images/items/".."essence_ring".."_png.vtex_c")
Menu.AddOptionIcon(Items.optionSlider, "~/MenuIcons/edit.png")



Items.optionGreaterFaerieFire = Menu.AddOptionBool(mainPath, "Greater Faerie Fire", false)
Items.optionSlider2 = Menu.AddOptionSlider(mainPath, Translation.optionSlider2[language], 1, 100, 10)
Menu.AddOptionIcon(Items.optionGreaterFaerieFire, "panorama/images/items/".."greater_faerie_fire".."_png.vtex_c")
Menu.AddOptionIcon(Items.optionSlider2, "~/MenuIcons/edit.png")



---------------------------------------------------------------------------------------------------------------



function Items.OnUpdate()

	if (not Menu.IsEnabled(Items.optionEnable)) then
		myHero = nil
		return
	end

	if (not myHero) then
		myHero = Heroes.GetLocal()
		return
	end


	local tp = NPC.GetItemByIndex(myHero, 15)


	local arcanering = NPC.GetItem(myHero, "item_arcane_ring")


	local irontalon = NPC.GetItem(myHero, "item_iron_talon")


	local spiderlegs = NPC.GetItem(myHero, "item_spider_legs")


	local havochammer = NPC.GetItem(myHero, "item_havoc_hammer")


	local essencering = NPC.GetItem(myHero, "item_essence_ring")

	local greaterfaeriefire = NPC.GetItem(myHero, "item_greater_faerie_fire")
		

	if Menu.IsEnabled(Items.optionArcaneRing) and arcanering and (not NPC.IsChannellingAbility(myHero))   and NPC.GetMana(myHero)+100 < NPC.GetMaxMana(myHero) and Ability.IsReady(arcanering) and NPC.GetItemByIndex(myHero, 16) == arcanering and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
		if tp  then
			if (not Ability.IsChannelling(tp)) then
				Ability.CastNoTarget(arcanering)
			end	
		else
			Ability.CastNoTarget(arcanering)
		end		
	end	

	local table_radius_talon = Entity.GetUnitsInRadius(myHero, 350, Enum.TeamType.TEAM_ENEMY)
	if Menu.IsEnabled(Items.optionIronTalon) and irontalon and (not NPC.IsChannellingAbility(myHero))  and #table_radius_talon > 0 and #Entity.GetHeroesInRadius(myHero, 1500, Enum.TeamType.TEAM_ENEMY) == 0 and Entity.GetHealth(myHero) > 150 and Ability.IsReady(irontalon) and NPC.GetItemByIndex(myHero, 16) == irontalon and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
		for index, unit in pairs(table_radius_talon) do
			if Entity.GetHealth(unit) > 550 then
				if tp then
					if (not Ability.IsChannelling(tp)) then
						Ability.CastTarget(irontalon, unit)
					end	
				else
					Ability.CastTarget(irontalon, unit)
				end		
			end		
		end
	end	

	if Menu.IsEnabled(Items.optionSpiderLegs) and spiderlegs and (not NPC.IsChannellingAbility(myHero))  and Ability.IsReady(spiderlegs) and NPC.GetItemByIndex(myHero, 16) == spiderlegs and NPC.IsRunning(myHero) and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) then
		if tp  then
			if (not Ability.IsChannelling(tp)) then
				Ability.CastNoTarget(spiderlegs)
			end	
		else
			Ability.CastNoTarget(spiderlegs)
		end			
	end

	if Menu.IsEnabled(Items.optionHavocHammer) and havochammer and (not NPC.IsChannellingAbility(myHero)) and #Entity.GetHeroesInRadius(myHero, 400, Enum.TeamType.TEAM_ENEMY) ~= 0 and Ability.IsReady(havochammer) and NPC.GetItemByIndex(myHero, 16) == havochammer and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE)  then	
		if tp  then
			if (not Ability.IsChannelling(tp)) then
				Ability.CastNoTarget(havochammer)
			end	
		else
			Ability.CastNoTarget(havochammer)
		end	
	end	
	
	local result = Menu.GetValue(Items.optionSlider) 
	if Menu.IsEnabled(Items.optionEssenceRing) and essencering and (not NPC.IsChannellingAbility(myHero)) and Ability.IsReady(essencering) and NPC.GetItemByIndex(myHero, 16) == essencering and NPC.GetMana(myHero) > 200 and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < result and #Entity.GetHeroesInRadius(myHero, 700, Enum.TeamType.TEAM_ENEMY) ~= 0 and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE)  then
		if tp  then
			if (not Ability.IsChannelling(tp)) then
				Ability.CastNoTarget(essencering)
			end	
		else
			Ability.CastNoTarget(essencering)
		end		
	end	

	local result_2 = Menu.GetValue(Items.optionSlider2) 
	if Menu.IsEnabled(Items.optionGreaterFaerieFire) and greaterfaeriefire and (not NPC.IsChannellingAbility(myHero)) and Ability.IsReady(greaterfaeriefire) and NPC.GetItemByIndex(myHero, 16) == greaterfaeriefire and (100/(Entity.GetMaxHealth(myHero)/Entity.GetHealth(myHero))) < result_2 and #Entity.GetHeroesInRadius(myHero, 700, Enum.TeamType.TEAM_ENEMY) ~= 0 and not NPC.HasState(myHero, Enum.ModifierState.MODIFIER_STATE_INVISIBLE)  then
		if tp then
			if (not Ability.IsChannelling(tp)) then
				Ability.CastNoTarget(greaterfaeriefire)
			end	
		else
			Ability.CastNoTarget(greaterfaeriefire)
		end		
	end			
end

return Items

