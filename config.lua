
Config = {}


Config.RadioactiveZones = {
    spawnInterval = 30 * 60000,  -- Apparition toutes les 30 minutes
    duration = 20 * 60000,       -- La zone reste active pendant 15 minutes
    damageInterval = 3000,       -- Dégâts toutes les 3 secondes sans masque
    damageAmount = 10,           -- Dégâts infligés par intervalle
    maskItemId = 61,            -- ID du masque à gaz
    crateModel = `prop_box_wood01a`,  -- Modèle de caisse en bois
    lootItems = {
        { item = "metaux", count = math.random(1, 5) },
        { item = "plastic", count = math.random(1, 3) },
        { item = "water", count = 1 }
    },  
    locations = {
        vector3(2209.9749, 5609.6084, 53.7099)
        --vector3(1700.0, 6400.0, 32.0),
        --vector3(2600.0, 4900.0, 44.0),
        --vector3(2900.0, 4300.0, 50.0)
    }
}