
progressbar = exports.vorp_progressbar:initiate()

RegisterNetEvent('fists-packingcrates:crateItems', function(craftableItems)
    local FeatherMenu = exports['feather-menu'].initiate()
    local packagingMenu = FeatherMenu:RegisterMenu('packagingMenu', {
        top = '40%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        draggable = true,
    })
    
    local packagingPage = packagingMenu:RegisterPage('packagingOptions')
    packagingPage:RegisterElement('header', {value = 'Packaging Options', slot = "header"})

    for _, item in ipairs(craftableItems) do
        packagingPage:RegisterElement('button', {
            label = "package " .. item.label,
            slot = "content",
            id = item.name,
        }, function()
            TriggerEvent('fists-crates:StartPackingAnimation', item.name)
            Wait(8000)
            TriggerServerEvent('crafting:craftItem', item.name)
        end)
    end
    
    packagingMenu:Open({startupPage = packagingPage})
end)



RegisterNetEvent('fists-crates:StartCraftingAnimation', function(crateLabel)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Start the progress bar
    progressbar.start('Unpacking ' .. crateLabel .. '...', 8000, function()
    end, 'innercircle')
    
    -- Play the animation
    local animDict = "amb_work@world_human_hammer_kneel_stakes@male@male_a@base"
    local animName = "base"
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)
    Wait(8000) -- Wait for the duration of the progress bar
    ClearPedTasks(playerPed)
end)


RegisterNetEvent('fists-crates:StartPackingAnimation', function(crateLabel)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Start the progress bar
    progressbar.start('Packing ' .. crateLabel .. '...', 8000, function()
    end, 'innercircle')
    
    -- Play the animation
    local animDict = "amb_work@world_human_hammer_kneel_stakes@male@male_a@base"
    local animName = "base"
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
    
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)
    Wait(8000) -- Wait for the duration of the progress bar
    ClearPedTasks(playerPed)
end)