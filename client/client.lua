--DONT CHANGE THESE UNLESS YOU KNOW WHAT YOU ARE DOING
local menu, loadouts, access, actions = {}, Config.Loadouts, false, Config.Actions
local cuffed, invehicle, dragged, isdragging, plhplayer = false, false, false, false, 0




menu.position, menu.type = 'top-right', Config.ForceType
if menu.type == 'none' then
	menu.allowchange = true
	--[[lib.callback('getPlayerMenuSettings', function(data)
		menu.position = data.position or 'top-right'
		menu.type = data.type or Config.ForceType
	end)]]
end

function SettingsMenu()
	lib.registerContext({
		id = 'policemenusettings',
		title = 'Menu settings',
		options = {
			{
				title = 'Change menu',
				description = 'Current menu: '..menu.type,
				onSelect = function()
					local input = lib.inputDialog("Settings", {
						{type = 'select', label = 'Select menu type', required = true, options = {
							{
								value = 'menu',
								label = 'menu'
							},
							{
								value = 'context',
								label = 'context'
							},
							{
								value = 'radial',
								label = 'radial'
							},
						}, default = 'menu', clearable = false}
					})
					if input then
						if input[1] then
							menu.type = tostring(input[1])
							UpdateMenu()
							--lib.callback('updateMenuType', )
						end
					end
				end
			}
		}
	})
end

--Thread(s) to manage menu and handle permission setting upon script start. Also handles player actions.
Citizen.CreateThread(function()
    UpdateMenu()

    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(0)
    end
    RefreshPerms()

    --[[while true do
        --AllMenu()
        Wait(0)
    end]]
end)
Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(0)
	end
	while true do
		Wait(10000)
		RefreshPerms()
	end
end)
Citizen.CreateThread(function()
    while true do
        Wait(0)
        HandleDrag()
    end
end)
--End *Thread(s) to manage menu and handle permission setting upon script start. Also handles player actions.*


--Menu creation and permissions
function UpdateMenu()
	CreateMenu()
	ActionsMenuSetup()
	LoadoutsMenuSetup()
	SettingsMenu()
end
function ActionsMenuSetup()
	local options = {}
	if menu.type == 'menu' or menu.type == 'none' then
		if actions.cuffing then
			table.insert(options, #options+1, {label = 'Cuff', description = 'Cuffs closest player', close = Config.Closeonaction, args = {'cuff'}})
		end
		if actions.dragging then
			table.insert(options, #options+1, {label = 'Drag', description = 'Drags closest player', close = Config.Closeonaction, args = {'drag'}})
		end
		if actions.removefromvehicle then
			table.insert(options, #options+1, {label = 'Place/Remove in Vehicle', description = 'Places/Removes closest player in vehicle', close = Config.Closeonaction, args = {'vehicle'}})
		end
		if actions.removeweapons then
			table.insert(options, #options+1, {label = 'Remove Weapons', description = 'Removes all weapons from player', close = Config.Closeonaction, args = {'removeweapons'}})
		end
		if actions.spikes then
			table.insert(options, #options+1, {label = 'Drop Spike', description = 'Drops/Grabs spike strips', close = Config.Closeonaction, args = {'spikes'}})
		end
		table.insert(options, #options+1, {label = 'Back', description = 'Back to main menu', icon = "fa-solid fa-arrow-left"})
		lib.registerMenu({
			id = 'policeactionsmenu',
			title = 'Police Actions',
			position = menu.position,
			onSideScroll = function(selected, scrollIndex, args)
			end,
			onSelected = function(selected, secondary, args)
			end,
			onCheck = function(selected, checked, args)
			end,
			onClose = function(keyPressed)
				if keyPressed then
					lib.showMenu("policemenu")
				end
			end,
			options = options
		}, function(selected, scrollIndex, args)
			if args then
				if args[1] == 'cuff' then
					ToggleCuffs()
				elseif args[1] == 'drag' then
					ToggleDrag()
				elseif args[1] == 'vehicle' then
					ToggleVehicle()
				elseif args[1] == 'removeweapons' then
					RemoveWeapons()
				elseif args[1] == 'spikes' then
					ToggleSpikes()
				end
			else
				lib.showMenu("policemenu")
			end
		end)
	elseif menu.type == 'context' then
		if actions.cuffing then
			table.insert(options, #options+1, {title = 'Cuff', description = 'Cuffs closest player',onSelect = function()
				ToggleCuffs()
				if not Config.Closeonaction then
					lib.showContext('policeactionscontext')
				end
			end})
		end
		if actions.dragging then
			table.insert(options, #options+1, {title = 'Drag', description = 'Drags closest player',onSelect = function()
				ToggleDrag()
				if not Config.Closeonaction then
					lib.showContext('policeactionscontext')
				end
			end})
		end
		if actions.removefromvehicle then
			table.insert(options, #options+1, {title = 'Place/Remove in Vehicle', description = 'Places/Removes closest player in vehicle',onSelect = function()
				ToggleVehicle()
				if not Config.Closeonaction then
					lib.showContext('policeactionscontext')
				end
			end})
		end
		if actions.removeweapons then
			table.insert(options, #options+1, {title = 'Remove Weapons', description = 'Removes all weapons from player',onSelect = function()
				RemoveWeapons()
				if not Config.Closeonaction then
					lib.showContext('policeactionscontext')
				end
			end})
		end
		if actions.spikes then
			table.insert(options, #options+1, {title = 'Drop Spike', description = 'Drops/Grabs spike strips',onSelect = function()
				ToggleSpikes()
				if not Config.Closeonaction then
					lib.showContext('policeactionscontext')
				end
			end})
		end
		lib.registerContext({
			id = 'policeactionscontext',
			title = 'Police Actions',
			menu = 'policecontext',
			options = options
		})
	elseif menu.type == 'radial' then
		if actions.cuffing then
			table.insert(options, #options+1, {label = 'Cuff',onSelect = function()
				ToggleCuffs()
			end})
		end
		if actions.dragging then
			table.insert(options, #options+1, {label = 'Drag', onSelect = function()
				ToggleDrag()
			end})
		end
		if actions.removefromvehicle then
			table.insert(options, #options+1, {label = 'Place/Remove in Vehicle', onSelect = function()
				ToggleVehicle()
			end})
		end
		if actions.removeweapons then
			table.insert(options, #options+1, {label = 'Remove Weapons', onSelect = function()
				RemoveWeapons()
			end})
		end
		if actions.spikes then
			table.insert(options, #options+1, {label = 'Drop Spike', onSelect = function()
				ToggleSpikes()
			end})
		end
		lib.registerRadial({
			id = "policeactionsradial",
			items = options,
			keepOpen = not Config.Closeonaction
		})
	end
end

function LoadoutsMenuSetup()
	local options = {}
	options = LoadoutOptions()
	if menu.type == 'menu' or menu.type == 'none' then
		table.insert(options, {label = 'Back', description = 'Back to main menu', icon = "fa-solid fa-arrow-left"})
		lib.registerMenu({
			id = 'policeloadoutsmenu',
			title = 'Police Loadouts',
			position = menu.position,
			onSideScroll = function(selected, scrollIndex, args)
			end,
			onSelected = function(selected, secondary, args)
			end,
			onCheck = function(selected, checked, args)
			end,
			onClose = function(keyPressed)
				if keyPressed then
					lib.showMenu("policemenu")
				end
			end,
			options = options
		}, function(selected, scrollIndex, args)
			if args then
				HandleWeapons(args)
			else
				lib.showMenu("policemenu")
			end
		end)
	elseif menu.type == 'context' then
		lib.registerContext({
			id = 'policeloadoutscontext',
			title = 'Police Loadouts',
			menu = 'policecontext',
			options = options
		})
	elseif menu.type == 'radial' then
		lib.registerRadial({
			id = "policeloadoutsradial",
			items = options,
			keepOpen = not Config.Closeonaction
		})
	end
end

function CreateMenu()
	local options = {}
	if menu.type == 'menu' or menu.type == 'none' then
		table.insert(options, {label = 'Actions', description = 'Open action menu'})
		table.insert(options, #options+1, {label = 'Loadouts', description = 'Open loadouts menu'})
		table.insert(options, #options+1, {label = 'Settings', description = 'Settings', icon = "fa-solid fa-gear", disabled = not menu.allowchange, args = {menu = 'settings'}})
		lib.registerMenu({
			id = 'policemenu',
			title = 'Police Menu',
			position = menu.position,
			onSideScroll = function(selected, scrollIndex, args)
			end,
			onSelected = function(selected, secondary, args)
			end,
			onCheck = function(selected, checked, args)
			end,
			onClose = function(keyPressed)
			end,
			options = options
		}, function(selected, scrollIndex, args)
			if selected == 1 then
				lib.showMenu("policeactionsmenu")
			elseif selected == 2 then
				lib.showMenu("policeloadoutsmenu")
			end
			if args then
				lib.showContext('policemenusettings')
			end
		end)
	elseif menu.type == 'context' then
		table.insert(options, {title = 'Actions', description = 'Open action menu', menu = 'policeactionscontext'})
		table.insert(options, #options+1, {title = 'Loadouts', description = 'Open loadouts menu', menu = 'policeloadoutscontext'})
		table.insert(options, #options+1, {title = 'Settings', description = 'Settings', icon = "fa-solid fa-gear", disabled = not menu.allowchange, menu = 'policemenusettings'})
		lib.registerContext({
			id = 'policecontext',
			title = 'Police Menu',
			options = options
		})
	elseif menu.type == 'radial' then
		table.insert(options, {label = 'Actions', menu = 'policeactionsradial'})
		table.insert(options, #options+1, {label = 'Loadouts', menu = 'policeloadoutsradial'})
		if menu.allowchange then
			table.insert(options, #options+1, {label = 'Settings', icon = "fa-solid fa-gear", onSelect = function()
				lib.showContext('policemenusettings')
			end})
		end
		lib.registerRadial({
			id = "policeradial",
			items = options,
			keepOpen = not Config.Closeonaction
		})
		lib.addRadialItem({
			{
				label = 'Police Menu',
				menu = 'policeradial'
			}
		})
	end

	if not menu.init then
		menu.init = true
		if menu.type == 'none' then
			menu.type = 'menu'
		end
	end
end

function RefreshPerms()
    if NetworkIsPlayerActive(cache.playerId) then
		access = lib.callback.await("policecheckaccess")
		loadouts = lib.callback.await("policegetloadouts")
    end
end

function FuckingCommand()
    if access then
		if menu.type == 'menu' or menu.type == 'none' then
			lib.showMenu("policemenu")
		elseif menu.type == 'context' then
			lib.showContext('policecontext')
		elseif menu.type == 'radial' then
			ShowNotification("Current menu is Radial; please use the radial key.")
		end
	else
		ShowNotification("Error: No permission")
    end
end

RegisterCommand("openpm", FuckingCommand,false)
--End *Menu creation and permissions*


--Loadout/Weapons
function LoadoutOptions()
	local options = {}
    for k, v in pairs(loadouts) do
        if v.access then
			if menu.type == 'menu' or menu.type == 'none' then
				table.insert(options, #options+1, {
					label = v.name,
					description = "Spawn loadout: "..v.name,
					args = v.weapons
				})
			elseif menu.type == 'context' then
				table.insert(options, #options+1, {
					title = v.name,
					description = "Spawn loadout: "..v.name,
					onSelect = function()
						HandleWeapons(v.weapons)
					end
				})
			elseif menu.type == 'radial' then
				table.insert(options, #options+1, {
					label = v.name,
					onSelect = function()
						HandleWeapons(v.weapons)
					end
				})
			end
        end
    end
	return options
end

function HandleWeapons(weapons)
    RemoveAllPedWeapons(cache.ped, true)
    local spawn = weapons.spawn
    local attach = weapons.attachments
	if spawn then
		if attach[1] then
        	for _,v in pairs(attach) do
        		for _,value in pairs(spawn) do
        		    GiveWeaponToPed(cache.ped, GetHashKey(value.spawn), 9999, false, false)
        	    	GiveWeaponComponentToPed(cache.ped, GetHashKey(value.spawn), GetHashKey(v))
        		end
			end
		else
			for _,value in pairs(spawn) do
				GiveWeaponToPed(cache.ped, GetHashKey(value.spawn), 9999, false, false)
			end
		end
    else
        print("No weapons to spawn")
    end
end
--End *Loadout/Weapons*


--Actions
function PlayerCuffed()
	if not cuffed then
		ShowNotification("Player Cuffed")
		cuffed = true
	else
		ShowNotification("Player Uncuffed")
		dragged = false
		cuffed = false
		Citizen.Wait(100)
		ClearPedTasksImmediately(cache.ped)
	end
end

RegisterNetEvent('dragplayer')
AddEventHandler('dragplayer', function(otherplayer)
	if cuffed then
		isdragging = not isdragging
		plhplayer = tonumber(otherplayer)
		ShowNotification("Dragging Player")
	else
		ShowNotification("Dragging Player Stopped")
	end
end)

RegisterNetEvent('removeplayerweapons')
AddEventHandler('removeplayerweapons', function()
    RemoveAllPedWeapons(cache.ped, true)
end)


RegisterNetEvent('pm:c:vehicletoggle')
AddEventHandler('pm:c:vehicletoggle', function()
	if cuffed and not invehicle then
		local vehicleHandle, vehicleCoords = lib.getClosestVehicle(GetEntityCoords(cache.ped), 2)
		if vehicleHandle ~= nil then
			SetPedIntoVehicle(cache.ped, vehicleHandle, 2)
		end
	else
		ClearPedTasksImmediately(cache.ped)
		playercoords = GetEntityCoords(cache.ped, true)
		local xnew = playercoords.x+2
		local ynew = playercoords.y+2
	
		SetEntityCoords(cache.ped, xnew, ynew, playercoords.z)
	end
	invehicle = not invehicle
end)

RegisterNetEvent('forceplayerintovehicle')
AddEventHandler('forceplayerintovehicle', function()
	if cuffed then
		local vehicleHandle, vehicleCoords = lib.getClosestVehicle(GetEntityCoords(cache.ped), 2)
		if vehicleHandle ~= nil then
			SetPedIntoVehicle(cache.ped, vehicleHandle, 2)
		end
	end
end)

RegisterNetEvent('removeplayerfromvehicle')
AddEventHandler('removeplayerfromvehicle', function(otherplayer)
	local ped = GetPlayerPed(otherplayer)
	ClearPedTasksImmediately(ped)
	playercoords = GetEntityCoords(cache.ped, true)
	local xnew = playercoords.x+2
	local ynew = playercoords.y+2

	SetEntityCoords(cache.ped, xnew, ynew, playercoords.z)
end)

RegisterNetEvent('cuffplayer')
AddEventHandler('cuffplayer', PlayerCuffed)

function DisableControls()
    DisableControlAction(1, 140, true)
    DisableControlAction(1, 141, true)
    DisableControlAction(1, 142, true)
    --SetPedPathCanUseLadders(player, false)
end

function PlayerHandsup()
    ExecuteCommand("e handsup")
end

function PlayerSurrender()
    ExecuteCommand("e surrender")
end

function PlayerUncuffing()
    ExecuteCommand("e uncuff")
end

function PlayerCancelEmote()
    ExecuteCommand("e c")
end

function HandleDrag()
    while cuffed or dragged or isdragging do
		Citizen.Wait(0)
		if cuffed == true then
			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(0)
			end
			while IsPedBeingStunned(cache.ped, false) do
				ClearPedTasksImmediately(cache.ped)
			end
			TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 16, 0, 0, 0, 0)
            DisableControls()
		end
		if IsPlayerDead(cache.ped) then
			cuffed = false
			isdragging = false
            dragged = false
		end
		if isdragging then
			local ped = GetPlayerPed(GetPlayerFromServerId(plhplayer))
			AttachEntityToEntity(cache.ped, ped, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			dragged = true
		else
			if not IsPedInParachuteFreeFall(cache.ped) and dragged then
				dragged = false
				DetachEntity(cache.ped, true, false)
			end
		end
	end
end


function GetClosestPlayer()
	local closestPlayer,closestPed,closestDistance = lib.GetClosestPlayer(GetEntityCoords(cache.ped, false), 3)
	
	if closestPlayer then
		closestDistance = #(GetEntityCoords(cache.ped, false) - closestDistance)
	else
		closestPlayer, closestDistance = -1,-1
	end

	return closestPlayer, closestDistance
end

function RemoveWeapons()
    local closeplayer, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("removeplayerweapons", GetPlayerServerId(closeplayer))
    else
        ShowNotification("Error: No Player Near")
    end
end

function ToggleCuffs()
	local closeplayer, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("cuffplayer", GetPlayerServerId(closeplayer))
		ShowNotification("Player Cuffed")
	else
		ShowNotification("Error: No Player Near")
	end
end

function ToggleDrag()
	local closeplayer, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("dragplayer", GetPlayerServerId(closeplayer))
	else
		ShowNotification("Error: No Player Near")
	end
end

function ToggleVehicle()
	local closeplayer, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		TriggerServerEvent("pm:s:vehicletoggle", GetPlayerServerId(closeplayer))
	else
		ShowNotification("Error: No Player Near")
	end
end

function HandleActionCommands()
	if Config.ActionCommands.cuffing then
		RegisterNetEvent('ToggleCuffs', function()
			ToggleCuffs()
		end)
	end
	if Config.ActionCommands.dragging then
		RegisterNetEvent('ToggleDrag', function()
			ToggleDrag()
		end)
	end
	if Config.ActionCommands.spikes then
		RegisterNetEvent('ToggleSpikes', function()
			ToggleSpikes()
		end)
	end
	if Config.ActionCommands.vehicle then
		RegisterNetEvent('ToggleVehicle', function()
			ToggleVehicle()
		end)
	end
end

function HandleCommands()
	if Config.Commands.handsup or Config.Commands.kneel then
		for _,v in pairs(Config.Commands.handsup) do
			RegisterCommand(v, PlayerHandsup)
		end
		for _,v in pairs(Config.Commands.kneel) do
			RegisterCommand(v, PlayerSurrender)
		end
	end
end

function HandleKeyMapping()
	if Config.KeyMapping then
		for i,v in pairs(Config.KeyMapping) do
			RegisterKeyMapping(tostring(i), "Default keymap from johnspolicemenu", "keyboard", tostring(v))
		end
	end
	--Registers Keymapping to open Police Menu
	RegisterKeyMapping("openpm", "Open Police Menu", "keyboard", tostring(Config.MenuKey))
end

HandleCommands()
HandleActionCommands()
HandleKeyMapping()
--End *Actions*