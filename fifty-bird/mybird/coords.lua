local function left(coords)
    return math.min(coords.x_start, coords.x_end)
end

local function right(coords)
    return math.max(coords.x_start, coords.x_end)
end

local function top(coords)
    return math.min(coords.y_start, coords.y_end)
end

local function bottom(coords)
    return math.max(coords.y_start, coords.y_end)
end

return {
    ["left"] = left,
    ["right"] = right,
    ["top"] = top,
    ["bottom"] = bottom,
}
