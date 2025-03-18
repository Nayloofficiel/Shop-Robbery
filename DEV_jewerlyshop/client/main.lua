local isRobbing = false
local ESX = exports['es_extended']:getSharedObject()

-- Fonction pour obtenir le job du joueur
local function GetPlayerJob()
    local playerData = ESX.GetPlayerData()
    return playerData and playerData.job and playerData.job.name or "unemployed"
end

-- Création du PNJ derrière la caisse
function SpawnStoreKeeper(coords)
    local model = GetHashKey(Config.pnjModel)

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    -- Calculer la direction correcte pour le PNJ
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    
    -- Ajuster l'orientation du PNJ pour qu'il soit dans la bonne direction
    SetEntityHeading(ped, coords.w)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    return ped
end

-- Ajouter l'interaction ox_target
function SetupTarget(ped)
    exports.ox_target:addLocalEntity(ped, {
        {
            label = "Braquer la superette",
            icon = "fa-solid fa-sack-dollar",
            onSelect = function()
                local job = GetPlayerJob()
                if job == Config.requiredJob then
                    StartRobbery(ped)
                else
                    TriggerEvent('ox_lib:notify', {
                        title = "Braquage",
                        description = "Vous ne pouvez pas braquer en étant " .. job,
                        position = 'top',
                        style = 'error',
                        duration = 5000
                    })
                end
            end
        }
    })
end

-- Lancer le braquage
function StartRobbery(ped)
    if isRobbing then return end
    isRobbing = true

    -- Lancer l'animation du PNJ qui remplit le sac
    RequestAnimDict("mp_am_hold_up")
    while not HasAnimDictLoaded("mp_am_hold_up") do
        Wait(10)
    end
    TaskPlayAnim(ped, "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, Config.braquageTime * 1000, 1, 0, false, false, false)

    -- Barre de progression
    exports.ox_lib:progressBar({
        duration = Config.braquageTime * 1000,
        label = "Braquage en cours...",
        useWhileDead = false,
        canCancel = true,
        disableMouse = false,
    })
    TriggerServerEvent('braquage:giveMoney')

    isRobbing = false
end

-- Spawner les PNJs dans chaque superette
Citizen.CreateThread(function()
    for _, store in pairs(Config.superettes) do
        local ped = SpawnStoreKeeper(store.location)
        SetupTarget(ped)
    end
end)
