local CRR = {}

local scriptEnable = false

local myPlayer, myHero = nil, nil

local radiusparticle1 = nil
local radiusparticle2 = nil
local radiusparticle3 = nil
local radiusparticle4 = nil
local radiusparticle5 = nil

local enable = Menu.AddOptionBool({ "Utility", "Custom range radiuses" }, "Enable", false)
Menu.AddOptionIcon(enable, "~/MenuIcons/enable/enable_check.png")
Menu.AddMenuIcon({ "Utility", "Custom range radiuses" }, "~/MenuIcons/radius.png")
-------------------------------------------------------------------------------------------
local ToggleKey = Menu.AddKeyOption({ "Utility", "Custom range radiuses", "Preset 1" }, "Toggle key on/off", Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(ToggleKey, "~/MenuIcons/status.png")
local enableslider1 = Menu.AddOptionBool({ "Utility", "Custom range radiuses", "Preset 1" }, "Enable radius", false)
Menu.AddOptionIcon(enableslider1, "~/MenuIcons/enable/enable_ios.png")
local slider1 = Menu.AddOptionSlider({ "Utility", "Custom range radiuses", "Preset 1" }, "Radius range", 100, 5000, 100)
Menu.AddOptionIcon(slider1, "~/MenuIcons/edit.png")
local color1 = Menu.AddOptionColorPicker({ "Utility", "Custom range radiuses", "Preset 1" }, "Radius color", 255, 255, 255, 255)

local ToggleKey2 = Menu.AddKeyOption({ "Utility", "Custom range radiuses", "Preset 2" }, "Toggle key on/off", Enum.ButtonCode.KEY_NONE)
Menu.AddOptionIcon(ToggleKey2, "~/MenuIcons/status.png")
local enableslider2 = Menu.AddOptionBool({ "Utility", "Custom range radiuses", "Preset 2" }, "Enable radius", false)
Menu.AddOptionIcon(enableslider2, "~/MenuIcons/enable/enable_ios.png")
local slider2 = Menu.AddOptionSlider({ "Utility", "Custom range radiuses", "Preset 2" }, "Radius range", 100, 5000, 100)
Menu.AddOptionIcon(slider2, "~/MenuIcons/edit.png")
local color2 = Menu.AddOptionColorPicker({ "Utility", "Custom range radiuses", "Preset 2" }, "Radius color", 255, 255, 255, 255)

local enableslider3 = Menu.AddOptionBool({ "Utility", "Custom range radiuses", "Preset 3" }, "Enable radius", false)
Menu.AddOptionIcon(enableslider3, "~/MenuIcons/enable/enable_ios.png")
local slider3 = Menu.AddOptionSlider({ "Utility", "Custom range radiuses", "Preset 3" }, "Radius range", 100, 5000, 100)
Menu.AddOptionIcon(slider3, "~/MenuIcons/edit.png")
local color3 = Menu.AddOptionColorPicker({ "Utility", "Custom range radiuses", "Preset 3" }, "Radius color", 255, 255, 255, 255)

local enableslider4 = Menu.AddOptionBool({ "Utility", "Custom range radiuses", "Preset 4" }, "Enable radius", false)
Menu.AddOptionIcon(enableslider4, "~/MenuIcons/enable/enable_ios.png")
local slider4 = Menu.AddOptionSlider({ "Utility", "Custom range radiuses", "Preset 4" }, "Radius range", 100, 5000, 100)
Menu.AddOptionIcon(slider4, "~/MenuIcons/edit.png")
local color4 = Menu.AddOptionColorPicker({ "Utility", "Custom range radiuses", "Preset 4" }, "Radius color", 255, 255, 255, 255)

local enableslider5 = Menu.AddOptionBool({ "Utility", "Custom range radiuses", "Preset 5" }, "Enable radius", false)
Menu.AddOptionIcon(enableslider5, "~/MenuIcons/enable/enable_ios.png")
local slider5 = Menu.AddOptionSlider({ "Utility", "Custom range radiuses", "Preset 5" }, "Radius range", 100, 5000, 100)
Menu.AddOptionIcon(slider5, "~/MenuIcons/edit.png")
local color5 = Menu.AddOptionColorPicker({ "Utility", "Custom range radiuses", "Preset 5" }, "Radius color", 255, 255, 255, 255)


function CRR.ClearRadiuses()
    if radiusparticle1 then
        Particle.Destroy(radiusparticle1)
        radiusparticle1 = nil
    end

    if radiusparticle2 then
        Particle.Destroy(radiusparticle2)
        radiusparticle2 = nil
    end

    if radiusparticle3 then
        Particle.Destroy(radiusparticle3)
        radiusparticle3 = nil
    end

    if radiusparticle4 then
        Particle.Destroy(radiusparticle4)
        radiusparticle4 = nil
    end

    if radiusparticle5 then
        Particle.Destroy(radiusparticle5)
        radiusparticle5 = nil
    end
end

function CRR.Init()
    CRR.ClearRadiuses()
    scriptEnable = true
    
    if not Menu.IsEnabled(enable) then
        scriptEnable = false
        return
    end
    if not Engine.IsInGame() then
        scriptEnable = false
        return
    end
    myPlayer = Players.GetLocal()
    if not myPlayer then
        scriptEnable = false
        return
    end
    myHero = Heroes.GetLocal()
    if not myHero then
        scriptEnable = false
        return
    end
end
CRR.Init()

function CRR.OnMenuOptionChange(option, oldValue, newValue)
    if option == enable then
        CRR.Init()
    elseif option == slider1 or option == color1 then
        if radiusparticle1 then
            Particle.Destroy(radiusparticle1)
            radiusparticle1 = nil

            local tempColor = Menu.GetValue(color1)
            if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                tempColor.r = 50
                tempColor.g = 50
                tempColor.b = 50
            end
            radiusparticle1 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
        	Particle.SetControlPoint(radiusparticle1, 0, Entity.GetAbsOrigin(myHero))
        	Particle.SetControlPoint(radiusparticle1, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
            Particle.SetControlPoint(radiusparticle1, 2, Vector(Menu.GetValue(slider1)*1.0923, 255, 255))
            Particle.SetControlPoint(radiusparticle1, 3, Vector(255 - tempColor.a, 0, 0))
        end
    elseif option == slider2 or option == color2 then    
        if radiusparticle2 then
            Particle.Destroy(radiusparticle2)
            radiusparticle2 = nil
            
            local tempColor = Menu.GetValue(color2)
            if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                tempColor.r = 50
                tempColor.g = 50
                tempColor.b = 50
            end
            radiusparticle2 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
            Particle.SetControlPoint(radiusparticle2, 0, Entity.GetAbsOrigin(myHero))
            Particle.SetControlPoint(radiusparticle2, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
            Particle.SetControlPoint(radiusparticle2, 2, Vector(Menu.GetValue(slider2)*1.0923, 255, 0))
            Particle.SetControlPoint(radiusparticle2, 3, Vector(255 - tempColor.a, 0, 0))
        end
    elseif option == slider3 or option == color3 then    
        if radiusparticle3 then
            Particle.Destroy(radiusparticle3)
            radiusparticle3 = nil
            
            local tempColor = Menu.GetValue(color3)
            if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                tempColor.r = 50
                tempColor.g = 50
                tempColor.b = 50
            end
            radiusparticle3 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
            Particle.SetControlPoint(radiusparticle3, 0, Entity.GetAbsOrigin(myHero))
            Particle.SetControlPoint(radiusparticle3, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
            Particle.SetControlPoint(radiusparticle3, 2, Vector(Menu.GetValue(slider3)*1.0923, 255, 0))    
            Particle.SetControlPoint(radiusparticle3, 3, Vector(255 - tempColor.a, 0, 0))
        end
    elseif option == slider4 or option == color4 then    
        if radiusparticle4 then
            Particle.Destroy(radiusparticle4)
            radiusparticle4 = nil
            
            local tempColor = Menu.GetValue(color4)
            if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                tempColor.r = 50
                tempColor.g = 50
                tempColor.b = 50
            end
            radiusparticle4 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
            Particle.SetControlPoint(radiusparticle4, 0, Entity.GetAbsOrigin(myHero))
            Particle.SetControlPoint(radiusparticle4, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
            Particle.SetControlPoint(radiusparticle4, 2, Vector(Menu.GetValue(slider4)*1.0923, 255, 0))
            Particle.SetControlPoint(radiusparticle4, 3, Vector(255 - tempColor.a, 0, 0))
        end
    elseif option == slider5 or option == color5 then    
        if radiusparticle5 then
            Particle.Destroy(radiusparticle5)
            radiusparticle5 = nil
            
            local tempColor = Menu.GetValue(color5)
            if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                tempColor.r = 50
                tempColor.g = 50
                tempColor.b = 50
            end
            radiusparticle5 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
            Particle.SetControlPoint(radiusparticle5, 0, Entity.GetAbsOrigin(myHero))
            Particle.SetControlPoint(radiusparticle5, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
            Particle.SetControlPoint(radiusparticle5, 2, Vector(Menu.GetValue(slider5)*1.0923, 255, 0))
            Particle.SetControlPoint(radiusparticle5, 3, Vector(255 - tempColor.a, 0, 0)) 
        end
    end
end

function CRR.OnDraw()
    if not scriptEnable then
        return
    end
    if not Entity.IsAlive(myHero) then
        CRR.ClearRadiuses()
        return
    end

    if Menu.IsEnabled(enable) then    
        if Menu.IsEnabled(enableslider1) then
            if not radiusparticle1 then
                local tempColor = Menu.GetValue(color1)
                if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                    tempColor.r = 50
                    tempColor.g = 50
                    tempColor.b = 50
                end
                radiusparticle1 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
                Particle.SetControlPoint(radiusparticle1, 0, Entity.GetAbsOrigin(myHero))
                Particle.SetControlPoint(radiusparticle1, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
                Particle.SetControlPoint(radiusparticle1, 2, Vector(Menu.GetValue(slider1)*1.0923, 255, 255))
                Particle.SetControlPoint(radiusparticle1, 3, Vector(255 - tempColor.a, 0, 0))
            else
                Particle.SetControlPoint(radiusparticle1, 0, Entity.GetAbsOrigin(myHero))
            end
        elseif radiusparticle1 then
            Particle.Destroy(radiusparticle1)
            radiusparticle1 = nil
        end

        if Menu.IsEnabled(enableslider2) then
            if not radiusparticle2 then
                local tempColor = Menu.GetValue(color2)
                if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                    tempColor.r = 50
                    tempColor.g = 50
                    tempColor.b = 50
                end
                radiusparticle2 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
                Particle.SetControlPoint(radiusparticle2, 0, Entity.GetAbsOrigin(myHero))
                Particle.SetControlPoint(radiusparticle2, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
                Particle.SetControlPoint(radiusparticle2, 2, Vector(Menu.GetValue(slider2)*1.0923, 255, 0))
                Particle.SetControlPoint(radiusparticle2, 3, Vector(255 - tempColor.a, 0, 0))
            else
                Particle.SetControlPoint(radiusparticle2, 0, Entity.GetAbsOrigin(myHero))
            end
        elseif radiusparticle2 then
            Particle.Destroy(radiusparticle2)
            radiusparticle2 = nil
        end

        if Menu.IsEnabled(enableslider3) then
            if not radiusparticle3 then
                local tempColor = Menu.GetValue(color3)
                if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                    tempColor.r = 50
                    tempColor.g = 50
                    tempColor.b = 50
                end
                radiusparticle3 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
                Particle.SetControlPoint(radiusparticle3, 0, Entity.GetAbsOrigin(myHero))
                Particle.SetControlPoint(radiusparticle3, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
                Particle.SetControlPoint(radiusparticle3, 2, Vector(Menu.GetValue(slider3)*1.0923, 255, 0))
                Particle.SetControlPoint(radiusparticle3, 3, Vector(255 - tempColor.a, 0, 0))
            else
                Particle.SetControlPoint(radiusparticle3, 0, Entity.GetAbsOrigin(myHero))
            end
        elseif radiusparticle3 then
            Particle.Destroy(radiusparticle3)
            radiusparticle3 = nil
        end

        if Menu.IsEnabled(enableslider4) then
            if not radiusparticle4 then
                local tempColor = Menu.GetValue(color4)
                if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                    tempColor.r = 50
                    tempColor.g = 50
                    tempColor.b = 50
                end
                radiusparticle4 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
                Particle.SetControlPoint(radiusparticle4, 0, Entity.GetAbsOrigin(myHero))
                Particle.SetControlPoint(radiusparticle4, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
                Particle.SetControlPoint(radiusparticle4, 2, Vector(Menu.GetValue(slider4)*1.0923, 255, 0))
                Particle.SetControlPoint(radiusparticle4, 3, Vector(255 - tempColor.a, 0, 0))
            else
                Particle.SetControlPoint(radiusparticle4, 0, Entity.GetAbsOrigin(myHero))
            end
        elseif radiusparticle4 then
            Particle.Destroy(radiusparticle4)
            radiusparticle4 = nil
        end

        if Menu.IsEnabled(enableslider5) then
            if not radiusparticle5 then
                local tempColor = Menu.GetValue(color5)
                if (tempColor.r < 50) and (tempColor.g < 50) and (tempColor.b < 50) then
                    tempColor.r = 50
                    tempColor.g = 50
                    tempColor.b = 50
                end
                radiusparticle5 = Particle.Create("particles\\ui_mouseactions\\drag_selected_ring.vpcf")
                Particle.SetControlPoint(radiusparticle5, 0, Entity.GetAbsOrigin(myHero))
                Particle.SetControlPoint(radiusparticle5, 1, Vector(tempColor.r, tempColor.g, tempColor.b))
                Particle.SetControlPoint(radiusparticle5, 2, Vector(Menu.GetValue(slider5)*1.0923, 255, 0))
                Particle.SetControlPoint(radiusparticle5, 3, Vector(255 - tempColor.a, 0, 0))
            else
                Particle.SetControlPoint(radiusparticle5, 0, Entity.GetAbsOrigin(myHero))
            end
        elseif radiusparticle5 then
            Particle.Destroy(radiusparticle5)
            radiusparticle5 = nil
        end
    else 
        CRR.ClearRadiuses()
    end
end

function CRR.OnUpdate()
	if not scriptEnable then
        return
    end

	if Menu.IsKeyDownOnce(ToggleKey) then
		if Menu.IsEnabled(enableslider1) == true then
			Menu.SetEnabled(enableslider1, false)
		else 
			Menu.SetEnabled(enableslider1, true)
		end		
	end

	if Menu.IsKeyDownOnce(ToggleKey2) then
		if Menu.IsEnabled(enableslider2) == true then
			Menu.SetEnabled(enableslider2, false)
		else 
			Menu.SetEnabled(enableslider2, true)
		end		
	end
end 

return CRR