config = {}

config.debug = true
config.emptyCrate = "empty_crate" --DB name of the item to use as the empty crate

config.crates = {
    {
        name = "strawberry_crate", -- DB Name of the crate
        label = "Strawberry Crate", -- Label of the crate
        requiredItem = "strawberry", -- Required item to create the crate
        requiredQuantity = 50, -- Required quantity of the item to create the crate

    },
    {
        name = "alaskan_ginseng_crate", -- DB Name of the crate
        label = "Alaskan Ginsneg Crate", -- Label of the crate
        requiredItem = "alaskan_ginseng", -- Required item to create the crate
        requiredQuantity = 50, -- Required quantity of the item to create the crate

    },
}