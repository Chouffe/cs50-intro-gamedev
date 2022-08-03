local coords = require 'coords'

local function has_intersection(coords1, coords2)
    local left1, top1, right1, bottom1 = coords.left(coords1), coords.top(coords1), coords.right(coords1),
        coords.bottom(coords1)
    local left2, top2, right2, bottom2 = coords.left(coords2), coords.top(coords2), coords.right(coords2),
        coords.bottom(coords2)
    return left1 < right2
        and right1 > left2
        and top1 < bottom2
        and bottom1 > top2
end

return {
    ['has_intersection'] = has_intersection,
}
