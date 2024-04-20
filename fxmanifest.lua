fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_scripts {
	"@ox_lib/init.lua",
	"@frp_core/lib/i18n.lua",
	"locale/*.lua"
}

client_scripts {
	"@frp_core/lib/utils.lua",
	'client.lua',
}

server_scripts {
	"@frp_core/lib/utils.lua",
	'server.lua'
}

files{
	'./html/*',
	'./config/locale_ui.js',
	'./html/css/*',
	'./html/font/*',
	'./html/img/*',
	'./html/js/*'
}

ui_page 'html/ui.html'

lua54 'yes'