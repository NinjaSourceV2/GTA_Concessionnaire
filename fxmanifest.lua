fx_version 'cerulean'
game 'gta5'

author 'SuperCoolNinja'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config/config.lua',
    'server/server.lua'
}

client_scripts {
    'config/config.lua',
    'client/client_utils.lua',
    'client/client_main.lua'
}