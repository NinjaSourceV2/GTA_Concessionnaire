local Duree = 0
local vehPos, secondVehPos, vehZone = nil, nil, nil
local oldSpawned = {}

--> Création des véhicule :
Citizen.CreateThread(function()
    spawnVeh()
end)

--> Permet au joueur d'utilisé le véhicule.
RegisterNetEvent("GTA_Concess:PaiementEffectuer") 
AddEventHandler("GTA_Concess:PaiementEffectuer", function(headingVeh, model, platecaissei, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, itemname, itemid, prix)
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    
    --> Nouveau Véhicule :
    RequestModel(model)
    
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local personnalVeh = CreateVehicle(model, playerCoords, headingVeh, true, false)
    SetVehicleNumberPlateText(personnalVeh, platecaissei)
    SetVehicleColours(personnalVeh, tonumber(primarycolor), tonumber(secondarycolor))
    SetVehicleExtraColours(personnalVeh, tonumber(pearlescentcolor), tonumber(wheelcolor))
    TaskWarpPedIntoVehicle(playerPed, personnalVeh, -1)

    TriggerServerEvent("GTA:PaiementCash", itemname, itemid, prix)
    TriggerServerEvent("garages:CreerNouvelCles", platecaissei)
    TriggerServerEvent("GTA_Garage:RequestNewCles") --> Update keys list.
    --TriggerServerEvent("GTA-Coffre:InitPlate", platecaissei)
end)


--> Permet de supprimer le véhicule en instance pour tout les joueurs.
RegisterNetEvent("GTA_Concess:DeleteCarForAll") 
AddEventHandler("GTA_Concess:DeleteCarForAll", function(index, id, model)
    for _, v in pairs(oldSpawned) do
        if (v.model == model) then 
            FreezeEntityPosition(v.vehicule, false)
            SetEntityAsMissionEntity(v.vehicule, true, true)
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v.vehicule))
            break
        end
    end

    --> Refresh pour la table : 
    local vConcessPos = Config.Locations[index]["Concess"]["VehPos"]
    vConcessPos[id] = nil
end)

--> Permet de faire spawn les véhicules au démarrage du serveur.
function spawnVeh()
    for i = 1, #Config.Locations do 
        local vConcessPos = Config.Locations[i]["Concess"]["VehPos"]
        for k, v in pairs(vConcessPos) do
            RequestModel(v["Model"])
            while not HasModelLoaded(v["Model"]) do
                Wait(0)
            end

            local veh = CreateVehicle(v["Model"], v["x"], v["y"], v["z"], v["h"])
            local model_veh = GetEntityModel(veh)
            table.insert(oldSpawned, {vehicule = veh, model = model_veh})
        end
    end
end

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
                        local headingVeh = GetEntityHeading(veh)
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
                                    TriggerEvent("GTA-Notification:InfoInteraction", "~INPUT_PICKUP~ pour ~g~payé~w~ le véhicule.")
                                else
                                    TriggerEvent("GTA-Notification:InfoInteraction", "~INPUT_CELLPHONE_EXTRA_OPTION~ pour ~g~payé~w~ le véhicule.")
                                end

                                if (IsControlJustReleased(0, 38) or IsControlJustReleased(0, 179)) then
                                    TriggerServerEvent("GTA_Concess:PayerVehicule", v["Prix"], i, k, headingVeh, "Mon Véhicule", model, platecaissei, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
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