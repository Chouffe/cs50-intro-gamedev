local function load_images()
    return {
        ['background'] = love.graphics.newImage('assets/images/background.png'),
        ['ground'] = love.graphics.newImage('assets/images/ground.png'),
        ['bird'] = love.graphics.newImage('assets/images/bird.png'),
        ['pipe'] = love.graphics.newImage('assets/images/pipe.png'),
    }
end

local function load_sounds()
    return {
        ['jump'] = love.audio.newSource('assets/sounds/jump.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/sounds/hurt.wav', 'static'),
        ['explosion'] = love.audio.newSource('assets/sounds/explosion.wav', 'static'),
        ['music'] = love.audio.newSource('assets/sounds/marios_way.mp3', 'static')
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
        ['sounds'] = load_sounds(),
    }
end

return {
    ["load"] = load_assets,
}
