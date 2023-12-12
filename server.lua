--Handles all permissions
lib.callback.register('policecheckaccess', function(source)
    local allowed = IsPlayerAceAllowed(source, Config.AceAccessPerm)
    return allowed
end)
lib.callback.register('policegetloadouts', function(source)
    local placeholderloadout = Config.Loadouts
    for i,v in pairs(Config.Loadouts) do
        if v.access ~= true then
            if IsPlayerAceAllowed(source, "policemenu."..i) then
                placeholderloadout[i].access = true
            else
                placeholderloadout[i].access = false
            end
        end
    end
    return placeholderloadout
end)
--End *Handles all permissions*

--Action commands
function HandleActionCommands()
	if Config.ActionCommands.cuffing then
		RegisterCommand("cuff",function(source)
            TriggerClientEvent("ToggleCuffs", source)
        end,true)
	end
	if Config.ActionCommands.dragging then
		RegisterCommand("drag",function(source)
            TriggerClientEvent("ToggleDrag", source)
        end,true)
	end
	if Config.ActionCommands.spikes then
		RegisterCommand("spikes",function(source)
            TriggerClientEvent("ToggleSpikes", source)
        end,true)
	end
	if Config.ActionCommands.vehicle then
		RegisterCommand("vehiclepm",function(source)
            TriggerClientEvent("ToggleVehicle", source)
        end,true)
	end
end
HandleActionCommands()
--End *Action commands*

--Action server sync
RegisterServerEvent('cuffplayer')
AddEventHandler('cuffplayer', function(player)
	TriggerClientEvent('cuffplayer', player)
end)

RegisterServerEvent('dragplayer')
AddEventHandler('dragplayer', function(player)
	TriggerClientEvent('dragplayer', player, source)
end)

RegisterServerEvent('forceplayerintovehicle')
AddEventHandler('forceplayerintovehicle', function(player)
    Player(player).state.invehicle = true
	TriggerClientEvent('forceplayerintovehicle', player)
end)

RegisterServerEvent('removeplayerfromvehicle')
AddEventHandler('removeplayerfromvehicle', function(player)
    Player(player).state.invehicle = false
	TriggerClientEvent('removeplayerfromvehicle', player)
end)

RegisterServerEvent('searchplayer')
AddEventHandler('searchplayer', function(player)
	TriggerClientEvent('searchplayer', player, source)
end)

RegisterServerEvent('removeplayerweapons')
AddEventHandler('removeplayerweapons', function(player)
	TriggerClientEvent("removeplayerweapons", player)
end)
--End *Action server sync*

--Update check
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() and Config.CheckVersion then
        lib.versionCheck("chickenlord01/johnspolicerework")
    end
end)
--End *Update check*