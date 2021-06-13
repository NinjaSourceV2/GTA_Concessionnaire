--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '2.1'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_Concessionnaire/master/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_Concessionnaire]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)

RegisterServerEvent("GTA_Concess:PayerVehicule")
AddEventHandler("GTA_Concess:PayerVehicule", function(prix, index, id, headingVeh, newVehicleNom, model, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
    local source = source
    local identifier = GetPlayerIdentifiers(source)[1]

    TriggerEvent('GTA:GetIdentityPlayer', source, function(data)
        TriggerEvent('GTA_Inventaire:GetItemQty', source, "cash", function(qtyItem, itemid)
            local nom = data["nom"]
            local prenom = data["prenom"]
            local proprietaire = (nom .. " " ..prenom) 

            if (qtyItem >= prix) then
                TriggerClientEvent("GTA_Concess:DeleteCarForAll", -1, index, id, model)
                TriggerClientEvent("GTA_Concess:PaiementEffectuer", source, headingVeh, model, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, "cash", itemid, prix)
                local value = {identifier, newVehicleNom, model, plate, "Sortit", primarycolor, secondarycolor, pearlescentcolor, wheelcolor, proprietaire, prix}
                MySQL.Sync.execute('INSERT INTO gta_joueurs_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_plate`, `vehicle_state`, `vehicle_colorprimary`, `vehicle_colorsecondary`, `vehicle_pearlescentcolor`, `vehicle_wheelcolor`, `proprietaire`, `prix`) VALUES ?', { { value } })
            else
				TriggerClientEvent("GTAO:NotificationIcon", source, "CHAR_BANK_MAZE", "Maze Bank", "Pas assez de fond.", "Paiement refuser")
            end
        end)
    end)
end)