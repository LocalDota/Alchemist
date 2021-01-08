
local Autobuy = {}

local myPlayer, myHero = nil, nil

local rootPath = "Utility"

local mainPath = {rootPath, "Autobuy"}

local lastBuyOrder = 0
local orderDelay = 3

local lastBuyOrder2 = 0
local orderDelay2 = 3

function Autobuy.SleepReady(sleep, lastTick)
    return (os.clock() - lastTick) >= sleep 
end

local dead = Menu.AddOptionBool(mainPath, "Dont buy when dead", true)
Menu.AddOptionIcon(dead, "~/MenuIcons/enable/enable_check.png")

Autobuy.itemsSelection = Menu.AddOptionMultiSelect(mainPath, "Items Selection:", 
{
{"observer", "panorama/images/items/ward_observer_png.vtex_c", false},
{"sentry", "panorama/images/items/ward_sentry_png.vtex_c", false},
{"smoke", "panorama/images/items/smoke_of_deceit_png.vtex_c", false},
}, false)
Menu.AddMenuIcon(mainPath, "~/MenuIcons/coins.png")


function Autobuy.OnUpdate()
	if (not myHero) then
        myHero = Heroes.GetLocal()
        return
    end 

    if (not myPlayer) then
        myPlayer = Players.GetLocal()
        return
    end

    if GameRules.IsPaused() then return end

    if GameRules.GetGameState() ~= 5 then return end

    local Table = Menu.GetItems(Autobuy.itemsSelection)

    local items = {
		["observer"] = 42,
		["sentry"] = 43,
		["smoke"] = 188		
    }	

 	if Menu.IsEnabled(dead) then
 		if Entity.IsAlive(myHero) then
    		if Autobuy.SleepReady(orderDelay, lastBuyOrder) then
    			for i = 1, #Table do
    				local item = items[Table[i]]    		
    				if (Menu.IsSelected(Autobuy.itemsSelection, Table[i])) then
    					local count = Item.GetStockCount(item)
    					if count > 0 then
    						Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_PURCHASE_ITEM, item, Vector(0,0,0), item, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
    					end
    				end	
    			end
    			lastBuyOrder = os.clock()
    		end
    	end
    else
    	if Autobuy.SleepReady(orderDelay2, lastBuyOrder2) then
    		for i = 1, #Table do
    			local item = items[Table[i]]    		
    			if (Menu.IsSelected(Autobuy.itemsSelection, Table[i])) then
    				local count = Item.GetStockCount(item)
    				if count > 0 then
    					Player.PrepareUnitOrders(myPlayer, Enum.UnitOrder.DOTA_UNIT_ORDER_PURCHASE_ITEM, item, Vector(0,0,0), item, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
    				end
    			end	
    		end
    		lastBuyOrder2 = os.clock()
    	end		
    end			
end

return Autobuy