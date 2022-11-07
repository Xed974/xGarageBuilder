local function dateRented()
    local date = ('%s/%s/%s'):format(os.date('%Y'), tonumber(os.date('%d'))+7, os.date('%m'))

    if tonumber(os.date('%d'))+7 <= 31 then
        return date
    else
        local day = 31 - tonumber(os.date('%d'))
        local calcule = 7 - day
        local result  = 0 + calcule
        date = ('%s/%s/%s'):format(os.date('%Y'), tonumber(result), os.date('%m')+1)
        return date
    end
end

RegisterNetEvent("xGarage:buy")
AddEventHandler("xGarage:buy", function(id, price, code)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    if xPlayer.getAccount('bank').money >= price then
        xPlayer.removeAccountMoney('bank', price)
        if code ~= 0 then
            MySQL.Async.execute("UPDATE garage SET owner = @owner, code = @code WHERE id = @id", {
                ["@owner"] = xPlayer.getIdentifier(),
                ["@code"] = code,             
                ["@id"] = id
            }, function(result)
                if result ~= nil then
                    TriggerClientEvent('esx:showNotification', src, ('(~g~Succès~s~)\nVous avez achetez ce garage, le code est ~r~%s~s~.'):format(code))
                end
            end)
        else
            MySQL.Async.execute("UPDATE garage SET owner = @owner WHERE id = @id", {
                ["@owner"] = xPlayer.getIdentifier(),
                ["@id"] = id
            }, function(result)
                if result ~= nil then
                    TriggerClientEvent('esx:showNotification', src, '(~g~Succès~s~)\nVous avez achetez ce garage.')
                end
            end)
        end
    else
        TriggerClientEvent('esx:showNotification', src, '(~r~Erreur~s~)\nVous avez pas assez d\'argent.')
    end
end)

RegisterNetEvent("xGarage:loc")
AddEventHandler("xGarage:loc", function(id, price, code)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    price = price / xGarage.Diviser

    if (not xPlayer) then return end
    if xPlayer.getAccount('bank').money >= price then
        xPlayer.removeAccountMoney('bank', price)
        if code ~= 0 then
            MySQL.Async.execute("UPDATE garage SET owner = @owner, date = @date, code = @code WHERE id = @id", {
                ["@owner"] = xPlayer.getIdentifier(),
                ["@date"] = dateRented(),
                ["@code"] = code,   
                ["@id"] = id
            }, function(result)
                if result ~= nil then
                    TriggerClientEvent('esx:showNotification', src, ('(~g~Succès~s~)\nVous avez louer ce garage, le code est ~r~%s~s~.'):format(code))
                end
            end)
        else
            MySQL.Async.execute("UPDATE garage SET owner = @owner, date = @date WHERE id = @id", {
                ["@owner"] = xPlayer.getIdentifier(),
                ["@date"] = dateRented(),
                ["@id"] = id
            }, function(result)
                if result ~= nil then
                    TriggerClientEvent('esx:showNotification', src, '(~g~Succès~s~)\nVous avez louer ce garage.')
                end
            end)
        end
    else
        TriggerClientEvent('esx:showNotification', src, '(~r~Erreur~s~)\nVous avez pas assez d\'argent.')
    end
end)

local function RemoveMoney(owner, price, id)
    price = (tonumber(price) / xGarage.Diviser)
    MySQL.Async.fetchAll('SELECT accounts FROM users WHERE identifier = @identifier', { 
        ["@identifier"] = owner 
    }, function(result)
        local accounts = json.decode(result[1].accounts)
        if accounts.bank >= price then
            accounts.bank = accounts.bank - price
            MySQL.Async.execute("UPDATE users SET accounts = @accounts WHERE identifier = @identifier", {
                ['@accounts'] = json.encode(accounts),
                ['@identifier'] = owner
            }, function()end)
            MySQL.Async.execute("UPDATE garage SET date = @date WHERE id = @id", {
                ['@date'] = dateRented(),
                ['@id'] = id
            }, function()end)
        else
            MySQL.Async.execute("UPDATE garage SET owner = @owner, date = @date, garage = @garage WHERE id = @id", {
                ['@owner'] = nil,
                ['@dateRented'] = nil,
                ["@garage"] = "[]",
                ['@id'] = id,
            }, function()end)
        end
    end)
end

CreateThread(function()
    while true do
        MySQL.Async.fetchAll("SELECT * FROM garage", {}, function(result)
            for _, v in pairs(result) do
                if v.date ~= nil then
                    local date = os.date("%d/%m/%Y")
                    if date == v.dateRented and v.owner ~= nil then
                        RemoveMoney(v.owner, v.price, v.id)
                    end
                end
            end
        end)
        Wait(60000)
    end
end)

--- Xed#1188 | https://discord.gg/HvfAsbgVpM