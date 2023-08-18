ESX = exports["es_extended"]:getSharedObject()

local commandWeapon = false
local commandItems = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
    
    SendNUIMessage({
        type = "setItems",
        items = Config["Items"]
    })

    SendNUIMessage({
        type = "setWeapons",
        weapons = Config["Weapons"]
    })
end)

RegisterNetEvent("onResourceStart")
AddEventHandler("onResourceStart", function()
    Wait(1000)
    --Load Weapons & Items After 3 seconds
    SendNUIMessage({
        type = "setItems",
        items = Config["Items"]
    })

    SendNUIMessage({
        type = "setWeapons",
        weapons = Config["Weapons"]
    })
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local menuOpened = false;

function showMenu(show)
    ESX.TriggerServerCallback("blackMarket:getBlackMoney", function(black_money)

        SetNuiFocus(show, show)

        SendNUIMessage({
            type = "show",
            show = show,
        })

        SendNUIMessage({
            type = "setMoney",
            money = black_money,
        })
    
        menuOpened = show;

    end)
end

RegisterNUICallback("payWeapon", function(data, cb)
    local weapon = data
    TriggerServerEvent("blackMarket:giveTools", "weapons", weapon.name, weapon.price)

    ESX.TriggerServerCallback("blackMarket:getBlackMoney", function(black_money)

    SendNUIMessage({
        type = "setMoney",
        money = black_money,
    })

    end)

    cb(true)
end)

RegisterNUICallback("payItem", function(data, cb)
    local item = data

    TriggerServerEvent("blackMarket:giveTools", "items", item.name, item.price)

    ESX.TriggerServerCallback("blackMarket:getBlackMoney", function(black_money)

    SendNUIMessage({
        type = "setMoney",
        money = black_money,
    })

    end)

    cb(true);
end)

RegisterNUICallback("closeMenu", function (data, cb)
    showMenu(false);

    cb("ok");
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        
        for k, position in ipairs(Config.Positions) do
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position)

            if dist <= 10.0 then
                wait = 0
                DrawMarker(22, position, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 131, 131, 131, 255, true, true, 2, true)

                if dist <= 2.0 then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyer sur ~b~[E]~s~ pour interagir avec le Vendeur")
                    if IsControlJustPressed(0, 51) then
                        showMenu(true)
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)