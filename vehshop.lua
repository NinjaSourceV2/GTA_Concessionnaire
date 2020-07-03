--[[Register]]--
local menuConfig = json.decode(LoadResourceFile(GetCurrentResourceName(), 'json/ConfigMenu.json'))
local scaleform = nil

local vehshop = {
	opened = false,
	title = "",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.1 + 0.03,
		y = 0.0 + 0.03,
		width = 0.2 + 0.02 + 0.005,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.3 + 0.05, --> Taille.
		font = 0,
		["main"] = {
			title = "Concessionnaire",
			name = "main",
			buttons = {
				{name = "Véhicule", description = ""},
				{name = "Motos", description = ""},
				{name = "Vélos", description = ""},
			}
		},
		["vehicles"] = {
			title = "Vehicule",
			name = "vehicles",
			buttons = {
				{name = "Compacts", description = ''},
				{name = "Coupes", description = ''},
				{name = "Sedans", description = ''},
				{name = "Sports", description = ''},
				{name = "Sports Classics", description = ''},
				{name = "Super", description = ''},
				{name = "Muscle", description = ''},
				{name = "Off-Road", description = ''},
				{name = "SUVs", description = ''},
				{name = "Vans", description = ''},
			}
		},
		["compacts"] = {
			title = "compacts",
			name = "compacts",
			buttons = {
				--{name = "Kalahari", costs = 0, description = {}, model = "kalahari"},
				{name = "Blista", costs = 15000, description = {}, model = "blista"},
				{name = "Blista Compact", costs = 42000, description = {}, model = "blista2"},
				{name = "Brioso R/A", costs = 155000, description = {}, model = "brioso"},
				{name = "Dilettante", costs = 25000, description = {}, model = "Dilettante"},
				{name = "Issi", costs = 18000, description = {}, model = "issi2"},
				{name = "Panto", costs = 85000, description = {}, model = "panto"},
				{name = "Prairie", costs = 30000, description = {}, model = "prairie"},
				{name = "Rhapsody", costs = 8000, description = {}, model = "rhapsody"},
			}
		},
		["coupes"] = {
			title = "coupes",
			name = "coupes",
			buttons = {
				{name = "Cognoscenti Cabrio", costs = 185000, description = {}, model = "cogcabrio"},
				{name = "Exemplar", costs = 205000, description = {}, model = "exemplar"},
				{name = "F620", costs = 80000, description = {}, model = "f620"},
				{name = "Felon", costs = 90000, description = {}, model = "felon"},
				{name = "Felon GT", costs = 95000, description = {}, model = "felon2"},
				{name = "Jackal", costs = 60000, description = {}, model = "jackal"},
				{name = "Oracle", costs = 80000, description = {}, model = "oracle"},
				{name = "Oracle XS", costs = 82000, description = {}, model = "oracle2"},
				{name = "Sentinel", costs = 95000, description = {}, model = "sentinel"},
				{name = "Sentinel XS", costs = 60000, description = {}, model = "sentinel2"},
				{name = "Windsor", costs = 450000, description = {}, model = "windsor"},
				{name = "Windsor Drop", costs = 475000, description = {}, model = "windsor2"},
				{name = "Zion", costs = 60000, description = {}, model = "zion"},
				{name = "Zion Cabrio", costs = 65000, description = {}, model = "zion2"},
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				{name = "9F", costs = 120000, description = {}, model = "ninef"},
				{name = "9F Cabrio", costs = 130000, description = {}, model = "ninef2"},
				{name = "Alpha", costs = 150000, description = {}, model = "alpha"},
				{name = "Banshee", costs = 200000, description = {}, model = "banshee"},
				{name = "Bestia GTS", costs = 610000, description = {}, model = "bestiagts"},
				{name = "Buffalo", costs = 35000, description = {}, model = "buffalo"},
				{name = "Buffalo S", costs = 96000, description = {}, model = "buffalo2"},
				{name = "Carbonizzare", costs = 195000, description = {}, model = "carbonizzare"},
				{name = "Comet", costs = 195000, description = {}, model = "comet2"},
				{name = "Coquette", costs = 138000, description = {}, model = "coquette"},
				{name = "Drift Tampa", costs = 995000, description = {}, model = "tampa2"},
				{name = "Elegy", costs = 700000, description = {}, model = "elegy2"},
				{name = "Feltzer", costs = 130000, description = {}, model = "feltzer2"},
				{name = "Furore GT", costs = 448000, description = {}, model = "furoregt"},
				{name = "Fusilade", costs = 36000, description = {}, model = "fusilade"},
				{name = "Jester", costs = 240000, description = {}, model = "jester"},
				{name = "Kuruma", costs = 95000, description = {}, model = "kuruma"},
				{name = "Lynx", costs = 1735000, description = {}, model = "lynx"},
				{name = "Massacro", costs = 275000, description = {}, model = "massacro"},
				{name = "Omnis", costs = 500000, description = {}, model = "omnis"},
				{name = "Penumbra", costs = 24000, description = {}, model = "penumbra"},
				{name = "Rapid GT", costs = 140000, description = {}, model = "rapidgt"},
				{name = "Rapid GT Convertible", costs = 150000, description = {}, model = "rapidgt2"},
				{name = "Schafter V12", costs = 116000, description = {}, model = "schafter3"},
				{name = "Sultan", costs = 120000, description = {}, model = "sultan"},
				{name = "Surano", costs = 110000, description = {}, model = "surano"},
				{name = "Tropos", costs = 816000, description = {}, model = "tropos"},
				{name = "Verkierer", costs = 695000, description = {}, model = "verlierer2"},
			}
		},
		["sportsclassics"] = {
			title = "sports classics",
			name = "sportsclassics",
			buttons = {
				{name = "Casco", costs = 680000, description = {}, model = "casco"},
				{name = "Cheetah Classic", costs = 865000, description = {}, model = "cheetah2"},
				{name = "Coquette Classic", costs = 665000, description = {}, model = "coquette2"},
				{name = "Infernus Classic", costs = 915000, description = {}, model = "infernus2"},
				{name = "JB 700", costs = 450000, description = {}, model = "jb700"},
				{name = "Mamba", costs = 995000, description = {}, model = "mamba"},
				{name = "Pigalle", costs = 300000, description = {}, model = "pigalle"},
				{name = "Stinger", costs = 850000, description = {}, model = "stinger"},
				{name = "Stinger GT", costs = 875000, description = {}, model = "stingergt"},
				{name = "Stirling GT", costs = 975000, description = {}, model = "feltzer3"},
				{name = "Torero", costs = 998000, description = {}, model = "torero"},
				{name = "Z-Type", costs = 1000000, description = {}, model = "ztype"},
			}
		},
		["super"] = {
			title = "super",
			name = "super",
			buttons = {
				{name = "Adder", costs = 1000000, description = {}, model = "adder"},
				{name = "Banshee 900R", costs = 565000, description = {}, model = "banshee2"},
				{name = "Bullet", costs = 350000, description = {}, model = "bullet"},
				{name = "Cheetah", costs = 650000, description = {}, model = "cheetah"},
				{name = "Entity XF", costs = 795000, description = {}, model = "entityxf"},
				{name = "ETR1", costs = 350000, description = {}, model = "sheava"},
				{name = "FMJ", costs = 1750000, description = {}, model = "fmj"},
				{name = "GP1", costs = 1260000, description = {}, model = "gp1"},
				{name = "Infernus", costs = 440000, description = {}, model = "infernus"},
				{name = "Itali GTB", costs = 1189000, description = {}, model = "italigtb"},
				{name = "Nero", costs = 1440000, description = {}, model = "nero"},
				{name = "Osiris", costs = 1950000, description = {}, model = "osiris"},
				{name = "RE-7B", costs = 2475000, description = {}, model = "le7b"},
				{name = "Reaper", costs = 1595000, description = {}, model = "reaper"},
				{name = "Sultan RS", costs = 795000, description = {}, model = "sultanrs"},
				{name = "T20", costs = 2200000, description = {}, model = "t20"},
				{name = "Turismo Classic", costs = 705000, description = {}, model = "turismo2"},
				{name = "Turismo R", costs = 500000, description = {}, model = "turismor"},
				{name = "Tyrus", costs = 2550000, description = {}, model = "tyrus"},
				{name = "Vacca", costs = 240000, description = {}, model = "vacca"},
				{name = "Voltic", costs = 500000, description = {}, model = "voltic"},
				{name = "X80 Proto", costs = 2700000, description = {}, model = "prototipo"},
				{name = "Zentorno", costs = 1000000, description = {}, model = "zentorno"},
			}
		},
		["muscle"] = {
			title = "muscle",
			name = "muscle",
			buttons = {
				{name = "Blade", costs = 160000, description = {}, model = "blade"},
				{name = "Buccaneer", costs = 29000, description = {}, model = "buccaneer"},
				{name = "Chino", costs = 225000, description = {}, model = "chino"},
				{name = "Coquette BlackFin", costs = 695000, description = {}, model = "coquette3"},
				{name = "Dominator", costs = 35000, description = {}, model = "dominator"},
				{name = "Dukes", costs = 62000, description = {}, model = "dukes"},
				{name = "Gauntlet", costs = 32000, description = {}, model = "gauntlet"},
				{name = "Hotknife", costs = 120000, description = {}, model = "hotknife"},
				{name = "Faction", costs = 36000, description = {}, model = "faction"},
				{name = "Nightshade", costs = 585000, description = {}, model = "nightshade"},
				{name = "Picador", costs = 9000, description = {}, model = "picador"},
				{name = "Sabre Turbo", costs = 15000, description = {}, model = "sabregt"},
				{name = "Tampa", costs = 300000, description = {}, model = "tampa"},
				{name = "Virgo", costs = 195000, description = {}, model = "virgo"},
				{name = "Vigero", costs = 21000, description = {}, model = "vigero"},
			}
		},
		["offroad"] = {
			title = "off-road",
			name = "off-road",
			buttons = {
				{name = "Bifta", costs = 75000, description = {}, model = "bifta"},
				{name = "Blazer", costs = 8000, description = {}, model = "blazer"},
				{name = "Brawler", costs = 715000, description = {}, model = "brawler"},
				{name = "Dubsta 6x6", costs = 249000, description = {}, model = "dubsta3"},
				{name = "Dune Buggy", costs = 20000, description = {}, model = "dune"},
				{name = "Rebel", costs = 22000, description = {}, model = "rebel2"},
				{name = "Sandking", costs = 38000, description = {}, model = "sandking"},
				{name = "The Liberator", costs = 650000, description = {}, model = "monster"},
				{name = "Trophy Truck", costs = 550000, description = {}, model = "trophytruck"},
			}
		},
		["suvs"] = {
			title = "suvs",
			name = "suvs",
			buttons = {
				{name = "Baller", costs = 90000, description = {}, model = "baller"},
				{name = "Cavalcade", costs = 60000, description = {}, model = "cavalcade"},
				{name = "Grabger", costs = 35000, description = {}, model = "granger"},
				{name = "Huntley S", costs = 195000, description = {}, model = "huntley"},
				{name = "Landstalker", costs = 58000, description = {}, model = "landstalker"},
				{name = "Radius", costs = 32000, description = {}, model = "radi"},
				{name = "Rocoto", costs = 85000, description = {}, model = "rocoto"},
				{name = "Seminole", costs = 30000, description = {}, model = "seminole"},
				{name = "XLS", costs = 253000, description = {}, model = "xls"},
			}
		},
		["vans"] = {
			title = "vans",
			name = "vans",
			buttons = {
				{name = "Bison", costs = 30000, description = {}, model = "bison"},
				{name = "Bobcat XL", costs = 23000, description = {}, model = "bobcatxl"},
				{name = "Gang Burrito", costs = 65000, description = {}, model = "gburrito"},
				{name = "Journey", costs = 15000, description = {}, model = "journey"},
				{name = "Minivan", costs = 30000, description = {}, model = "minivan"},
				{name = "Paradise", costs = 25000, description = {}, model = "paradise"},
				{name = "Rumpo", costs = 13000, description = {}, model = "rumpo"},
				{name = "Surfer", costs = 11000, description = {}, model = "surfer"},
				{name = "Youga", costs = 16000, description = {}, model = "youga"},
			}
		},
		["sedans"] = {
			title = "sedans",
			name = "sedans",
			buttons = {
				{name = "Asea", costs = 12000, description = {}, model = "asea"},
				{name = "Asterope", costs = 26000, description = {}, model = "asterope"},
				{name = "Fugitive", costs = 24000, description = {}, model = "fugitive"},
				{name = "Glendale", costs = 200000, description = {}, model = "glendale"},
				{name = "Ingot", costs = 9000, description = {}, model = "ingot"},
				{name = "Intruder", costs = 16000, description = {}, model = "intruder"},
				{name = "Premier", costs = 10000, description = {}, model = "premier"},
				{name = "Primo", costs = 9000, description = {}, model = "primo"},
				{name = "Primo Custom", costs = 400000, description = {}, model = "primo2"},
				{name = "Regina", costs = 8000, description = {}, model = "regina"},
				{name = "Schafter", costs = 65000, description = {}, model = "schafter2"},
				{name = "Stanier", costs = 10000, description = {}, model = "stanier"},
				{name = "Stratum", costs = 10000, description = {}, model = "stratum"},
				{name = "Stretch", costs = 300000, description = {}, model = "stretch"},
				{name = "Super Diamond", costs = 250000, description = {}, model = "superd"},
				{name = "Surge", costs = 38000, description = {}, model = "surge"},
				{name = "Tailgater", costs = 55000, description = {}, model = "tailgater"},
				{name = "Warrener", costs = 120000, description = {}, model = "warrener"},
				{name = "Washington", costs = 15000, description = {}, model = "washington"},
			}
		},
		["motorcycles"] = {
			title = "Motos",
			name = "motorcycles",
			buttons = {
				{name = "Akuma", costs = 9000, description = {}, model = "AKUMA"},
				{name = "Avarus", costs = 425000, description = {}, model = "avarus"},
				{name = "Bagger", costs = 16000, description = {}, model = "bagger"},
				{name = "Bati 801", costs = 15000, description = {}, model = "bati"},
				{name = "Bati 801RR", costs = 15000, description = {}, model = "bati2"},
				{name = "BF400", costs = 95000, description = {}, model = "bf400"},
				{name = "Carbon RS", costs = 40000, description = {}, model = "carbonrs"},
				{name = "Chimera", costs = 600000, description = {}, model = "chimera"},
				{name = "Cliffhanger", costs = 225000, description = {}, model = "cliffhanger"},
				{name = "Daemon", costs = 145000, description = {}, model = "daemon"},
				{name = "Double T", costs = 12000, description = {}, model = "double"},
				{name = "Enduro", costs = 48000, description = {}, model = "enduro"},
				{name = "Faggio", costs = 5000, description = {}, model = "faggio2"},
				{name = "Gargoyle", costs = 120000, description = {}, model = "gargoyle"},
				{name = "Hakuchou", costs = 182000, description = {}, model = "hakuchou"},
				{name = "Hexer", costs = 15000, description = {}, model = "hexer"},
				{name = "Innovation", costs = 92500, description = {}, model = "innovation"},
				{name = "Lectro", costs = 750000, description = {}, model = "lectro"},
				{name = "Nemesis", costs = 12000, description = {}, model = "nemesis"},
				{name = "Nightblade", costs = 100000, description = {}, model = "nightblade"},
				{name = "PCJ-600", costs = 9000, description = {}, model = "pcj"},
				{name = "Ruffian", costs = 9000, description = {}, model = "ruffian"},
				{name = "Sanchez", costs = 7000, description = {}, model = "sanchez"},
				{name = "Sanchez (Couleur)", costs = 8000, description = {}, model = "sanchez2"},
				{name = "Sovereign", costs = 90000, description = {}, model = "sovereign"},
				{name = "Thrust", costs = 75000, description = {}, model = "thrust"},
				{name = "Vader", costs = 9000, description = {}, model = "vader"},
				{name = "Vindicator", costs = 630000, description = {}, model = "vindicator"},
			}
		},
		["velos"] = {
			title = "Velos",
			name = "velos",
			buttons = {
				{name = "BMX", costs = 200, description = {}, model = "bmx"},
				{name = "Cruiser", costs = 200, description = {}, model = "cruiser"},
				{name = "Fixter", costs = 500, description = {}, model = "fixter"},
				{name = "Scorcher", costs = 500, description = {}, model = "scorcher"},
				{name = "Tribike", costs = 1000, description = {}, model = "tribike"},
				{name = "Tribike 2", costs = 1200, description = {}, model = "tribike2"},	
				{name = "Tribike 3", costs = 1500, description = {}, model = "tribike3"},					
			}
		},
	}
}

local fakecar = { model = '', car = nil }
local vehshop_locations = { { entering = { -33.803, -1102.322, 25.422 }, inside = { -46.56327, -1097.382, 25.99875, 120.1953 }, outside = { -31.849, -1090.648, 25.998, 322.345 } } }
local vehshop_blips = {}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0



--[[Functions]]--

function LocalPed()
    return GetPlayerPed(-1)
end

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function IsPlayerInRangeOfVehshop()
    return inrangeofvehshop
end

local Ninja_Core__DisplayHelpAlert = function(msg)
	BeginTextCommandDisplayHelp("STRING");  
    AddTextComponentSubstringPlayerName(msg);  
    EndTextCommandDisplayHelp(0, 0, 1, -1);
end

function ShowVehshopBlips(bool)
    if bool and #vehshop_blips == 0 then
        for station, pos in pairs(vehshop_locations) do
            local loc = pos
            pos = pos.entering
            local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
            -- 60 58 137
            SetBlipSprite(blip, 326)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Concessionnaire')
            EndTextCommandSetBlipName(blip)
            SetBlipColour(blip, 69)
            SetBlipAsShortRange(blip, true)
            SetBlipAsMissionCreatorBlip(blip, true)
            table.insert(vehshop_blips, { blip = blip, pos = loc })
        end
        Citizen.CreateThread(function()
            while #vehshop_blips > 0 do
                Citizen.Wait(0)
                local inrange = false
                for i, b in ipairs(vehshop_blips) do
                    DrawMarker(1, b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                    if vehshop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and GetDistanceBetweenCoords(b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], GetEntityCoords(LocalPed())) < 5 then
                        if GetLastInputMethod(0) then
                            Ninja_Core__DisplayHelpAlert("~INPUT_TALK~ pour accedez a la vente de ~b~véhicules")
                        else
                            Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour accedez a la vente de ~b~véhicules")
                        end
                        currentlocation = b
                        inrange = true
                    end
                end
                inrangeofvehshop = inrange
            end
        end)
    elseif bool == false and #vehshop_blips > 0 then
        for i, b in ipairs(vehshop_blips) do
            if DoesBlipExist(b.blip) then
                SetBlipAsMissionCreatorBlip(b.blip, false)
                Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
            end
        end
        vehshop_blips = {}
    end
end

function f(n)
    return n + 0.0001
end

function try(f, catch_f)
    local status, exception = pcall(f)
    if not status then
        catch_f(exception)
    end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
	scaleform = RequestScaleformMovie("mp_menu_glare")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
	end
	
	PushScaleformMovieFunction(scaleform, "initScreenLayout")
	PopScaleformMovieFunctionVoid()

    boughtcar = false
    local ped = LocalPed()
    local pos = currentlocation.pos.inside
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false)
    local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B, pos[1], pos[2], pos[3], Citizen.PointerValueFloat(), 0)
    SetEntityCoords(ped, pos[1], pos[2], g)
    SetEntityHeading(ped, pos[4])
    vehshop.currentmenu = "main"
    vehshop.opened = true
    vehshop.selectedbutton = 1
end

function CloseCreator(name, veh, price)
    Citizen.CreateThread(function()
        local ped = LocalPed()
        if not boughtcar then
            local pos = currentlocation.pos.entering
            SetEntityCoords(ped, pos[1], pos[2], pos[3])
            FreezeEntityPosition(ped, false)
            SetEntityVisible(ped, true)
        else
            local name = name
            local vehicle = veh
            local veh = GetVehiclePedIsUsing(ped)
            local model = GetEntityModel(veh)
            local colors = table.pack(GetVehicleColours(veh))
            local extra_colors = table.pack(GetVehicleExtraColours(veh))

            local mods = {}
            for i = 0, 24 do
                mods[i] = GetVehicleMod(veh, i)
            end
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
            local pos = currentlocation.pos.outside

            FreezeEntityPosition(ped, false)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            personalVehicle = CreateVehicle(model, pos[1], pos[2], pos[3], pos[4], true, false)
            SetModelAsNoLongerNeeded(model)
            for i, mod in pairs(mods) do
                SetVehicleModKit(personalVehicle, 0)
                SetVehicleMod(personalVehicle, i, mod)
            end
            SetVehicleOnGroundProperly(personalVehicle)
            local plate = GetVehicleNumberPlateText(personalVehicle)
            SetVehicleHasBeenOwnedByPlayer(personalVehicle, true)
            local id = NetworkGetNetworkIdFromEntity(personalVehicle)
            SetNetworkIdCanMigrate(id, true)
            Citizen.InvokeNative(0x629BFA74418D6239, Citizen.PointerValueIntInitialized(personalVehicle))
            SetVehicleColours(personalVehicle, colors[1], colors[2])
            SetVehicleExtraColours(personalVehicle, extra_colors[1], extra_colors[2])
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), personalVehicle, -1)
			TriggerEvent('garages:SetVehiculePerso', personalVehicle)
            SetEntityVisible(ped, true)
            local primarycolor = colors[1]
            local secondarycolor = colors[2]
            local pearlescentcolor = extra_colors[1]
            local wheelcolor = extra_colors[2]
            TriggerServerEvent('BuyForVeh', name, vehicle, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
        end
        vehshop.opened = false
        vehshop.menu.from = 1
        vehshop.menu.to = 10
    end)
end

function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)

	for i=1, #menuConfig do 
		if selected then
			SetTextColour(menuConfig[i].couleurTextSelectMenu.r, menuConfig[i].couleurTextSelectMenu.g, menuConfig[i].couleurTextSelectMenu.b, menuConfig[i].couleurTextSelectMenu.a)
		else
			SetTextColour(menuConfig[i].couleurTextMenu.r, menuConfig[i].couleurTextMenu.g, menuConfig[i].couleurTextMenu.b, menuConfig[i].couleurTextMenu.a)
		end

		if selected then
			DrawRect(x,y,menu.width,menu.height,menuConfig[i].couleurRectSelectMenu.r,menuConfig[i].couleurRectSelectMenu.g,menuConfig[i].couleurRectSelectMenu.b,menuConfig[i].couleurRectSelectMenu.a)
		else
			DrawRect(x,y,menu.width,menu.height,0,0,0,150)
		end
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end


function DrawTextMenu(fonteP, stringT, scale, posX, posY)
    SetTextFont(fonteP)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(stringT)
    DrawText(posX, posY)
end


function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(0)
	SetTextScale(0.4 + 0.008, 0.4 + 0.008)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	for i=1, #menuConfig do 
		DrawRect(x,y,menu.width,menu.height, menuConfig[i].couleurTopMenu.r, menuConfig[i].couleurTopMenu.g, menuConfig[i].couleurTopMenu.b, menuConfig[i].couleurTopMenu.a)
	end
	DrawTextMenu(1, txt, 0.8,menu.width - 0.4 / 2 + 0.1 + 0.005, y - menu.height/2 + 0.01, 255, 255, 255)
    DrawSprite("commonmenu", "interaction_bgd", x,y, menu.width,menu.height + 0.04 + 0.007, .0, 255, 255, 255, 255)
    DrawScaleformMovie(scaleform, 0.42 + 0.003,0.45, 0.9,0.9)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawTextMenu(0, txt, 0.4, menu.width - 0.4 / 2 + 0.1 + 0.09, y - menu.height/2 + 0.03 + 0.003, 255, 255, 255)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function DoesPlayerHaveVehicle(model, button, y, selected)
    local t = false
    if t then
        drawMenuRight("~b~PROPRIÉTAIRE", vehshop.menu.x, y, selected)
    else
        drawMenuRight(button.costs .. "~g~$", vehshop.menu.x, y, selected)
    end
end

function stringstarts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function round(num, idp)
    if idp and idp > 0 then
        local mult = 10 ^ idp
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function ButtonSelected(button)
    local ped = GetPlayerPed(-1)
    local this = vehshop.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Vehicles" then
            OpenMenu('vehicles')
        elseif btn == "Motorcycles" then
            OpenMenu('motorcycles')
        end
    elseif this == "vehicles" then
        if btn == "Sports" then
            OpenMenu('sports')
        elseif btn == "Sedans" then
            OpenMenu('sedans')
        elseif btn == "Compacts" then
            OpenMenu('compacts')
        elseif btn == "Coupes" then
            OpenMenu('coupes')
        elseif btn == "Sports Classics" then
            OpenMenu("sportsclassics")
        elseif btn == "Super" then
            OpenMenu('super')
        elseif btn == "Muscle" then
            OpenMenu('muscle')
        elseif btn == "Off-Road" then
            OpenMenu('offroad')
        elseif btn == "SUVs" then
            OpenMenu('suvs')
        elseif btn == "Vans" then
            OpenMenu('vans')
        end
    elseif this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "super" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" then
        TriggerServerEvent('CheckMoneyForVeh', button.name, button.model, button.costs)
    end
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Véhicule" then
			OpenMenu('vehicles')
		elseif btn == "Motos" then
			OpenMenu('motorcycles')
		elseif btn == "Vélos" then
			OpenMenu('velos')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "Super" then
			OpenMenu('super')
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Off-Road" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Vans" then
			OpenMenu('vans')
		end
	elseif this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "super" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" or this == "velos" then
		TriggerServerEvent('CheckMoneyForVeh', button.name, button.model, button.costs)
		vehicle_price = button.costs
	end
end


function OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end





--[[Citizen]]--
local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) and IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if vehshop.opened then
			DisableControlAction(0, 172,true) --DESACTIVE CONTROLL HAUT
			local ped = LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			drawMenuTitle(menu.title, vehshop.menu.x,vehshop.menu.y + 0.08)
			local y = vehshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vehshop.menu.x,y + 0.02 + 0.003,selected)
					if button.costs ~= nil then
						if vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" or vehshop.currentmenu == "velos" then
							DoesPlayerHaveVehicle(button.model,button,y,selected)
						else
						drawMenuRight(button.costs.."$",vehshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" or vehshop.currentmenu == "velos" then
						if selected then
							if fakecar.model ~= button.model then
								Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								while not HasModelLoaded(hash) do
									Citizen.Wait(0)
								end
								local veh = CreateVehicle(hash,-46.56327,-1097.382,25.99875, 120.1953,false,false)
								while not DoesEntityExist(veh) do
									Citizen.Wait(0)
								end
								FreezeEntityPosition(veh,true)
								SetEntityInvincible(veh,true)
								SetVehicleDoorsLocked(veh,4)
								TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
								for i = 0,24 do
									SetVehicleModKit(veh,0)
									RemoveVehicleMod(veh,i)
								end
								fakecar = { model = button.model, car = veh}
							end
						end
					end
					if selected and IsControlJustPressed(1,201) then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
						ButtonSelected(button)
					end
				end
			end
		end
		if vehshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" or vehshop.currentmenu == "velos" then
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

RegisterNetEvent('FinishMoneyCheckForVeh')
AddEventHandler('FinishMoneyCheckForVeh', function(name, vehicle, price)
    local name = name
    local vehicle = vehicle
    local price = price
    boughtcar = true
	CloseCreator(name, vehicle, price)
end)


AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        ShowVehshopBlips(true)
        firstspawn = 1
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	ShowVehshopBlips(true)
  end)


RegisterNetEvent('GTA_Vehicule:DonnerJoueurVehiculeGratuit')
AddEventHandler('GTA_Vehicule:DonnerJoueurVehiculeGratuit', function()
    TriggerServerEvent('GTA_Vehicule:RecevoirVehiculeGratuit')
end)

RegisterNetEvent('vehshop:spawnVehicle')
AddEventHandler('vehshop:spawnVehicle', function(v)
    local car = GetHashKey(v)
    local playerPed = GetPlayerPed(-1)
    if playerPed and playerPed ~= -1 then
        RequestModel(car)
        while not HasModelLoaded(car) do
            Citizen.Wait(0)
        end
        local playerCoords = GetEntityCoords(playerPed)
        veh = CreateVehicle(car, playerCoords, 0.0, true, false)
        TaskWarpPedIntoVehicle(playerPed, veh, -1)
        SetEntityInvincible(veh, true)
    end
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        RemoveIpl('v_carshowroom')
        RemoveIpl('shutter_open')
        RemoveIpl('shutter_closed')
        RemoveIpl('shr_int')
        RemoveIpl('csr_inMission')
        RequestIpl('v_carshowroom')
        RequestIpl('shr_int')
        RequestIpl('shutter_closed')
        firstspawn = 1
    end
end)