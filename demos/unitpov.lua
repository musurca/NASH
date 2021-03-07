function Color_Lerp_RGB(c0, c1, t)
    local inv_t = 1-t
    return {
        c0[1]*inv_t + c1[1]*t,
        c0[2]*inv_t + c1[2]*t,
        c0[3]*inv_t + c1[3]*t,
        255
    }
end

function UnitPOV(view_angle)
    local unit
    local sel_units = ScenEdit_SelectedUnits().units
    if #sel_units > 0 then
        unit =  ScenEdit_GetUnit({guid=sel_units[1].guid})
    else
        return
    end

    local look_dir = unit.heading
    local look_start = (look_dir - view_angle/2) % (360)
    local unit_location = World_GetLocation ({latitude=unit.latitude,longitude=unit.longitude})
    local unit_height = math.max(0, math.max(unit.altitude, unit_location.altitude)) + 5

    local steps = 60
    local dist_per_step = 1/6

    local canvas = NASH:New(640, 300)
    canvas:Clear(RGB(60, 60, 200))
    local prev_heights = {}
    local prev_slopes = {}
    for i=0,canvas.width-1 do
        local cur_height = -0.00001
        local last_height = cur_height
        local cur_y = canvas.height
        for j=1,steps do
            local dist = j*dist_per_step
            local pt = World_GetPointFromBearing({latitude=unit.latitude, longitude=unit.longitude, bearing=look_start, distance=dist})
            local location = World_GetLocation (pt)
            local elevation
            if location.altitude then
                elevation = math.max(0, location.altitude)
            else
                elevation = 0
            end
            local height, slope
            if not prev_heights[j] then
                height = 0.2*elevation + 0.8*last_height
                if location.slope then
                    slope = location.slope
                else
                    slope = 0
                end
            else
                height = 0.4*prev_heights[j] + 0.2*elevation + 0.4*last_height
                if location.slope then
                    slope = 0.8*prev_slopes[j] + 0.2*location.slope
                else
                    slope = 0
                end
            end
            prev_heights[j] = height
            prev_slopes[j] = slope

            local y_coord = math.floor(canvas.height/2 - (height - unit_height) / dist)
            if y_coord < cur_y then
                local fog_term = 1/math.exp(0.3*dist)
                local ground_type
                if location.cover then
                    if not string.find(location.cover.text, "Water") then
                        if string.find(location.cover.text, "Urban") then
                            ground_type = "URBAN"
                        elseif string.find(location.cover.text, "Grasslands") or string.find(location.cover.text, "Croplands") or string.find(location.cover.text, "Forest") then
                            ground_type = "VERDANT"
                        elseif string.find(location.cover.text, "Snow") then
                            ground_type = "SNOW"
                        else
                            ground_type = "LAND"
                        end
                    else
                        ground_type = "WATER"
                    end
                else
                    ground_type = "WATER"
                end
                local base_color 
                if ground_type ~= "WATER" then
                    local ground_color_dark, ground_color_bright
                    if ground_type == "URBAN" then
                        ground_color_dark, ground_color_bright = RGB(127, 127, 127), RGB(200, 200, 200)
                    elseif ground_type == "VERDANT" then
                        ground_color_dark, ground_color_bright = RGB(0, 127, 0), RGB(0, 200, 0)
                    elseif ground_type == "SNOW" then
                        ground_color_dark, ground_color_bright = RGB(200, 200, 200), RGB(255, 255, 255)
                    else
                        ground_color_dark, ground_color_bright = RGB(127, 64, 0), RGB(255,127,20)
                    end
                    base_color = Color_Lerp_RGB(ground_color_dark, ground_color_bright, 1-slope/100)
                else
                    base_color = RGB(0, 0, 255)
                end
                canvas:VertLine(i, y_coord, cur_y, Color_Lerp_RGB(base_color, RGB(60, 60, 200), 1-fog_term) )
                cur_y = y_coord
                cur_height = height
                if cur_y <= 0 then
                    break
                end
            end
            last_height = height
        end
        look_start = (look_dir - view_angle/2 + i*view_angle/canvas.width) % 360
    end

    local left_dir = math.floor((look_dir-view_angle/2)+0.5) % 360
    local center_dir = math.floor(look_dir+0.5) % 360
    local right_dir = math.floor((look_dir+view_angle/2)+0.5) % 360

    canvas:Print(tostring(left_dir), 5, 5, RGB(255, 255, 255))
    canvas:Print(tostring(center_dir), canvas.width/2, 5, RGB(255, 255, 255), NASH.ALIGN_CENTER)
    canvas:Print(tostring(right_dir), canvas.width-5, 5, RGB(255, 255, 255), NASH.ALIGN_RIGHT)
    canvas:Print("Max dist: "..(steps*dist_per_step).." nm", 5, canvas.height-12, RGB(255, 255, 255))

    canvas:HorizLine(0, canvas.height/2, 10, RGB(255, 255, 255))

    ScenEdit_SpecialMessage("playerside", canvas:Render() )
end

UnitPOV(90)