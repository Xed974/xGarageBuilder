function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

local loading = {}

local function loadVehicles(id, type)
    loading = {}
    ESX.TriggerServerCallback("xGarage:loadVehicles", function(data)
        for _,v in pairs(data) do
            if not IsModelInCdimage(v.model) then return end
            RequestModel(v.model)
            while not HasModelLoaded(v.model) do
                Citizen.Wait(10)
            end
            local car = CreateVehicle(v.model, xGarage.Garage[type].posCar[_].x, xGarage.Garage[type].posCar[_].y, xGarage.Garage[type].posCar[_].z, xGarage.Garage[type].heading, true, false)
            ESX.Game.SetVehicleProperties(car, v.properties)
            SetVehicleNumberPlateText(car, v.plate)
            TriggerServerEvent("xGarage:setEntityBucket", id, car)
            table.insert(loading, {model = car, plate = v.plate, properties = v.properties, name = v.model})
        end
    end, id)
end

function exitGarage()
    for _,v in pairs(loading) do
        DeleteEntity(v.model)
    end
end

local function inGarage(id)
    local model, name, properties, plate = nil, nil, nil, nil
    Citizen.CreateThread(function()
        while true do
            local wait = 1000

            for _,v in pairs(loading) do
                if (GetVehiclePedIsIn(PlayerPedId(), false)) == v.model then
                    model, name, properties, plate = v.model, v.name, v.properties, v.plate
                end
            end
            if (GetVehiclePedIsIn(PlayerPedId(), false)) == model then
                wait = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_MOVE_UP_ONLY~ ou ~INPUT_MOVE_DOWN_ONLY~ pour sortir avec le véhicule.")
                if (IsControlJustPressed(1, 32) or IsControlJustPressed(1, 71) or IsControlJustPressed(1, 77) or IsControlJustPressed(1, 87) or IsControlJustPressed(1, 129) or IsControlJustPressed(1, 136) or IsControlJustPressed(1, 150) or IsControlJustPressed(1, 232)) or (IsControlJustPressed(1, 8) or IsControlJustPressed(1, 31) or IsControlJustPressed(1, 33) or IsControlJustPressed(1, 72) or IsControlJustPressed(1, 78) or IsControlJustPressed(1, 88) or IsControlJustPressed(1, 130) or IsControlJustPressed(1, 139) or IsControlJustPressed(1, 149) or IsControlJustPressed(1, 151) or IsControlJustPressed(1, 196) or IsControlJustPressed(1, 219) or IsControlJustPressed(1, 233) or IsControlJustPressed(1, 268) or IsControlJustPressed(1, 269) or IsControlJustPressed(1, 302)) then
                    exitGarage()
                    TriggerServerEvent("xGarage:deleteCar", plate, id, name)
                    DoScreenFadeOut(200)
                    Wait(200)
                    ESX.Game.Teleport(PlayerPedId(), posExit, function()end)
                    TriggerServerEvent("xGarage:setBucket", 0)
                    Wait(1000)
                    DoScreenFadeIn(200)
                    if not IsModelInCdimage(name) then return end
                    RequestModel(name)
                    while not HasModelLoaded(name) do
                        Citizen.Wait(10)
                    end
                    local vehicle = CreateVehicle(name, posExit.x, posExit.y, posExit.z, GetEntityHeading(PlayerPedId()), true, false)
                    ESX.Game.SetVehicleProperties(vehicle, properties)
                    SetVehicleNumberPlateText(vehicle, plate)
                    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                end
            end
            Citizen.Wait(wait)
        end
    end)
end

function enterGarage(id, type)
    local car = GetVehiclePedIsIn(PlayerPedId(), false)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(car))
    local properties = ESX.Game.GetVehicleProperties(car)
    local plate = GetVehicleNumberPlateText(car)
    if car ~= 0 then
        ESX.TriggerServerCallback("xGarage:putCar", function(can) 
            if can then
                DeleteEntity(car)
                DoScreenFadeOut(200)
                Wait(200)
                TriggerServerEvent("xGarage:setBucket", id)
                loadVehicles(id, type)
                ESX.Game.Teleport(PlayerPedId(), xGarage.Garage[type].posIn, function()end)
                Wait(1000)
                DoScreenFadeIn(200)
                inGarage(id)
            end
        end, id, type, model, plate, properties)
    else
        DoScreenFadeOut(200)
        Wait(200)
        TriggerServerEvent("xGarage:setBucket", id)
        loadVehicles(id, type)
        ESX.Game.Teleport(PlayerPedId(), xGarage.Garage[type].posIn, function()end)
        Wait(1000)
        DoScreenFadeIn(200)
        inGarage(id)
    end
end

--- Xed#1188 | https://discord.gg/HvfAsbgVpM