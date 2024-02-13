fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'johnspolicerework'
description 'Police Menu for Menu servers'
version '1.2.5'
url 'https://github.com/chickenlord01/johnspolicerework'
author 'JohnL#6869'

shared_scripts {
    '@ox_lib/init.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}

dependencies {
	'ox_lib',
	--'dpemotes'
}
