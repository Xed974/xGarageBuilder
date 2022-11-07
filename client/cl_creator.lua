local create = {
    rue = "",
    price = 0,
    posOut = vector3(0.0, 0.0, 0.0),
    type = 0,
    code = nil,
    item = nil
}
local open = false
local Customs = { List1 = 1, List2 = 1 }
local mainMenu = RageUI.CreateMenu("Création", "Garage", nil, nil, "root_cause5", xGarage.ColorMenu)
mainMenu.Display.Header = true
mainMenu.Closed = function()
    open = false
    create = {}
    create.price = 0
end

local function CreatorGarage()
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
                    RageUI.Button(("~%s~→~s~ Adresse"):format(xGarage.ColorGlobal), nil, {RightLabel = create.rue}, true, {
                        onSelected = function()
                            create.rue = ("%s %s"):format(GetStreetNameFromHashKey(GetStreetNameAtCoord(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z)), math.random(1, 999))
                        end
                    })
                    RageUI.Button(("~%s~→~s~ Prix"):format(xGarage.ColorGlobal), nil, {RightLabel = ("~g~%s$~s~"):format(create.price)}, true, {
                        onSelected = function()
                            local keyboard = KeyboardInput("Prix", "", 6)
                            if tonumber(keyboard) and keyboard ~= nil and keyboard ~= "" then
                                ESX.ShowNotification("(~g~Succès~s~)\nPrix défini.")
                                create.price = keyboard
                            else
                                ESX.ShowNotification("(~r~Erreur~s~)\nPrix invalide.")
                            end
                        end
                    })
                    RageUI.Button(("~%s~→~s~ Position extérieur"):format(xGarage.ColorGlobal), nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            create.posOut = GetEntityCoords(PlayerPedId())
                            ESX.ShowNotification("(~g~Succès~s~)\nPosition défini.")
                        end
                    })
                    RageUI.List("Nombre de place", {("~%s~2~s~"):format(xGarage.ColorGlobal), ("~%s~6~s~"):format(xGarage.ColorGlobal), ("~%s~10~s~"):format(xGarage.ColorGlobal)}, Customs.List1, nil, {Preview}, true, {
                        onListChange = function(i, Index)
                            Customs.List1 = i
                        end,
                        onSelected = function()
                            if Customs.List1 == 1 then
                                ESX.ShowNotification("(~g~Succès~s~)\nNombre de place défini.")
                                create.type = 2
                            end
                            if Customs.List1 == 2 then
                                ESX.ShowNotification("(~g~Succès~s~)\nNombre de place défini.")
                                create.type = 6
                            end
                            if Customs.List1 == 3 then
                                ESX.ShowNotification("(~g~Succès~s~)\nNombre de place défini.")
                                create.type = 10
                            end
                        end
                    })
                    RageUI.List("Accès", {("~%s~Code~s~"):format(xGarage.ColorGlobal), ("~%s~Item~s~"):format(xGarage.ColorGlobal)}, Customs.List2, nil, {Preview}, true, {
                        onListChange = function(i, Index)
                            Customs.List2 = i
                        end,
                        onSelected = function()
                            if Customs.List2 == 1 then
                                ESX.ShowNotification("(~g~Succès~s~)\nAccès défini.")
                                create.code = 11111
                            end
                            if Customs.List2 == 2 then
                                local keyboard = KeyboardInput("Name de l'item", "", 6)
                                if keyboard ~= nil and keyboard ~= "" then
                                    ESX.ShowNotification("(~g~Succès~s~)\nAccès défini.")
                                    create.item = keyboard
                                else
                                    ESX.ShowNotification("(~r~Erreur~s~)\nItem invalide.")
                                end
                            end
                        end
                    })
                    RageUI.Line()
                    RageUI.Button("Valider la création", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            if create.rue ~= nil and create.rue ~= "" and create.price ~= 0 and create.price ~= "" and create.posOut ~= vector3(0.0, 0.0, 0.0) and create.type ~= 0 and ((create.code ~= nil and create.code ~= "")  or (create.item ~= nil and create.item ~= "")) then
                                TriggerServerEvent("xGarage:createGarage", create)
                                create = {}
                                RageUI.CloseAll()
                                Wait(1000)
                                TriggerServerEvent("xGarage:refresh")
                            else
                                ESX.ShowNotification("(~r~Erreur~s~)\nIl manque des informations.")
                            end
                        end
                    })
                end)
            end
        end)
    end
end

RegisterCommand("creatorGarage", function()
    ESX.TriggerServerCallback("xGarage:getGroup", function(group)
        for _,v in pairs(xGarage.RankAcces) do
            if group == v then
                CreatorGarage()
            end
        end
    end)
end)

--- Xed#1188 | https://discord.gg/HvfAsbgVpM