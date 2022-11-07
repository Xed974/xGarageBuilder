local function Visit(pos)
    local visited = true
    local time = 10
    while visited do
        Wait(1000)
        time = time - 1
        if time == 0 then
            DoScreenFadeOut(200)
            Wait(200)
            SetEntityCoords(PlayerPedId(), pos)
            Wait(1000)
            DoScreenFadeIn(200)
            TriggerServerEvent('xGarage:setBucket', 0)
            ESX.ShowNotification("(~g~Succès~s~)\nVisite terminé.")
            visited = false
            break
        end
    end
end

local mdp = 0
local Customs = { List1 = 1 }
local open = false
local mainMenu = RageUI.CreateMenu("Garage", "Interaction", nil, nil, "root_cause5", xGarage.ColorMenu)
mainMenu.Display.Closed = true
mainMenu.Closed = function()
    open = false
    FreezeEntityPosition(PlayerPedId(), false)
end

function menuBuy(id, price, type, label, code)
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
                    RageUI.Separator(("Price: ~g~%s$~s~"):format(price))
                    RageUI.Separator(("Nombre de place: ~%s~%s~s~"):format(xGarage.ColorGlobal, type))
                    RageUI.Line()
                    RageUI.Button("Visiter", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local pos = GetEntityCoords(PlayerPedId())
                            TriggerServerEvent('xGarage:setBucket', id)
                            DoScreenFadeOut(200)
                            Wait(200)
                            posExit = GetEntityCoords(PlayerPedId())
                            ESX.Game.Teleport(PlayerPedId(), xGarage.Garage[type].posIn, function()end)
                            RageUI.CloseAll()
                            open = false
                            FreezeEntityPosition(PlayerPedId(), false)
                            ESX.ShowNotification("(~y~Information~s~)\nVous avez 10 secondes.")
                            Wait(1000)
                            DoScreenFadeIn(200)
                            Visit(pos)
                        end
                    })
                    RageUI.List("Acquisition", {"Acheter", "Louer"}, Customs.List1, nil, {Preview}, true, {
                        onListChange = function(i, Index)
                            Customs.List1 = i
                        end,
                        onSelected = function()
                            if code == 11111 then
                                local keyboard = KeyboardInput("Code:", "", 4)
                                if tonumber(keyboard) and keyboard ~= nil and keyboard ~= "" then
                                    mdp = keyboard
                                    if Customs.List1 == 1 then
                                        TriggerServerEvent("xGarage:buy", id, price, mdp)
                                        Wait(1000)
                                        TriggerServerEvent("xGarage:refresh")
                                    end
                                    if Customs.List1 == 2 then
                                        TriggerServerEvent("xGarage:loc", id, price, mdp)
                                        Wait(1000)
                                        TriggerServerEvent("xGarage:refresh")
                                    end
                                else
                                    ESX.ShowNotification("(~r~Erreur~s~)\nCode invalide.")
                                end
                            end
                            if Customs.List1 == 1 then
                                TriggerServerEvent("xGarage:buy", id, price, mdp)
                                Wait(1000)
                                TriggerServerEvent("xGarage:refresh")
                                RageUI.CloseAll()
                                open = false
                                FreezeEntityPosition(PlayerPedId(), false)
                            end
                            if Customs.List1 == 2 then
                                TriggerServerEvent("xGarage:loc", id, price, mdp)
                                Wait(1000)
                                TriggerServerEvent("xGarage:refresh")
                                RageUI.CloseAll()
                                open = false
                                FreezeEntityPosition(PlayerPedId(), false)
                            end
                        end
                    })
                end)
            end
        end)
    end
end

--- Xed#1188 | https://discord.gg/HvfAsbgVpM