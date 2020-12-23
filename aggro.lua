local Aggro = {}

local myHero, myPlayer, enemy, mySide = nil, nil, nil, nil




-------------------------------------------------------------------------------------------------------------------------------------------------
--Перевод
local RU = "russian"
local EN = "english" 
local CN = "Chinese" 
 
 
local language = EN
 
if Menu.GetLanguageOptionid then
    local LanguageItem = Menu.GetLanguageOptionid()
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
    ["optionAggro"] = {
        [RU] = "Кнопка для Агра",
        [EN] = "Button for Aggro",
		[CN] = "",
    },
    ["optionDeaggro"] = {
        [RU] = "Кнопка для Переагра",
        [EN] = "Button for DeAggro",
		[CN] = "",
    },
}




local rootPath = "Utility"

local mainPath = {rootPath, "Aggro"}




if language == RU then
    rootPath = "Скрипты на героев"
    mainPath = {rootPath, "Aggro"}
end 

if language == CN then
    rootPath = "独立英雄脚本"
    mainPath = {rootPath, "Aggro"}
end 
------------------------------------------------------------------------------------------------------------------------------------------------------------

Aggro.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Aggro.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "~/MenuIcons/Notifications/error_alert.png")


Aggro.optionAggro = Menu.AddKeyOption(mainPath, Translation.optionAggro[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Aggro.optionAggro, "~/MenuIcons/status.png")

Aggro.optionDeaggro = Menu.AddKeyOption(mainPath, Translation.optionDeaggro[language], Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(Aggro.optionDeaggro, "~/MenuIcons/status.png")








function Aggro.OnUpdate()

    if (not Menu.IsEnabled(Aggro.optionEnable)) then
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
   

    if Menu.IsKeyDownOnce(Aggro.optionAggro) then
    	local nearestHero = Input.GetNearestHeroToCursor(mySide, Enum.TeamType.TEAM_ENEMY)
    	if nearestHero and NPC.IsVisible(nearestHero) then
    		Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, nearestHero, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, myHero)
    		Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_HOLD_POSITION, nil, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, myHero)
    	end
        nearestHero = nil	
    end

    if Menu.IsKeyDownOnce(Aggro.optionDeaggro) then
    	local tableFriend = Entity.GetUnitsInRadius(myHero, 700, Enum.TeamType.TEAM_FRIEND)
    	local tableEnemy = Entity.GetUnitsInRadius(myHero, 700, Enum.TeamType.TEAM_ENEMY) 
    	for i, ent in pairs(tableEnemy) do
			if NPC.IsTower(ent) then
				tower = ent
				break
			end	
		end
		if tower then
			local tableTower = Entity.GetUnitsInRadius(tower, 700, Enum.TeamType.TEAM_ENEMY)
			local nearestUnit = Aggro.NearestTower(tower, tableTower, myHero)
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, nearestUnit, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, myHero)
			Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_HOLD_POSITION, nil, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, myHero)
        else
            local nearest = Aggro.Nearest(tableFriend, myHero)
            if nearest then
                Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, nearest, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, myHero)
                Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_HOLD_POSITION, nil, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_SELECTED_UNITS, myHero)
            end       
		end
		tower = nil	
        nearest = nil
        nearestUnit = nil
    end
---------------------------------------
end




function Aggro.NearestTower(entity, table, myHero)
	local creepNew2, creepNewDistance, creepNewDistance2 = nil, nil, 9999999999
	for i, ent in pairs(table) do
		if (Entity.IsSameTeam(ent, myHero)) then
			creepNewDistance = ((Entity.GetOrigin(tower) - Entity.GetOrigin(ent)):Length2D())
			if creepNewDistance < creepNewDistance2   then
				creepNewDistance2 = creepNewDistance 
				creepNew2 = ent
			end	
		end	
	end
	return creepNew2	
end

function Aggro.Nearest(table, myHero)
    local unitNew2, unitNewDistance, unitNewDistance2 = nil, nil, 9999999999
    for i, ent in pairs(table) do
        if (Entity.IsSameTeam(ent, myHero)) and ent ~= myHero then
            unitNewDistance = ((Entity.GetOrigin(tower) - Entity.GetOrigin(ent)):Length2D())
            if unitNewDistance < unitNewDistance2   then
                unitNewDistance2 = unitNewDistance 
                unitNew2 = ent
            end 
        end 
    end
    return unitNew2    
end 



function Aggro.OnEntityDestroy(entity)
    if not myHero then 
        return
    end 

    if entity == myHero then
        Aggro.Reinit()
        return
    end 
end 

function Aggro.Reinit()
    myHero, myPlayer, enemy, mySide = nil, nil, nil, nil
end 


return Aggro