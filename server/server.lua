--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '1.8'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_Concessionnaire/master/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_Concessionnaire]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)

RegisterServerEvent("GTA_Concess:PayerVehicule")
AddEventHandler("GTA_Concess:PayerVehicule", function(prix, index, id, veh, newVehicleNom, model, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
    local source = source
    TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
        local identifier = GetPlayerIdentifiers(source)[1]
        local cash = data.argent_propre
        local nom = data.nom
        local prenom = data.prenom
        local proprietaire = (nom .. " " ..prenom) 

        if (tonumber(cash) >= prix) then
            TriggerClientEvent("GTA_Concess:PaiementEffectuer", source, index, id, veh, model, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
            TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(prix))
            local value = {identifier, newVehicleNom, model, plate, "Sortit", primarycolor, secondarycolor, pearlescentcolor, wheelcolor, proprietaire, prix}

            MySQL.Sync.execute('INSERT INTO gta_joueurs_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_plate`, `vehicle_state`, `vehicle_colorprimary`, `vehicle_colorsecondary`, `vehicle_pearlescentcolor`, `vehicle_wheelcolor`, `proprietaire`, `prix`) VALUES ?', { { value } })
			TriggerClientEvent('nMenuNotif:showNotification', source, "~g~Paiement accepter~w~.")
		else
			TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Tu n'as pas suffisamment d'argent !")
		end
    end)
end)