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
RegisterServerEvent("fists-packingcrates:createCrates")
AddEventHandler("fists-packingcrates:createCrates", function(crateName)
    local _source = source
    for _, crate in ipairs(config.crates) do
        if crate.name == crateName then
            local emptyCrateAmount = exports.vorp_inventory:getItemCount(_source, nil, config.emptyCrate, nil)

            if emptyCrateAmount < 1 then
                TriggerClientEvent("vorp:TipBottom", _source, "You need an empty crate to craft: " .. crate.label, 4000)
                return
            end
            local itemAmount = exports.vorp_inventory:getItemCount(_source, nil, crate.requiredItem, nil)
            if itemAmount >= crate.requiredQuantity then
                exports.vorp_inventory:canCarryItem(_source, crateName, 1, function(canCarry)
                    if not canCarry then
                        TriggerClientEvent("vorp:TipBottom", _source, "You cannot carry more of " .. crate.label, 4000)
                        return
                    else

                        exports.vorp_inventory:subItem(_source, crate.requiredItem, crate.requiredQuantity, nil)
                        exports.vorp_inventory:subItem(_source, config.emptyCrate, 1, nil)
                        exports.vorp_inventory:addItem(_source, crateName, 1, nil)
                        TriggerClientEvent("vorp:TipBottom", _source, "Crafted: " .. crate.label, 4000)
                        checkCraftableItems(_source)
                    end
                end)
            else
                TriggerClientEvent("vorp:TipBottom", _source, "Not enough items to craft: " .. crate.label, 4000)
            end
            break
        end
    end
end)


-- Register crates as usable and check if player has required items to craft
for _, crate in ipairs(config.crates) do
    exports.vorp_inventory:registerUsableItem(crate.name, function(data)
        local _source = data.source
        crateCount = exports.vorp_inventory:getItemCount(_source, nil, crate.name)
        if crateCount >= 1 then
            exports.vorp_inventory:canCarryItem(_source, crate.requiredItem, crate.requiredQuantity, function(canCarryRequiredItem)
                if not canCarryRequiredItem then
                    TriggerClientEvent("vorp:TipBottom", _source, "You cannot carry more of " .. crate.requiredItem, 4000)
                    return 
                else
                TriggerClientEvent('fists-crates:StartCraftingAnimation', _source, crate.label)
                Wait(config.craftTime)
                exports.vorp_inventory:addItem(_source, crate.requiredItem, crate.requiredQuantity)
                exports.vorp_inventory:addItem(_source, config.emptyCrate, 1)
                exports.vorp_inventory:subItem(_source, crate.name, 1)
                TriggerClientEvent("vorp:TipRight", _source, "You have unpacked a " .. crate.label, 3000)
                end
            end)
        else
            TriggerClientEvent("vorp:TipRight", _source, "You don't have enough items to create a " .. crate.label, 3000)
        end
    end)
end