Config = {}

Config.Closeonaction = false
Config.CheckVersion = true

--WIP
--'none','radial','context','menu'
--none will allow the player to change the type of menu they want
Config.ForceType = 'none'

--Toggles actions true/false
Config.Actions = {
	cuffing = true,
	dragging = true,
	removefromvehicle = true,
	removeweapons = true,
	spikes = true
}

--If any of these are toggled to true use ace permissions for the commands EX: add_ace identifier.steam:1100001155f7f59 command.cuff allow #John
Config.ActionCommands = {
	cuffing = false,  --Permission (command.cuff)
	dragging = false, --Permission (command.drag)
	vehicle = false,  --Permission (command.vehiclepm)
	spikes = false    --Permission (command.spikes)
}

--You can add more command strings to this. For example /hu is "hu" in the handsup list.
Config.Commands = {
	handsup = {
		"hu",
	},
	kneel = {
		"k",
		"kneel",
	}
}

--You add the command name in the [""] like shown below. Then you set it equal to whatever key you want to map it too. (whenever a player connects and press the key it is mapped too, they run the command assigned.)
Config.KeyMapping = {
	--Commented out because once the keymapping is set and a player joins, the only way to remove it is for the player to remove it themselves. (EX. Press F8 to open console and type "unbind keyboard THEKEY")
	--["handsup"] = "H",
	--["kneel"] = "G",
}

--Configuration for loadouts
Config.Loadouts = {
	["sheriff"] = {
		name = "LEO Loadout",
		access = true,
		weapons = {
			spawn = {
				WEAPON_COMBATPISTOL,
				WEAPON_NIGHTSTICK,
				WEAPON_FLASHLIGHT,
				WEAPON_STUNGUN,
				WEAPON_CARBINERIFLE,
				WEAPON_PUMPSHOTGUN,
				WEAPON_FLARE
			},
			attachments = {
				WEAPON_COMBATPISTOL.flashlight,
				WEAPON_PUMPSHOTGUN.flashlight,
				WEAPON_CARBINERIFLE.flashlight,
				WEAPON_CARBINERIFLE.sight,
				WEAPON_CARBINERIFLE.grip,
			}
		},
	},
	["fireems"] = {
		name = "Fire/EMS Loadout",
		access = true,
		weapons = {
			spawn = {
				WEAPON_FLASHLIGHT,
				WEAPON_HATCHET,
				WEAPON_FLARE,
				WEAPON_FIREEXTINGUISHER
			},
			attachments = {}
		},
	},
	["sru"] = {
		name = "SRU Loadout",
		access = true,
		weapons = {
			spawn = {
				WEAPON_HEAVYPISTOL,
				WEAPON_STUNGUN,
				WEAPON_PUMPSHOTGUN,
				WEAPON_CARBINERIFLE,
				WEAPON_SMG_MK2,
				WEAPON_NIGHTSTICK,
				WEAPON_FLASHLIGHT,
				WEAPON_FLARE,
				WEAPON_BZGAS,
				WEAPON_SNIPERRIFLE
			},
			attachments = {
				WEAPON_HEAVYPISTOL.flashlight,
				WEAPON_PUMPSHOTGUN.flashlight,
				WEAPON_CARBINERIFLE.flashlight,
				WEAPON_CARBINERIFLE.sight,
				WEAPON_CARBINERIFLE.grip,
				WEAPON_SMG_MK2.flashlight,
				WEAPON_SMG_MK2.rounds,
				WEAPON_SMG_MK2.comp,
				WEAPON_SMG_MK2.sight2
			}
		},
	},
	--[[["mil"] = {
		name = "Military Loadout",
		access = false,
		weapons = {
			spawn = {
				WEAPON_PISTOL_MK2,
				WEAPON_STUNGUN,
				WEAPON_NIGHTSTICK,
				WEAPON_FLASHLIGHT,
				WEAPON_CARBINERIFLE_MK2,
				WEAPON_HEAVYSNIPER_MK2,
				WEAPON_BZGAS,
				WEAPON_FLARE,
				WEAPON_COMBATMG_MK2,
				WEAPON_TACTICALKNIFE
			},
			attachments = {
				WEAPON_HEAVYPISTOL.flashlight,
				WEAPON_PUMPSHOTGUN.flashlight,
				WEAPON_CARBINERIFLE_MK2.flashlight,
				WEAPON_CARBINERIFLE_MK2.sight,
				WEAPON_CARBINERIFLE_MK2.grip,
				WEAPON_CARBINERIFLE_MK2.barrel2,
				WEAPON_COMBATMG_MK2.sight,
				WEAPON_COMBATMG_MK2.barrel2,
				WEAPON_HEAVYSNIPER_MK2.sight4,
				WEAPON_HEAVYSNIPER_MK2.suppressor
			}
		},
	},
	["gt1s"] = {
		name = "GT1S Loadout",
		access = false,
		weapons = {
			spawn = {
				WEAPON_KNIFE,
				WEAPON_FLAREGUN,
				WEAPON_FLASHLIGHT,
				WEAPON_HEAVYPISTOL,
				WEAPON_SNSPISTOL,
				WEAPON_SPECIALCARBINE_MK2,
				WEAPON_SNIPERRIFLE,
				WEAPON_SMG_MK2,
				WEAPON_STUNGUN
			},
			attachments = {
				WEAPON_HEAVYPISTOL.flashlight,
				WEAPON_SPECIALCARBINE_MK2.flashlight,
				WEAPON_SPECIALCARBINE_MK2.sight,
				WEAPON_SPECIALCARBINE_MK2.muzzle2,
				WEAPON_SPECIALCARBINE_MK2.grip,
				WEAPON_SMG_MK2.flashlight,
				WEAPON_SMG_MK2.muzzle5,
				WEAPON_SMG_MK2.sight,
				WEAPON_SNIPERRIFLE.sight2
			}
		},
	},]]
}

--Don't touch unless you know what you are doing.
Config.AceAccessPerm = "policemenu.open"

--Sets key to open menu
Config.MenuKey = "F9"

--Shows notification
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end



--Turns commands off if actions are off (Delete this if you dont want the commands and actions to be linked)
if not Config.Actions.cuffing then
	Config.ActionCommands.cuffing = false
end
if not Config.Actions.dragging then
	Config.ActionCommands.dragging = false
end
if not Config.Actions.spikes then
	Config.ActionCommands.spikes = false
end
if not Config.Actions.removefromvehicle then
	Config.ActionCommands.vehicle = false
end
--End Delete