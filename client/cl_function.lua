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
        loading = {}
        for _,v in pairs(data) do
            if ESX.Game.IsSpawnPointClear(vector3(Config.Garage[garageplaces].posCar[_].x, Config.Garage[garageplaces].posCar[_].y, Config.Garage[garageplaces].posCar[_].z), 1) then
                if not IsModelInCdimage(v.model) then return end
                RequestModel(v.model)
                while not HasModelLoaded(v.model) do
                    Citizen.Wait(10)
                end
                ESX.Game.SpawnLocalVehicle(v.model, vector3(Config.Garage[garageplaces].posCar[_].x, Config.Garage[garageplaces].posCar[_].y, Config.Garage[garageplaces].posCar[_].z), Config.Garage[garageplaces].heading, function(car) 
                    ESX.Game.SetVehicleProperties(car, v.properties)
                    SetVehicleNumberPlateText(car, v.plate)
                    table.insert(loading, {model = car, plate = v.plate, properties = v.properties, name = v.model})
                    FreezeEntityPosition(car, true)
                    TriggerServerEvent("xGarage:setEntityBucket", id, car)
                end)
            end
        end
    end, id)
end

local open = false
local mainMenu = RageUI.CreateMenu(Config.GarageTitle, Config.GarageDesc, nil, nil, Config.Directory, Config.Banner)
mainMenu.Display.Header = true
mainMenu.Closable = false

local function inGarage(id)
    if not open then
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)
                RageUI.IsVisible(mainMenu, function()
                    if #loading > 0 then
                        for _,v in pairs(loading) do
                            RageUI.Button(("~r~→~s~ %s"):format(v.name), nil, {RightLabel = ("%s"):format(v.plate)}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback("xGarage:deleteCar", function(can) 
                                        if can then
                                            exitGarage()
                                            DoScreenFadeOut(200)
                                            Wait(200)
                                            ESX.Game.Teleport(PlayerPedId(), savePos, function()end)
                                            TriggerServerEvent("xGarage:setBucket", 0)
                                            Wait(1000)
                                            DoScreenFadeIn(200)
                                            if not IsModelInCdimage(v.name) then return end
                                            RequestModel(v.name)
                                            while not HasModelLoaded(v.name) do
                                                Citizen.Wait(10)
                                            end
                                            local vehicle = CreateVehicle(v.name, savePos.x, savePos.y, savePos.z, GetEntityHeading(PlayerPedId()), true, false)
                                            ESX.Game.SetVehicleProperties(vehicle, v.properties)
                                            SetVehicleNumberPlateText(vehicle, v.plate)
                                            SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        end
                                    end, v.plate, id, v.name)
                                end
                            })
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Le garage est vide.")
                        RageUI.Separator("")
                    end
                end)
            end
        end)
    end
end

function exitGarage()
    for _,v in pairs(loading) do
        DeleteVehicle(v.model)
    end
    RageUI.CloseAll()
    open = false
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
