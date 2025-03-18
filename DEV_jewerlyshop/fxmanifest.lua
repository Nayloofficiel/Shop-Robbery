fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'Naylo'
description 'GlowDev Asso -- Braquage Superette'

client_scripts {
    'shared/*.lua',
    'client/*.lua'
}

server_scripts {
    'shared/*.lua',
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}