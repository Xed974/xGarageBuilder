local data = {}
local function getGarage()
    MySQL.Async.fetchAll("SELECT * FROM garage", {}, function(result)
        if (result) then
            data = result
        end
    end)
end

RegisterNetEvent("xGarage:refresh")
AddEventHandler("xGarage:refresh", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    getGarage()
    Wait(1000)
    TriggerClientEvent("xGarage:refreshActualiz", -1, data)
end)

ESX.RegisterServerCallback("xGarage:getItem", function(source, cb, item)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    if xPlayer.getInventoryItem(item).count > 0 then
        cb(true)
    else
        TriggerClientEvent('esx:showNotification', src, ("(~r~Erreur~s~)\nVous n\'avez pas de ~r~%s~s~."):format(ESX.GetItemLabel(item)))
    end
end)

RegisterNetEvent("xGarage:setBucket")
AddEventHandler("xGarage:setBucket", function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    SetPlayerRoutingBucket(src, id)
end)

RegisterNetEvent("xGarage:setEntityBucket")
AddEventHandler("xGarage:setEntityBucket", function(id, car)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    SetEntityRoutingBucket(car, id)
end)

ESX.RegisterServerCallback("xGarage:putCar", function(source, cb, id, type, model, plate, properties)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT garage FROM garage WHERE id = @id", {
        ["@id"] = id
    }, function(result)
        local garages = json.decode(result[1].garage)
        if #garages < type then
            table.insert(garages, {model = model, plate = plate, properties = properties})
            MySQL.Async.execute("UPDATE garage SET garage = @garage WHERE id = @id", {
                ["@garage"] = json.encode(garages),
                ["@id"] = id
            }, function(result2)
                if result2 ~= nil then
                    cb(true)
                    TriggerClientEvent('esx:showNotification', src, ('(~g~Succès~s~)\nVotre ~%s~%s~s~ (%s) a bien été rangé.'):format(xGarage.ColorGlobal, model, plate))
                end
            end)
        else
            cb(false)
            TriggerClientEvent('esx:showNotification', src, '(~r~Erreur~s~)\nLe garage est plein.')
        end
    end)
end)

ESX.RegisterServerCallback("xGarage:loadVehicles", function(source, cb, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT garage FROM garage WHERE id = @id", {
        ["@id"] = id
    }, function(result)
        cb(json.decode(result[1].garage))
    end)
end)

RegisterNetEvent("xGarage:deleteCar")
AddEventHandler("xGarage:deleteCar", function(plate, id, name)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT garage FROM garage WHERE id = @id", {
        ["@id"] = id
    }, function(result)
        if result ~= nil then
            local garages = json.decode(result[1].garage)
            for _,v in pairs(garages) do
                if v.plate == plate then
                    table.remove(garages, _)
                    MySQL.Async.execute("UPDATE garage SET garage = @garage WHERE id = @id", {
                        ["@garage"] = json.encode(garages),
                        ["@id"] = id
                    }, function(result2)
                        if result2 ~= nil then
                            TriggerClientEvent('esx:showNotification', src, ('(~g~Succès~s~)\nVous avez sortie votre ~%s~%s~s~. (~r~%s~s~)'):format(xGarage.ColorGlobal, name, plate))
                        end 
                    end)
                end
            end
        end
    end)
end)

--- Xed#1188 | https://discord.gg/HvfAsbgVpM