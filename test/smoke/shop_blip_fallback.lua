-- A bad configured blip category must warn once, fall back to no category and
-- must not abort the blip loop.
local H = dofile("test/harness.lua")
local logSpy = dofile("test/logging_spy.lua")

Config = { kora_inventory = {} }
dofile("shared.lua")

local created = {}
Kora = { blips = { create = function(_, options)
    if options.category == "Convenience Store" then
        error("Unknown blip category Convenience Store.")
    end
    created[#created + 1] = options
    return #created
end } }

local blip = KoraInventory.createShopBlip("Config.x.blip.category", { x = 1, y = 2, z = 3 },
    { category = "Convenience Store", name = "24/7" })

H.equal(blip, 1, "blip is still created after a bad category")
H.equal(created[1].category, nil, "fallback blip has no category")
H.equal(created[1].name, "24/7", "fallback keeps other options")
H.equal(#logSpy.calls, 1, "one warning is logged")
local warning = logSpy.calls[1]
H.equal(warning.level, "warn", "the rejection is a warning")
H.equal(warning.event, "blips.category_rejected", "stable event name")
H.equal(warning.fields.option, "Config.x.blip.category", "warning names the option")
H.equal(warning.fields.category, "Convenience Store", "warning names the value")
H.ok(warning.fields.error:find("Unknown blip category", 1, true), "the error rides in fields.error")

H.finish()
