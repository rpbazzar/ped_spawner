fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Zara'
description 'Freecam Ped Spawner — scroll=change, LMB=spawn, RMB=despawn, Backspace=exit. Naam ped ke sar ke uppar. peds.lua me store (restart + shared proof).'
version '1.0.0'

-- ox_lib chahiye (notify + model helpers ke liye)
dependency 'ox_lib'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua',
}

-- peds.lua data file (LoadResourceFile se padha jata hai — script nahi)
files {
    'peds.lua',
}
