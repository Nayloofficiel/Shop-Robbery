local ESX = exports['es_extended']:getSharedObject()

-- Fonction pour envoyer un message sur Discord
function SendDiscordLog(message)
    local data = {
        ['content'] = message,
        ['username'] = 'Logs Braquage',
        ['avatar_url'] = 'https://i.imgur.com/8ntGdEA.png',
    }

    PerformHttpRequest(Config.webhookUrl, function(statusCode, response, headers)
        if statusCode ~= 204 then
            print("Erreur lors de l'envoi du log Discord: " .. statusCode)
        end
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

-- Donner l'argent au joueur
RegisterServerEvent('braquage:giveMoney')
AddEventHandler('braquage:giveMoney', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local amount = math.random(Config.minMoney, Config.maxMoney)
        xPlayer.addMoney(amount)

        -- Notification réussite côté client
        TriggerClientEvent('ox_lib:notify', source, {
            title = "Braquage Supérette",
            description = "Vous avez reçu " .. amount .. " € pour le braquage !",
            position = 'top',
            style = 'success',
            duration = 5000
        })

        -- Log Discord pour le braquage
        local playerName = xPlayer.getName()
        local logMessage = string.format(
            "Braquage réussi par **%s**. Montant obtenu : **%d €**",
            playerName, amount
        )
        SendDiscordLog(logMessage)

        -- Notification aux forces de l'ordre
        for _, job in pairs(Config.policeJobs) do
            local players = ESX.GetExtendedPlayers('job', job)
            for _, police in pairs(players) do
                TriggerClientEvent('ox_lib:notify', police.source, {
                    title = "Alerte Braquage",
                    description = "Un braquage est en cours dans une supérette !",
                    position = 'top',
                    style = 'error',
                    duration = 5000
                })
            end
        end
    else
        print("ERREUR : Impossible de trouver le joueur pour donner l'argent.")
    end
end)
