local spikes_deployed = false
local obj1 = nil
local obj2 = nil
local obj3 = nil
priostatus = true

RegisterNetEvent("pmgetstatusofprio")
AddEventHandler("pmgetstatusofprio", function(prio)
    priostatus = prio
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if spikes_deployed then
            for peeps = 0, 64 do
                if NetworkIsPlayerActive(GetPlayerFromServerId(peeps)) then
                    
                    local currentVeh = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false)
                    if currentVeh ~= nil and currentVeh ~= false then
                        local currentVehcoords = GetEntityCoords(currentVeh, true)
                        local obj1coords = GetEntityCoords(obj1, true)
                        local obj2coords = GetEntityCoords(obj2, true)
                        local obj3coords = GetEntityCoords(obj3, true)
                        local DistanceBetweenObj1 = Vdist(obj1coords['x'], obj1coords['y'], obj1coords['z'], currentVehcoords['x'], currentVehcoords['y'], currentVehcoords['z'])
                        local DistanceBetweenObj2 = Vdist(obj2coords['x'], obj2coords['y'], obj2coords['z'], currentVehcoords['x'], currentVehcoords['y'], currentVehcoords['z'])
                        local DistanceBetweenObj3 = Vdist(obj3coords['x'], obj3coords['y'], obj3coords['z'], currentVehcoords['x'], currentVehcoords['y'], currentVehcoords['z'])
                        if DistanceBetweenObj1 < 2.2 or DistanceBetweenObj2 < 2.2 or DistanceBetweenObj3 < 2.2 then
                            
							TriggerServerEvent("police:spikes", currentVeh, peeps)
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if spikes_deployed then
        	local obj1coords = GetEntityCoords(obj1, true)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), obj1coords.x, obj1coords.y, obj1coords.z, true) > 100 then -- if the player is too far from his Spikes
           		SetEntityAsMissionEntity(obj1, false, false)
           		SetEntityAsMissionEntity(obj2, false, false)
           		SetEntityAsMissionEntity(obj3, false, false)
           		SetEntityVisible(obj1, false)
           		SetEntityVisible(obj2, false)
           		SetEntityVisible(obj3, false)
           		DeleteObject(obj1)
           		DeleteObject(obj2)
           		DeleteObject(obj3)
                DeleteEntity(obj1)
                DeleteEntity(obj2)
                DeleteEntity(obj3)
                obj1 = nil
                obj2 = nil
                obj3 = nil
                --exports.pNotify:SendNotification({text = "Removing spikes! (D>100)",type = "error",queue = "left",timeout = 3000,layout = "centerRight"})
                spikes_deployed = false
        	end
        end
	end
end)

RegisterNetEvent("police:dietyres")
AddEventHandler("police:dietyres", function(currentVeh)
    SetVehicleTyreBurst(currentVeh, 0, false, 1000.0)
    SetVehicleTyreBurst(currentVeh, 1, false, 1000.0)
    SetVehicleTyreBurst(currentVeh, 2, false, 1000.0)
    SetVehicleTyreBurst(currentVeh, 3, false, 1000.0)
    SetVehicleTyreBurst(currentVeh, 4, false, 1000.0)
    SetVehicleTyreBurst(currentVeh, 5, false, 1000.0)
    --exports.pNotify:SendNotification({text = "You hit a spike strip! Bad luck.",type = "error",queue = "left",timeout = 3000,layout = "centerRight"})
    Citizen.Wait(1000)
    SetEntityAsMissionEntity(obj1, false, false)
    SetEntityAsMissionEntity(obj2, false, false)
    SetEntityAsMissionEntity(obj3, false, false)
    SetEntityVisible(obj1, false)
    SetEntityVisible(obj2, false)
    SetEntityVisible(obj3, false)
    DeleteObject(obj1)
    DeleteObject(obj2)
    DeleteObject(obj3)
    DeleteEntity(obj1)
    DeleteEntity(obj2)
    DeleteEntity(obj3)
    obj1 = nil
    obj2 = nil
    obj3 = nil
    spikes_deployed = false
end)

RegisterNetEvent("police:dietyres2")
AddEventHandler("police:dietyres2", function(peeps)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 0, false, 1000.0)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 1, false, 1000.0)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 2, false, 1000.0)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 3, false, 1000.0)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 4, false, 1000.0)
    SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 5, false, 1000.0)
end)

--=============================================================cALL IT

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

function doAnimation()
	local ped 	  = PlayerPedId()
	local coords  = GetEntityCoords(ped)

	--FreezeEntityPosition(ped, true)
	loadAnimDict("pickup_object")
	TaskPlayAnim(ped, "pickup_object", "pickup_low", 1.0, 1, -1, 33, 0, 0, 0, 0)
end

function ToggleSpikes()
	TriggerEvent("police:Deploy")
end
spikestatus = true
RegisterNetEvent('pmgetspikestatus')
AddEventHandler('pmgetspikestatus', function(status)
    spikestatus = status
end)


RegisterNetEvent("police:Deploy")
AddEventHandler("police:Deploy", function()
    Citizen.CreateThread(function()
        if (not spikes_deployed) and (priostatus) and (spikestatus) then
            local spikes = GetHashKey("p_stinger_04")
            RequestModel(spikes)
            while not HasModelLoaded(spikes) do
                Citizen.Wait(0)
            end
            --exports.pNotify:SendNotification({text = "Deploying spikes!",type = "error",queue = "left",timeout = 3000,layout = "centerRight"}) 
            doAnimation()
            Citizen.Wait(1700)
            ClearPedTasksImmediately(PlayerPedId())
			--FreezeEntityPosition(PlayerPedId(), false)
			Citizen.Wait(250)
            local playerheading = GetEntityHeading(PlayerPedId())
            coords1 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 3, 10, -0.7)
            coords2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, -5, -0.5)
            obj1 = CreateObject(spikes, coords1['x'], coords1['y'], coords1['z'], true, true, true)
            obj2 = CreateObject(spikes, coords2['x'], coords2['y'], coords2['z'], true, true, true)
            obj3 = CreateObject(spikes, coords2['x'], coords2['y'], coords2['z'], true, true, true)
			SetEntityHeading(obj1, playerheading)
            SetEntityHeading(obj2, playerheading)
            SetEntityHeading(obj3, playerheading)
            AttachEntityToEntity(obj1, PlayerPedId(), 1, 0.0, 4.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            AttachEntityToEntity(obj2, PlayerPedId(), 1, 0.0, 8.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            AttachEntityToEntity(obj3, PlayerPedId(), 1, 0.0, 12.0, 0.0, 0.0, -90.0, 0.0, true, true, false, false, 2, true)
            Citizen.Wait(10)
            DetachEntity(obj1, true, true)
            DetachEntity(obj2, true, true)
            DetachEntity(obj3, true, true)
            spikes_deployed = true
            TriggerServerEvent("pmsendpriostatus")
            TriggerServerEvent("pmstartspiketimer", 300) --sets timer to start after placing spikes (300 seconds/5 minutes)
        elseif spikes_deployed then
        	spikes_deployed = false
            --exports.pNotify:SendNotification({text = "Removing spikes!",type = "error",queue = "left",timeout = 3000,layout = "centerRight"}) 
            doAnimation()
            Citizen.Wait(1700)
            ClearPedTasksImmediately(PlayerPedId())
			--FreezeEntityPosition(PlayerPedId(), false)
			Citizen.Wait(200)
            SetEntityCoords(obj1, -5000.0, -5000.0, 20.0, true, false, false, true)
            SetEntityCoords(obj2, -5000.0, -5000.0, 20.0, true, false, false, true)
            SetEntityCoords(obj3, -5000.0, -5000.0, 20.0, true, false, false, true)
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(obj1))
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(obj2))
            Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(obj3))
            obj1 = nil
            obj2 = nil
            obj3 = nil
            TriggerServerEvent("pmsendpriostatus")
        elseif not spikes_deployed and priostatus and not spikestatus then
            ShowNotification("Spikes are on cooldown. Cooldown is 5 minutes from when they are originally placed.")
        end
	end)
end)