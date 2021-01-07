
--Создание таблицы
local Economy = {}

--Присваивание нулевого значения переменным
local myCourier, myPlayer, mySide, burst, shield = nil, nil, nil, nil, nil               


--Создаем таблицу векторов 2(Radiant), 3(Dire)
local fountainTable = {
	[2] = Vector(-6578, -6019, 282),
	[3] = Vector(6605, 5975, 534)
}

local fountainTable_2 = {
	[2] = Vector(-6320, -5827, 256),
	[3] = Vector(6265, 5754, 256) 
}

local fountainTable_3 = {
	[2] = Vector(-7485.3154296875, -6964.5546875, 383.99987792969),
	[3] = Vector(7429.0141601562, 6894.7373046875, 384.0)
}

------------------------------------------------
--временной промежуток
local lastMoveOrder = 0
local orderDelay = 1 -- 1сек

local lastMoveOrder2 = 0
local orderDelay2 = 0.1 

local lastMoveOrder3 = 0
local orderDelay3 = 0.1 

local lastMoveOrder4 = 0
local orderDelay4 = 3 

function Economy.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end

-----------------------------------------------------------------------------------------------------------------------
--Переводы

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
		[CN] = "开启",
    },
    ["optionAutoBurst"] = {
        [RU] = "Авто-Ускорение",
        [EN] = "Auto-Burst",
		[CN] = "自动加速",
    },
    ["optionAutoShield"] = {
    	[RU] = "Авто-Щит",
    	[EN] = "Auto-Shield",
		[CN] = "自动开盾",
    },
    ["optionEconomyCourier"] = {
    	[RU] = "Экономный Курьер",
    	[EN] = "Economy Courier",
		[CN] = "信使最优设置",
    },
    ["optionSlider"] = {
    	[RU] = "Максимальное кол-во слотов манго",
    	[EN] = "Maximum number of mango slots",
		[CN] = "自动收集芒果树芒果最大数量",
    },
    ["optionMango"] = {
    	[RU] = "Собирать Манго",
    	[EN] = "Collect Mango",
		[CN] = "信使自动收集芒果",
    },
}

local rootPath = "Utility"

local mainPath = {rootPath, "Courier"}

if language == RU then
    rootPath = "Утилиты"
    mainPath = {rootPath, "Курьер"}
end    

if language == CN then
    rootPath = "通用"
    mainPath = {rootPath, "信使控制"}
end 




Economy.optionEnable = Menu.AddOptionBool(mainPath, Translation.optionEnable[language], false)
Menu.AddOptionIcon(Economy.optionEnable, "~/MenuIcons/enable/enable_check_round.png")
Menu.AddMenuIcon(mainPath, "~/MenuIcons/Dota/Courier_Donkey.png")


Economy.optionEconomyCourier = Menu.AddOptionBool(mainPath, Translation.optionEconomyCourier[language], false)
Menu.AddOptionIcon(Economy.optionEconomyCourier, "panorama/images/spellicons/".."courier_autodeliver".."_png.vtex_c")



Economy.optionAutoBurst = Menu.AddOptionBool(mainPath, Translation.optionAutoBurst[language], false)
Menu.AddOptionIcon(Economy.optionAutoBurst, "panorama/images/spellicons/".."courier_burst".."_png.vtex_c")


Economy.optionAutoShield = Menu.AddOptionBool(mainPath, Translation.optionAutoShield[language], false)
Menu.AddOptionIcon(Economy.optionAutoShield, "panorama/images/spellicons/".."courier_shield".."_png.vtex_c")



--------------------------------------------------------------------------------------------------------------

--Основная функция
function Economy.OnUpdate()
       --Если отдел отключен тогда курьер = 0
	if (not Menu.IsEnabled(Economy.optionEnable)) then
		myCourier = nil
		return
	end
        --Если нет игрока то находим его
	if (not myPlayer) then
		myPlayer = Players.GetLocal()
		return
	end
        --Если нет стороны, находим
	if (not mySide) then
		mySide = Entity.GetTeamNum(myPlayer)
		return
	end
--Если нет курьера тогда перебераем всех курьеров в игре через условие (если курьер=игроку, тогда курьер найден)
	if (not myCourier) then
		for index, courier in pairs(Couriers.GetAll()) do
			if Entity.GetOwner(courier) == myPlayer then
				myCourier = courier
			end	
		end
		return
	end

	if (not burst) then
		burst = NPC.GetAbility(myCourier, "courier_burst")
		return
	end	

	if (not shield) then
		shield = NPC.GetAbility(myCourier, "courier_shield") --♥Иришка
		return
	end
-------------------------------------------------------------------------------------------------------------------------------
--Move_2 = спустить со ступенек, Move = на ступеньки
	if  Menu.IsEnabled(Economy.optionEconomyCourier) then
		if Economy.SleepReady(orderDelay, lastMoveOrder) then
			if NPC.GetModifier(myCourier, "modifier_fountain_aura_buff") and ((Entity.GetOrigin(myCourier) - fountainTable_2[mySide]):Length2D()) < 1600 and #Heroes.InRadius(fountainTable[mySide], 2000, mySide, Enum.TeamType.TEAM_ENEMY) == 0 and (Courier.GetCourierState(myCourier) ~= Enum.CourierState.COURIER_STATE_DELIVERING_ITEMS) and (Courier.GetCourierState(myCourier) ~= Enum.CourierState.COURIER_STATE_IDLE) and (Courier.GetCourierState(myCourier) ~= Enum.CourierState.COURIER_STATE_MOVING) and (Courier.GetCourierState(myCourier) ~= Enum.CourierState.COURIER_STATE_RETURNING_TO_BASE) then
				Economy.Move_2(myCourier)	
			else
				Economy.Move(myCourier)
			end
			lastMoveOrder = os.clock()
		end	
	end	
--------------------------------------------------------------------------------------------------------------------------
--Авто-Щит 
	if Economy.SleepReady(orderDelay2, lastMoveOrder2) then
		if  Menu.IsEnabled(Economy.optionAutoShield) then
			if Ability.IsReady(shield) and Ability.GetLevel(shield) > 0 then
				for index, ent in pairs(Entity.GetUnitsInRadius(myCourier, 700, Enum.TeamType.TEAM_ENEMY)) do
					if NPC.IsTower(ent) then
						Ability.CastNoTarget(shield)
					end
					return	
				end
				if #Entity.GetHeroesInRadius(myCourier, 700, Enum.TeamType.TEAM_ENEMY) ~= 0 then
					Ability.CastNoTarget(shield)
				end		
			end
		end
		lastMoveOrder2 = os.clock()
	end	

-----------------------------------------------------------------------------------------------------------------------	
--Авто-Ускорение
	if Economy.SleepReady(orderDelay3, lastMoveOrder3) then
		if	Menu.IsEnabled(Economy.optionAutoBurst) then
			if #Entity.GetHeroesInRadius(myCourier, 700, Enum.TeamType.TEAM_ENEMY) ~= 0 and Ability.IsReady(burst) and Ability.GetLevel(burst) > 0 then
				Ability.CastNoTarget(burst)
			end
		end
		lastMoveOrder3 = os.clock()
	end	
--------------------------------------------------------------------------------------------------------------------------
--Лечим куру если ранена
	if Economy.SleepReady(orderDelay4, lastMoveOrder4) then
		if Entity.GetHealth(myCourier) < Entity.GetMaxHealth(myCourier) and ((Entity.GetOrigin(myCourier) - fountainTable_2[mySide]):Length2D()) < 1600 and (Courier.GetCourierState(myCourier) == Enum.CourierState.COURIER_STATE_IDLE) then
			NPC.MoveTo(myCourier, fountainTable[mySide])
		end
		lastMoveOrder4 = os.clock()
	end	

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----Считаем манго в куре. Отправляем домой, когда кура полная.
--
--	local sumCurrent = 0
--	for i = 0, 8 do
--		local itemAbilityCourier = NPC.GetItemByIndex(myCourier, i)
--		if itemAbilityCourier then
--			if Ability.GetName(itemAbilityCourier) == "item_enchanted_mango" then
--				sumCurrent = sumCurrent + Item.GetCurrentCharges(itemAbilityCourier)
--			end
--		end
--	end
--	if lastSum < (sumCurrent / 3) and (sumCurrent / 3) >= Menu.GetValue(Economy.optionSlider) then
--		NPC.MoveTo(myCourier, fountainTable_2[mySide])
--	end
--	lastSum = (sumCurrent / 3);
------------------------------------------------------------------------------------------------------------------------------	
--Если кура стоит на базе без дела, то домой
	--if Menu.IsEnabled(Economy.optionMango) then
	--	if 	(Courier.GetCourierState(myCourier) == Enum.CourierState.COURIER_STATE_IDLE) and ((Entity.GetOrigin(myCourier) - fountainTable_2[mySide]):Length2D()) < 2000 and ((Entity.GetOrigin(myCourier) - fountainTable_2[mySide]):Length2D()) > 30 and ((Entity.GetOrigin(myCourier) - fountainTable[mySide]):Length2D()) > 100 then
	--		Economy.Move_2(myCourier)
	--	end
	--end
	

------------------------------------------------------------------------------------------------------------------------------------------------------
	
-----------------------------------------------------------------------------------------------------------------------------------------------------
----Перебераем все лежащие предметы, потом если он является предметом тогда создаем переменные с данными предмета и подбираем предмет курой
--	if Menu.IsEnabled(Economy.optionMango) then
--		if (Courier.GetCourierState(myCourier) == Enum.CourierState.COURIER_STATE_IDLE) or (Courier.GetCourierState(myCourier) == Enum.CourierState.COURIER_STATE_AT_BASE) then
--			for index, ent in pairs(PhysicalItems.GetAll()) do
--				if Entity.IsAbility(PhysicalItem.GetItem(ent)) then
--					local itemAbility = PhysicalItem.GetItem(ent)
--					local mango = Ability.GetName(itemAbility)
--					local origin = Entity.GetAbsOrigin(ent)
--					originL = Entity.GetAbsOrigin(ent)
--					if mango == "item_enchanted_mango" and ((origin - fountainTable_2[mySide]):Length2D()) < 2000 and #Heroes.InRadius(fountainTable[mySide], 3500, mySide, Enum.TeamType.TEAM_ENEMY) == 0 and (sumCurrent / 3) < Menu.GetValue(Economy.optionSlider) and ((Entity.GetOrigin(myCourier) - fountainTable_2[mySide]):Length2D()) < 2000 and ((fountainTable_3[mySide] - origin):Length2D()) > 1050  then
--						NPC.MoveTo(myCourier, origin)	
--						Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_PICKUP_ITEM, ent, origin, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myCourier)
--						return
--					end	
--				end	
--			end
--		end
--	end	
--	if originL then
--		if ((Entity.GetOrigin(myCourier) - originL):Length2D()) < 1 and (Courier.GetCourierState(myCourier) == Enum.CourierState.COURIER_STATE_IDLE) then
--			Economy.Move_2(myCourier)
--		end
--	end
end	
-------------------------------------------------------------------------------------------------------------------------

	

--------------------------------------------------------------------------------------------------------------------------
--на ступеньки
function Economy.Move(courier)
	if #Heroes.InRadius(fountainTable[mySide], 2000, mySide, Enum.TeamType.TEAM_ENEMY) ~= 0 and ((Entity.GetOrigin(myCourier) - fountainTable_2[mySide]):Length2D()) < 1600 and ((Entity.GetOrigin(myCourier) - fountainTable[mySide]):Length2D()) > 30 then
		NPC.MoveTo(courier, fountainTable[mySide])
	end	 	
end
--------------------------------------------------------------------------------------------------------------------------
--со ступенек спустить
function Economy.Move_2(courier)
	NPC.MoveTo(courier, fountainTable_2[mySide])
end	



function Economy.OnEntityDestroy(entity)
	if not myHero then 
		return
	end	

	if entity == myHero then
		Economy.Reinit()
		return
	end	
end	

function Economy.Reinit()
	myCourier, myPlayer, mySide, burst, shield = nil, nil, nil, nil, nil  
end	


return Economy

