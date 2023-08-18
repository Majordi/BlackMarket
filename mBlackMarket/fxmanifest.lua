fx_version "adamant"
author "Majordi#2222"
game "gta5"

shared_script "config.lua"
client_script "client.lua"
server_script "server.lua"

ui_page "NUI/index.html"

files {
    "NUI/index.html",
    "NUI/style.css",
    "NUI/index.js",
    "NUI/src/image/*",
    
    -- weapons && items images
    "NUI/src/image/**/*",
    "NUI/src/sounds/*",
}