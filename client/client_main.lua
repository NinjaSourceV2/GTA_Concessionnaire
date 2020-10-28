local Duree = 0
local vConcessPos, vehPos, secondVehPos, vehZone, monVeh = nil, nil, nil, nil, nil

--> Permet au joueur d'utilisé le véhicule.
RegisterNetEvent("GTA_Concess:PaiementEffectuer") 
AddEventHandler("GTA_Concess:PaiementEffectuer", function(index, id, veh, model, platecaissei, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    local headingVeh = GetEntityHeading(veh)

    --> Refresh pour la table : 
    vConcessPos = Config.Locations[index]["Concess"]["VehPos"]
    vConcessPos[id] = nil

    --> Fake véhicule : 
    FreezeEntityPosition(veh, false)
    SetEntityAsMissionEntity(veh, true, true)
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
    
    --> Nouveau Véhicule :
    if playerPed ~= -1 then
        RequestModel(model)
        
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        personnalVeh = CreateVehicle(model, playerCoords, headingVeh, true, false)
        SetVehicleNumberPlateText(personnalVeh, platecaissei)
        SetVehicleColours(personnalVeh, tonumber(primarycolor), tonumber(secondarycolor))
        SetVehicleExtraColours(personnalVeh, tonumber(pearlescentcolor), tonumber(wheelcolor))
        TaskWarpPedIntoVehicle(playerPed, personnalVeh, -1)
    end
end)

--> Permet de faire spawn les véhicules au démarrage du serveur.
local function spawnVeh()
    Citizen.CreateThread(function()        
        for i = 1, #Config.Locations do 
            vConcessPos = Config.Locations[i]["Concess"]["VehPos"]
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

            for _, v in pairs(vConcessPos) do
                local dist = GetDistanceBetweenCoords(plyCoords, v["x"], v["y"], v["z"], true)

                RequestModel(v["Model"])
                while not HasModelLoaded(v["Model"]) do
                    Wait(0)
                end

                monVeh = CreateVehicle(v["Model"], v["x"], v["y"], v["z"], v["h"], false, false)
            end
        end
        Citizen.Wait(Duree)
    end)
end
spawnVeh()


--> Permet de draw le prix + le model.
local function StatsCar(x,y,z,zone, model, prix) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    
    if onScreen then
        DrawRect(x,y, 0.185, 0.150, 0, 0, 0, 200)
        DrawAdvancedText2(x,y, 0.005, 0.0028, 0.7, zone, 255, 255, 255, 255, 1, 1)
        
        DrawAdvancedText2(_x, 0.375, 0.005, 0.0028, 0.3, "MODEL : ~b~" ..model, 255, 255, 255, 255, 0, 1)
        DrawAdvancedText2(_x, 0.400, 0.005, 0.0028, 0.3, "PRIX  : ~g~" ..prix .. "$", 255, 255, 255, 255, 0, 1)
    end
end


--> Ici on gére le process de la vente.
Citizen.CreateThread(function()
    while true do
        Duree = 250
        for i = 1, #Config.Locations do
            secondVehPos = Config.Locations[i]["Concess"]["VehPos"]
            vehZone = Config.Locations[i]["Concess"]["NomZone"]
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)

            for k, v in pairs(secondVehPos) do
                local dist = GetDistanceBetweenCoords(plyCoords, v["x"], v["y"], v["z"], true)
        
                if dist <= 15 then
                    Duree = 0
                    StatsCar(v["x"], v["y"], v["z"], vehZone, v["NomVehicule"], v["Prix"])

                    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
                        local model = GetEntityModel(veh)
                        local platecaissei = GetVehicleNumberPlateText(veh)
                        local colors = table.pack(GetVehicleColours(veh))
                        local extra_colors = table.pack(GetVehicleExtraColours(veh))
                        local primarycolor = colors[1]
                        local secondarycolor = colors[2]
                        local pearlescentcolor = extra_colors[1]
                        local wheelcolor = extra_colors[2]

                        if dist <= 2 then
                            if model == v["Model"] then
                                FreezeEntityPosition(veh, true)

                                if GetLastInputMethod(0) then
                                    Ninja_Core__DisplayHelpAlert("~INPUT_PICKUP~ pour ~g~payé~w~ le véhicule.")
                                else
                                    Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_EXTRA_OPTION~ pour ~g~payé~w~ le véhicule.")
                                end

                                if (IsControlJustReleased(0, 38) or IsControlJustReleased(0, 179)) then
                                    TriggerServerEvent("GTA_Concess:PayerVehicule", v["Prix"], i, k, veh, "Mon Véhicule", model, platecaissei, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(Duree)
	end
end)


--> permet l'affichage des blip sur la map.
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