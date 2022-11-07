ESX.RegisterServerCallback("xGarage:getGroup", function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    cb(xPlayer.getGroup())
end)

RegisterNetEvent("xGarage:createGarage")
AddEventHandler("xGarage:createGarage", function(create)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    for _,v in pairs(xGarage.RankAcces) do
        if xPlayer.getGroup() == v then
            MySQL.Async.execute("INSERT INTO garage (posOut, type, label, price, code, item) VALUES (@posOut, @type, @label, @price, @code, @item)", {
                ["@posOut"] = json.encode(create.posOut),
                ["@type"] = create.type,
                ["@label"] = create.rue,
                ["@price"] = create.price, 
                ["@code"] = create.code,
                ["@item"] = create.item
            }, function(result)
                if result ~= nil then
                    TriggerClientEvent('esx:showNotification', src, '(~g~Succès~s~)\nGarage créer.')
                end
            end)
        end
    end
end)

--- Xed#1188 | https://discord.gg/HvfAsbgVpM