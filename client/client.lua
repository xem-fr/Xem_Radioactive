local activeZone = nil
local zoneBlip = nil
local dangerBlip = nil
local spawnedCrates = {}
local spawnedZombies = {}
local currentWave = 0
local totalWaves = 3
local crateUnlocked = false

-- Fonction pour lancer une vague de zombies
function SpawnZombieWave(zoneCoords)
    local zombieModel = `u_m_o_filmnoir`
    local zombiesPerWave = 10  -- Nombre de zombies par vague
    currentWave = currentWave + 1

    lib.notify({
        title = "🦟‍♂️ Vague " .. currentWave,
        description = "Une nouvelle vague de zombies approche...",
        type = "warning"
    })

    for i = 1, zombiesPerWave do
        local offset = vector3(math.random(-15, 15), math.random(-15, 15), 0)
        local spawnCoords = zoneCoords + offset

        local zombie = exports.hrs_zombies_V2:SpawnPed(zombieModel, spawnCoords)
        SetEntityAsMissionEntity(zombie, true, true)
        table.insert(spawnedZombies, zombie)
    end

    -- Surveiller les zombies pour vérifier s'ils sont éliminés
    MonitorZombies(zoneCoords)
end

-- Vérifie si tous les zombies sont éliminés pour passer à la vague suivante
function MonitorZombies(zoneCoords)
    Citizen.CreateThread(function()
        while #spawnedZombies > 0 do
            for i = #spawnedZombies, 1, -1 do
                if not DoesEntityExist(spawnedZombies[i]) or IsEntityDead(spawnedZombies[i]) then
                    table.remove(spawnedZombies, i)
                end
            end
            Citizen.Wait(1000)
        end

        if currentWave < totalWaves then
            Citizen.Wait(20000) -- Pause de 10 secondes entre les vagues
            SpawnZombieWave(zoneCoords)
        else
            lib.notify({
                title = "📦 Caisse Débloquée",
                description = "Vous avez survécu aux vagues de zombies ! La caisse est maintenant accessible.",
                type = "success"
            })
            crateUnlocked = true
            SpawnCrate(zoneCoords)
        end
    end)
end

-- Surveillance des radiations
function MonitorRadiation()
    local wasProtected = false
    local isVisualEffectApplied = false

    Citizen.CreateThread(function()
        while activeZone do
            Citizen.Wait(Config.RadioactiveZones.damageInterval)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            if #(playerCoords - activeZone) < 50.0 then
                if not HasRadioactiveProtection() then
                    if not isVisualEffectApplied then
                        StartScreenEffect("DrugsTrevorClownsFight", 0, true)
                        isVisualEffectApplied = true
                    end
                    ApplyDamageToPed(playerPed, Config.RadioactiveZones.damageAmount, false)
                    lib.notify({
                        title = "☢️ Radiations",
                        description = "Vous êtes exposé à des radiations mortelles !",
                        type = "error"
                    })
                    wasProtected = false
                elseif not wasProtected then
                    if isVisualEffectApplied then
                        StopScreenEffect("DrugsTrevorClownsFight")
                        isVisualEffectApplied = false
                    end
                    ClearPedBloodDamage(playerPed)
                    lib.notify({
                        title = "☢️ Protection Active",
                        description = "Votre masque à gaz vous protège des radiations.",
                        type = "success"
                    })
                    wasProtected = true
                end
            else
                if isVisualEffectApplied then
                    StopScreenEffect("DrugsTrevorClownsFight")
                    isVisualEffectApplied = false
                end
            end
        end
    end)
end

-- Vérifie si le joueur porte un masque de protection
function HasRadioactiveProtection()
    local playerPed = PlayerPedId()
    local maskProp = GetPedDrawableVariation(playerPed, 1)
    return maskProp == Config.RadioactiveZones.maskItemId
end

-- Activation de la zone radioactive
RegisterNetEvent("radioactive:activateZone")
AddEventHandler("radioactive:activateZone", function(zoneCoords)
    activeZone = zoneCoords
    currentWave = 0
    spawnedZombies = {}
    crateUnlocked = false

    lib.notify({
        title = "⚠️ Zone Radioactive Active",
        description = "Une zone hautement radioactive est apparue... Préparez-vous à affronter des créatures hostiles !",
        type = "warning"
    })

    -- Blip pour la zone radioactive
    zoneBlip = AddBlipForRadius(activeZone.x, activeZone.y, activeZone.z, 50.0)
    SetBlipHighDetail(zoneBlip, true)
    SetBlipColour(zoneBlip, 5)
    SetBlipAlpha(zoneBlip, 128)

    dangerBlip = AddBlipForCoord(activeZone)
    SetBlipSprite(dangerBlip, 161)
    SetBlipScale(dangerBlip, 1.2)
    SetBlipColour(dangerBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zone Radioactive")
    EndTextCommandSetBlipName(dangerBlip)

    -- Lancer la première vague de zombies
    SpawnZombieWave(activeZone)
    MonitorRadiation()
end)

-- Spawn de la caisse après les vagues de zombies
function SpawnCrate(coords)
    TriggerEvent("radioactive:spawnCrate", coords)
end

-- Spawn d'une caisse radioactive
-- Spawn d'une caisse radioactive avec suppression automatique après 5 minutes
RegisterNetEvent("radioactive:spawnCrate")
AddEventHandler("radioactive:spawnCrate", function(coords)
    local model = Config.RadioactiveZones.crateModel
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end

    local crate = CreateObject(model, coords.x, coords.y, coords.z - 0.3, true, true, false)
    PlaceObjectOnGroundProperly(crate)
    FreezeEntityPosition(crate, true)
    table.insert(spawnedCrates, crate)

    exports.ox_target:addLocalEntity(crate, {
        {
            name = "open_crate",
            label = "📦 Ouvrir la Caisse",
            icon = "fa-solid fa-box",
            onSelect = function()
                if crateUnlocked then
                    OpenCrate(crate)
                else
                    lib.notify({
                        title = "🚫 Caisse Verrouillée",
                        description = "Vous devez terminer toutes les vagues de zombies avant d'accéder à la caisse.",
                        type = "error"
                    })
                end
            end
        }
    })

    -- Suppression automatique après 5 minutes si la caisse n'est pas ouverte
    Citizen.SetTimeout(900000, function()
        if DoesEntityExist(crate) then
            DeleteEntity(crate)
            lib.notify({
                title = "📦 Caisse Disparue",
                description = "La caisse radioactive a disparu car elle n'a pas été récupérée à temps.",
                type = "info"
            })
        end
    end)
end)


-- Fonction pour ouvrir la caisse
function OpenCrate(crate)
    lib.progressCircle({
        duration = 1000,
        position = "bottom",
        useWhileDead = false,
        canCancel = false,
        label = "Ouverture de la caisse...",
        anim = { dict = "mini@repair", clip = "fixing_a_ped" }
    })

    Citizen.Wait(1000)
    TriggerServerEvent('radioactive:giveLoot')
    DeleteEntity(crate)
end

-- Désactivation de la zone radioactive
RegisterNetEvent("radioactive:deactivateZone")
AddEventHandler("radioactive:deactivateZone", function()
    activeZone = nil

    if zoneBlip then
        RemoveBlip(zoneBlip)
        zoneBlip = nil
    end

    if dangerBlip then
        RemoveBlip(dangerBlip)
        dangerBlip = nil
    end

    -- Nettoyage des zombies restants
    for _, zombie in ipairs(spawnedZombies) do
        if DoesEntityExist(zombie) then
            DeleteEntity(zombie)
        end
    end
    spawnedZombies = {}

    -- Suppression des caisses restantes
    for _, crate in ipairs(spawnedCrates) do
        if DoesEntityExist(crate) then
            DeleteEntity(crate)
        end
    end
    spawnedCrates = {}

    StopScreenEffect("DrugsTrevorClownsFight")

    lib.notify({
        title = "☢️ Zone Dissipée",
        description = "La zone radioactive s'est dissipée. Vous êtes en sécurité... pour l'instant.",
        type = "info"
    })
end)

-- Commande pour activer manuellement la zone radioactive
RegisterCommand("startZone", function()
    local zoneCoords = vector3(2209.9749, 5609.6084, 53.7099) -- Coordonnées fixes pour la zone radioactive
    TriggerEvent("radioactive:activateZone", zoneCoords)
end, false)
