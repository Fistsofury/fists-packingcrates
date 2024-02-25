local VORPcore = exports.vorp_core:GetCore()

function registerCrate()
    exports.vorp_inventory:registerUsableItem(config.emptyCrate, function(data)
        TriggerClientEvent("fists-crates:openCrate", data._source, config.crates)
    end)
end










exports.vorp_inventory:registerUsableItem(item, callback)