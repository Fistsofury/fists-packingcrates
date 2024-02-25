local VORPcore = exports.vorp_core:GetCore()



-- Function to check player's inventory and send craftable options
local function checkCraftableItems(source)
    local _source = source
    local craftableItems = {}
    exports.vorp_inventory:getUserInventoryItems(_source, function(inventory)
        for _, crate in ipairs(config.crates) do
            local itemAmount = exports.vorp_inventory:getItemCount(_source, nil, crate.requiredItem, nil)
            if itemAmount >= crate.requiredQuantity then
                table.insert(craftableItems, crate)
            end
        end
        TriggerClientEvent("fists-packingcrates:crateItems", source, craftableItems)
    end)
end

-- Register empty crate as usable and check craftable items when used
exports.vorp_inventory:registerUsableItem(config.emptyCrate, function(data)
    checkCraftableItems(data.source)
end)

-- Crafting event
RegisterServerEvent("crafting:craftItem")
AddEventHandler("crafting:craftItem", function(crateName)
    local _source = source
    for _, crate in ipairs(config.crates) do
        if crate.name == crateName then
            local itemAmount = exports.vorp_inventory:getItemCount(_source, nil, crate.requiredItem, nil)
            if itemAmount >= crate.requiredQuantity then
                -- Subtract required items and empty crate, add crafted crate
                exports.vorp_inventory:subItem(_source, crate.requiredItem, crate.requiredQuantity, nil)
                exports.vorp_inventory:subItem(_source, config.emptyCrate, 1, nil)
                exports.vorp_inventory:addItem(_source, crateName, 1, nil)
                TriggerClientEvent("vorp:TipBottom", _source, "Crafted: " .. crate.label, 4000)
                checkCraftableItems(_source)
            else
                TriggerClientEvent("vorp:TipBottom", _source, "Not enough items to craft: " .. crate.label, 4000)
            end
            break
        end
    end
end)

for _, crate in ipairs(config.crates) do
    exports.vorp_inventory:registerUsableItem(crate.name, function(data)
        local _source = data.source
        crateCount = exports.vorp_inventory:getItemCount(_source, nil, crate.name)
        if crateCount >= 1 then
            TriggerClientEvent('fists-crates:StartCraftingAnimation', _source, crate.label)
            Wait(8000)
            exports.vorp_inventory:addItem(_source, crate.requiredItem, crate.requiredQuantity)
            exports.vorp_inventory:addItem(_source, config.emptyCrate, 1)
            exports.vorp_inventory:subItem(_source, crate.name, 1)
            TriggerClientEvent("vorp:TipRight", _source, "You have created a " .. crate.label, 3000)
        else
            TriggerClientEvent("vorp:TipRight", _source, "You don't have enough items to create a " .. crate.label, 3000)
        end
    end)
end