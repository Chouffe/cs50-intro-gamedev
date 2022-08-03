local function clamp(num, min, max)
    return math.min(math.max(num, min), max)
end

return {
    ["clamp"] = clamp,
}
