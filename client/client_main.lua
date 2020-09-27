local vehiculeInfo = {
    zone = nil,
    veh = nil,
    ConcessPos = nil
}

local Duree = 0

local function InputText()
    local text = ""
    
	AddTextEntry('text', "Nouveau nom : ")
    DisplayOnscreenKeyboard(1, "text", "", "", "", "", "", 20)

    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(10)
    end

    if (GetOnscreenKeyboardResult()) then
        text = GetOnscreenKeyboardResult()
    end

    return text
end

local Ninja_Core__DisplayHelpAlert = function(msg)
	BeginTextCommandDisplayHelp("STRING");  
    AddTextComponentSubstringPlayerName(msg);  
    EndTextCommandDisplayHelp(0, 0, 1, -1);
end

RegisterNetEvent("GTA_Concess:PaiementEffectuer")
AddEventHandler("GTA_Concess:PaiementEffectuer", function(id, veh)
    for i = 1, #Config.Locations do 
        vehiculeInfo.ConcessPos = Config.Locations[i]["Concess"]["VehPos"]
        vehiculeInfo.ConcessPos[id] = nil
        SetVehicleUndriveable(veh, 0)
    end
end)

local function DrawAdvancedText2(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end

local function StatsCar(x,y,z,text,zone, model, prix)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    
    if onScreen then
        DrawRect(x,y, 0.185, 0.150, 0, 0, 0, 200)
        DrawAdvancedText2(x,y, 0.005, 0.0028, 0.7, zone, 255, 255, 255, 255, 1, 1)
        
        DrawAdvancedText2(_x, 0.375, 0.005, 0.0028, 0.3, "MODEL : ~b~" ..model, 255, 255, 255, 255, 0, 1)
        DrawAdvancedText2(_x, 0.400, 0.005, 0.0028, 0.3, "PRIX  : ~g~" ..prix .. "$", 255, 255, 255, 255, 0, 1)
    end
end

local function spawnVeh()
    Citizen.CreateThread(function()		
        Citizen.Wait(Duree)
        for i = 1, #Config.Locations do 
            vehiculeInfo.ConcessPos = Config.Locations[i]["Concess"]["VehPos"]
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

            for _, v in pairs(vehiculeInfo.ConcessPos) do
                local dist = GetDistanceBetweenCoords(plyCoords, v["x"], v["y"], v["z"], true)

                RequestModel(v["Model"])
                while not HasModelLoaded(v["Model"]) do
                    Wait(0)
                end

                vehiculeInfo.veh = CreateVehicle(v["Model"], v["x"], v["y"], v["z"], v["h"], true, false)
                SetVehicleUndriveable(vehiculeInfo.veh, 1)
            end
        end
    end)
end
spawnVeh()

Citizen.CreateThread(function()
    while true do
        Duree = 250
        for i = 1, #Config.Locations do
            vehiculeInfo.ConcessPos = Config.Locations[i]["Concess"]["VehPos"]
            vehiculeInfo.zone = Config.Locations[i]["Concess"]["NomZone"]
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

            for k, v in pairs(vehiculeInfo.ConcessPos) do
                local dist = GetDistanceBetweenCoords(plyCoords, v["x"], v["y"], v["z"], true)
        
                if dist <= 20 then
                    Duree = 0
                    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
                    local model = GetEntityModel(veh)
                    local platecaissei = GetVehicleNumberPlateText(veh)
                    local colors = table.pack(GetVehicleColours(veh))
                    local extra_colors = table.pack(GetVehicleExtraColours(veh))
                    local primarycolor = colors[1]
                    local secondarycolor = colors[2]
                    local pearlescentcolor = extra_colors[1]
                    local wheelcolor = extra_colors[2]

                    StatsCar(v["x"], v["y"], v["z"], 'TEST', vehiculeInfo.zone, v["NomVehicule"], v["Prix"])

                    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        if model == v["Model"] then

                            if GetLastInputMethod(0) then
                                Ninja_Core__DisplayHelpAlert("~INPUT_PICKUP~ pour ~g~payé~w~ le véhicule.")
                            else
                                Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_EXTRA_OPTION~ pour ~g~payé~w~ le véhicule.")
                            end

                            if (IsControlJustReleased(0, 38) or IsControlJustReleased(0, 179)) then
                                TriggerServerEvent("GTA_Concess:PayerVehicule", v["Prix"], k, veh, "Mon Véhicule", model, platecaissei, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(Duree)
	end
end)

Citizen.CreateThread(function()
    for i = 1, #Config.Locations do
        local blip = Config.Locations[i]["Concess"]
        local blip_config = Config.Locations[i]["Concess"]

        blip = AddBlipForCoord(blip["x"], blip["y"], blip["z"])

        if blip_config["AfficherBlip"] == true then
            SetBlipSprite(blip, 524)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.9)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blip_config["NomZone"])
            EndTextCommandSetBlipName(blip)
        else
            RemoveBlip(blip)
        end
    end
end)