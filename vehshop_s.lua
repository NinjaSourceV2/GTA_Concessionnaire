local maxVehiculeGarage = 7

--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '1.2'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_Concessionnaire/master/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_Concessionnaire]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)

RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(name, vehicle, price)
	local source = source
	TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
		local argentPropre = data.argent_propre
        local price = tonumber(price)
		exports.ghmattimysql:execute("SELECT * FROM gta_joueurs_vehicle WHERE identifier = @username",
		{ ['@username'] = GetPlayerIdentifiers(source)[1] }, function(result)
			if (result) then
				if #result >= maxVehiculeGarage then
					TriggerClientEvent('nMenuNotif:showNotification', source, "Votre garage est ~r~complet~w~, veuillez revendre un véhicule.")
				else
					if (tonumber(argentPropre) >= tonumber(price)) then
						TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(price))
						TriggerClientEvent('FinishMoneyCheckForVeh', source, name, vehicle, tonumber(price))
						TriggerClientEvent('nMenuNotif:showNotification', source, "~g~Paiement accepté~w~.")
					else
						TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Paiement refuser~w~.")
					end
				end
			else
				if (tonumber(argentPropre) >= tonumber(price)) then
					TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(price))
					TriggerClientEvent('FinishMoneyCheckForVeh', source, name, vehicle, tonumber(price))
					TriggerClientEvent('nMenuNotif:showNotification', source, "~g~Paiement accepté~w~.")
				else
					TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Paiement refuser~w~.")
				end
			end
		end)
    end)
end)

RegisterServerEvent('BuyForVeh')
AddEventHandler('BuyForVeh', function(name, vehicle, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
	local source = source
	local license = GetPlayerIdentifiers(source)[1]
	local name = name
	local vehicle = vehicle
	local plate = plate
	local state = "Sortit"
	local primarycolor = primarycolor
	local secondarycolor = secondarycolor
	local pearlescentcolor = pearlescentcolor
	local wheelcolor = wheelcolor
	local valeurs = { license, name, vehicle, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor }
	exports.ghmattimysql:execute('INSERT INTO gta_joueurs_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_plate`, `vehicle_state`, `vehicle_colorprimary`, `vehicle_colorsecondary`, `vehicle_pearlescentcolor`, `vehicle_wheelcolor`) VALUES ?', { { valeurs } })
end)