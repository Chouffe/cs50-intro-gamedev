local luaunit = require 'lib/luaunit'
local hitbox = require 'hitbox'

function test_hitbox_has_intersection()
    local coords1 = { x_start = 0, y_start = 0, x_end = 2, y_end = 2 }
    local coords2 = { x_start = 0, y_start = 0, x_end = 1, y_end = 1 }
    local coords3 = { x_start = 10, y_start = 10, x_end = 11, y_end = 11 }
    luaunit.assertEquals(hitbox.has_intersection(coords1, coords1), true)
    luaunit.assertEquals(hitbox.has_intersection(coords1, coords2), true)
    luaunit.assertEquals(hitbox.has_intersection(coords1, coords3), false)

end

os.exit(luaunit.LuaUnit.run())
