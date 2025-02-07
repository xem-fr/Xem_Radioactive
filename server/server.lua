ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.RadioactiveZones.spawnInterval)

        local randomIndex = math.random(1, #Config.RadioactiveZones.locations)
        local selectedZone = Config.RadioactiveZones.locations[randomIndex]

        TriggerClientEvent("radioactive:activateZone", -1, selectedZone)
        SpawnRadioactiveLoot(selectedZone)

        Citizen.Wait(Config.RadioactiveZones.duration)
        TriggerClientEvent("radioactive:deactivateZone", -1)
    end
end)

function SpawnRadioactiveLoot(zoneCoords)
    for i = 1, 5 do -- Actuellement, 5 caisses sont générées
        local randomOffset = vector3(math.random(-10, 10), math.random(-10, 10), 0)
        local crateCoords = zoneCoords + randomOffset

        TriggerClientEvent('radioactive:spawnCrate', -1, crateCoords)
    end
end


RegisterNetEvent('radioactive:giveLoot')
AddEventHandler('radioactive:giveLoot', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local lootTable = Config.RadioactiveZones.lootItems
    local numberOfItems = math.random(2, 4) -- Choisir entre 2 et 4 objets par caisse

    local collectedItems = {}  -- Pour stocker les objets récupérés

    for i = 1, numberOfItems do
        local randomLoot = lootTable[math.random(1, #lootTable)]
        xPlayer.addInventoryItem(randomLoot.item, randomLoot.count)
        table.insert(collectedItems, randomLoot.count .. "x " .. randomLoot.item)
    end

    -- Notification avec tous les loots obtenus
    TriggerClientEvent('ox_lib:notify', src, {
        title = "Loot Collecté",
        description = "Vous avez trouvé :\n" .. table.concat(collectedItems, "\n"),
        type = "success"
    })
end)

