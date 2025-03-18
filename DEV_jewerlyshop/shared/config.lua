Config = {}

-- Temps du braquage (en secondes)
Config.braquageTime = 5

-- Argent donné lors du braquage
Config.argentReward = 5000

-- Plage de l'argent aléatoire à donner lors du braquage
Config.minMoney = 1000  -- Montant minimum
Config.maxMoney = 5000  -- Montant maximum

-- Liste des superettes
Config.superettes = {
    {name = "Superette 1", location = vector3(24.4083, -1345.1733, 29.4970), argent_reward = Config.argentReward},
    {name = "Superette 2", location = vector3(-706.2, -913.4, 19.2), argent_reward = Config.argentReward},
    {name = "Superette 3", location = vector3(1134.2056, -982.0448, 46.4155), argent_reward = Config.argentReward},
}

-- Liste des jobs autorisés à recevoir la notification
Config.notifyJobs = {"pnwl", "gnwl"}

-- PNJ du braquage
Config.pnjModel = "mp_m_shopkeep_01"

-- Job requis pour braquer
Config.requiredJob = "unemployed"

-- Webhook logs discord
Config.webhookUrl = "https://discord.com/api/webhooks/1351619516446019674/6bKFpuWyG_zdB6rHqMTlJNvm6iWrtKYVGFWFAIVSg9W9EZOEZtN-6hIbUUazQdB6rgtX"