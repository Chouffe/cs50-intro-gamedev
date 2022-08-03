local function load_images()
    return {
        ['background'] = love.graphics.newImage('assets/images/background.png'),
        ['ground'] = love.graphics.newImage('assets/images/ground.png'),
        ['bird'] = love.graphics.newImage('assets/images/bird.png'),
        ['pipe'] = love.graphics.newImage('assets/images/pipe.png'),
    }
end

local function load_fonts()
    return {
        ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('assets/fonts/flappy.ttf', 14),
        ['flappy'] = love.graphics.newFont('assets/fonts/flappy.ttf', 28),
        ['huge'] = love.graphics.newFont('assets/fonts/flappy.ttf', 56),
    }
end

local function load_assets()
    return {
        ['fonts'] = load_fonts(),
        ['images'] = load_images(),
    }
end

return {
    ["load"] = load_assets,
}
