--Handles all permissions
lib.callback.register('policecheckaccess', function(source)
    local allowed = IsPlayerAceAllowed(source, Config.AceAccessPerm)

    --Player(source).state.invehicle = false
    --Player(source).state.dragged = false
    --Player(source).state.cuffed = false

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
    Player(source).state.cuffed = not Player(source).state.cuffed
	TriggerClientEvent('cuffplayer', player)
end)

RegisterServerEvent('dragplayer')
AddEventHandler('dragplayer', function(player)
    Player(source).state.dragged = not Player(source).state.dragged
	TriggerClientEvent('dragplayer', player, source)
end)

RegisterServerEvent("pm:s:vehicletoggle")
AddEventHandler("pm:s:vehicletoggle", function(player)
    if Player(player).state.invehicle == nil then
        Player(player).state.invehicle = false
    end

    Player(player).state.invehicle = not Player(player).state.invehicle
	TriggerClientEvent('pm:c:vehicletoggle', player)
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

local playerdata = {}
function LoadData()
    playerdata = json.decode(LoadResourceFile(GetCurrentResourceName(), "playerdata.json"))
end
function SaveData()
    --playerdata = {["license:86ea33798ffbb7186f3bee040be8fe0922561bb2"]={position="top-right",type="none",data={}}}
    SaveResourceFile(GetCurrentResourceName(), "playerdata.json",json.encode(playerdata,{indent=true}),-1)
end
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        LoadData()
    end
end)
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SaveData()
    end
end)

function GetPlayerData(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "license:") then
            return playerdata[v]
        end
    end
end
lib.callback.register('getPlayerData', GetPlayerData)

function UpdatePlayerData(source,data)
    local identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "license:") then
            playerdata[v] = data
            if playerdata[v].private then
                playerdata[v].private = nil
            end
            return 1
        end
    end
end
lib.callback.register('updatePlayerData', UpdatePlayerData)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local identifiers = GetPlayerIdentifiers(player)

    Wait(0)
    for _, v in pairs(identifiers) do
        if string.find(v, "license:") then
            if not playerdata[v] then
                playerdata[v] = {
                    type = Config.ForceType,
                    position = 'top-right',
                    data = {}
                }
            end
        end
    end
end)