fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'johnspolicerework'
description 'Police Menu for Menu servers'
version '1.2.2'
url 'https://github.com/chickenlord01/johnspolicerework'
author 'JohnL#6869'

shared_scripts {
    '@ox_lib/init.lua',
	'config/weapons.lua',
	'config/config.lua'
}

client_scripts {
	'spikestrips/client.lua',
	'client.lua'
}

server_scripts {
	'spikestrips/server.lua',
	'server.lua'
}

dependencies {
	'ox_lib',
	--'dpemotes'
}
