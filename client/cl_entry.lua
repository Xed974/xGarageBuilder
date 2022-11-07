ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("xGarage:ownersonner")
AddEventHandler("xGarage:ownersonner", function(listeSonner)
    for _,v in pairs(listeSonner) do
        local boucle = true
        local time = 1500
        while boucle do
            Wait(0)
            ESX.ShowNotification(("(~y~Information~s~)\nAppuyez sur Y pour faire entrer : ~%s~%s~s~."):format(xGarage.ColorGlobal, v.name))
            time = time - 1
            if IsControlJustPressed(0, 246) then
                TriggerServerEvent("xGarage:entrerStatus", v.player, v.posOut, v.id, v.type, true)
                ESX.ShowNotification(("(~g~Succès~s~)\nVous avez fait entrer: ~%s~%s~s~."):format(xGarage.ColorGlobal, v.name))
                boucle = false
                break 
            end
            if time == 0 then
                TriggerServerEvent("xGarage:entrerStatus", v.player, v.posOut, v.id, v.type, false)
                boucle = false
                break
            end
        end
    end
end)

RegisterNetEvent("xGarage:entrer")
AddEventHandler("xGarage:entrer", function(posOut, id, type)
    posExit = posOut
    enterGarage(id, type)
end)

local open = false
local mainMenu = RageUI.CreateMenu("Garage", "Interaction", nil, nil, "root_cause5", xGarage.ColorMenu)
mainMenu.Display.Header = true
mainMenu.Closed = function()
    open = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function MenuEntry(label, id, type, item, code, posOut, owner)
    if open then
        open = false
        RageUI.Visible(mainMenu, false)
    else
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Separator(("Adresse: ~%s~%s~s~"):format(xGarage.ColorGlobal, label))
                    RageUI.Line()

                    RageUI.Button("Entrer", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            if item ~= nil then
                                ESX.TriggerServerCallback("xGarage:getItem", function(result) 
                                    RageUI.CloseAll()
                                    open = false
                                    if result then
                                        posExit = GetEntityCoords(PlayerPedId())
                                        enterGarage(id, type)
                                        FreezeEntityPosition(PlayerPedId(), false)
                                    end
                                end, item)
                            end
                            if code ~= 11111 and code ~= nil then
                                local keyboard = KeyboardInput("Code:", "", 4)
                                if tonumber(keyboard) == code and keyboard ~= nil and keyboard ~= "" then
                                    RageUI.CloseAll()
                                    open = false
                                    posExit = GetEntityCoords(PlayerPedId())
                                    enterGarage(id, type)
                                    FreezeEntityPosition(PlayerPedId(), false)
                                else
                                    ESX.ShowNotification("(~r~Erreur~s~)\nCode incorrect.")
                                end
                            end
                        end
                    })
                    RageUI.Button("Sonner", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                            open = false
                            FreezeEntityPosition(PlayerPedId(), false)
                            TriggerServerEvent("xGarage:sonner", id, owner, GetEntityCoords(PlayerPedId()), type)
                        end
                    })
                end)
            end
        end)
    end
end

--- Xed#1188 | https://discord.gg/HvfAsbgVpM