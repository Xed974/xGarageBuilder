RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent("xGarage:refresh")
end)

local garage = {}
RegisterNetEvent("xGarage:refreshActualiz")
AddEventHandler("xGarage:refreshActualiz", function(data)
    garage = data
end)

posExit = nil
Citizen.CreateThread(function()
    TriggerServerEvent("xGarage:refresh")
    while true do
        local wait = 1000

        for _,v in pairs(garage) do
            local pPos = GetEntityCoords(PlayerPedId())
            local posOut = json.decode(v.posOut)
            local posIn = xGarage.Garage[v.type].posIn
            local dstposOut = Vdist(pPos.x, pPos.y, pPos.z, posOut.x, posOut.y, posOut.z)
            local dstposIn = Vdist(pPos.x, pPos.y, pPos.z, posIn.x, posIn.y, posIn.z)

            if dstposOut <= xGarage.MarkerDistance then
                wait = 0
                DrawMarker(xGarage.MarkerType, posOut.x, posOut.y, posOut.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, xGarage.MarkerSizeLargeur, xGarage.MarkerSizeEpaisseur, xGarage.MarkerSizeHauteur, xGarage.MarkerColorR, xGarage.MarkerColorG, xGarage.MarkerColorB, xGarage.MarkerOpacite, xGarage.MarkerSaute, true, p19, xGarage.MarkerTourne)
            end
            if dstposOut <= xGarage.OpenMenuDistance then
                wait = 0
                ESX.ShowHelpNotification(("Appuyez sur ~INPUT_CONTEXT~ pour ~%s~intéragir avec le garage~s~."):format(xGarage.ColorGlobal))
                if IsControlJustPressed(1, 51) then
                    if v.owner == nil then
                        FreezeEntityPosition(PlayerPedId(), true)
                        menuBuy(v.id, v.price, v.type, v.label, v.code)
                    else
                        FreezeEntityPosition(PlayerPedId(), true)
                        MenuEntry(v.label, v.id, v.type, v.item, v.code, v.posOut, v.owner)
                    end
                end
            end
            if dstposIn <= xGarage.MarkerDistance then
                wait = 0
                DrawMarker(xGarage.MarkerType, posIn.x, posIn.y, posIn.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, xGarage.MarkerSizeLargeur, xGarage.MarkerSizeEpaisseur, xGarage.MarkerSizeHauteur, xGarage.MarkerColorR, xGarage.MarkerColorG, xGarage.MarkerColorB, xGarage.MarkerOpacite, xGarage.MarkerSaute, true, p19, xGarage.MarkerTourne)
            end
            if dstposIn <= xGarage.OpenMenuDistance then
                wait = 0
                ESX.ShowHelpNotification(("Appuyez sur ~INPUT_CONTEXT~ pour ~%s~sortir du garage~s~."):format(xGarage.ColorGlobal))
                if IsControlJustPressed(1, 51) then
                    exitGarage()
                    DoScreenFadeOut(200)
                    Wait(200)
                    ESX.Game.Teleport(PlayerPedId(), posExit, function()end)
                    TriggerServerEvent("xGarage:setBucket", 0)
                    Wait(1000)
                    DoScreenFadeIn(200)
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

--- Xed#1188 | https://discord.gg/HvfAsbgVpM