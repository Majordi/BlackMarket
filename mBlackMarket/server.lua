ESX = exports["es_extended"].getSharedObject();

RegisterNetEvent("blackMarket:giveTools")
AddEventHandler("blackMarket:giveTools", function (type, toolname, toolprice)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if type == "weapons" then

    if xPlayer then 
        if xPlayer.getAccount(Config.MoneyType).money > tonumber(toolprice) then
            if Config.WeaponsItem then
                xPlayer.removeAccountMoney(Config.MoneyType, tonumber(toolprice))
                xPlayer.addInventoryItem(toolname, 1)
                TriggerClientEvent("esx:showNotification", source, "Vous avez acheté l'arme "..toolname)
            else
                xPlayer.removeAccountMoney(Config.MoneyType, tonumber(toolprice))
                xPlayer.addWeapon(toolname, 250)
                TriggerClientEvent("esx:showNotification", source, "Vous avez acheté l'arme "..toolname)
            end
        else
            TriggerClientEvent("esx:showNotification", source, "Vous n'avez pas assez d'argent")
        end
    end
    else
        if xPlayer then 
            if xPlayer.getAccount(Config.MoneyType).money > tonumber(toolprice) then
                    xPlayer.removeAccountMoney(Config.MoneyType, tonumber(toolprice))
                    xPlayer.addInventoryItem(toolname, 1)
                    TriggerClientEvent("esx:showNotification", source, "Vous avez acheté l'item "..toolname)
            else
                TriggerClientEvent("esx:showNotification", source, "Vous n'avez pas assez d'argent")
            end
        end
    end
end)

ESX.RegisterServerCallback("blackMarket:getBlackMoney", function(source, cb)
    local source = source

    local xPlayer = ESX.GetPlayerFromId(source)

    local blackMoneyPlayer = xPlayer.getAccount(Config.MoneyType).money

    cb(blackMoneyPlayer)
end)