fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_scripts {
	"@ox_lib/init.lua",
	"@frp_lib/library/linker.lua",
	"locale/*.lua"
}

client_scripts {
	"config/config.lua",

	'client/main.lua',
	'client/camera.lua',
	'client/scene.lua',
}

server_scripts {
	'server.lua'
}

files{
	'./html/*',
	'./html/css/*',
	'./html/font/*',
	'./html/img/*',
	'./html/js/*'
}

ui_page 'html/ui.html'

lua54 'yes'