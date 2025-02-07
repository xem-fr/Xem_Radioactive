
lua54 'yes'
fx_version 'cerulean' 
game 'gta5' 

author 'xem' 
description 'Zones de Loot Radioactives Dynamiques'
version '1.0.0' 


dependencies {
    'hrs_zombies_V2', 
    'ox_target',        
    'ox_lib' 
}


server_scripts {
    'config.lua', 
    'server/server.lua' 
}


client_scripts {
    'config.lua', 
    'client/client.lua' 
}


shared_scripts {
    'config.lua', 
    '@ox_lib/init.lua'
}

