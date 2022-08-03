local CONFIG = require 'config'

local function load_fonts()
    return {
        ['small'] = love.graphics.newFont(CONFIG.ASSETS.FONTS.PATH, 8),
        ['score'] = love.graphics.newFont(CONFIG.ASSETS.FONTS.PATH, 32),
    }
end

local function load_sounds()
    return {
        ['paddle_hit'] = love.audio.newSource(CONFIG.ASSETS.SOUNDS.paddle_hit, 'static'),
        ['score'] = love.audio.newSource(CONFIG.ASSETS.SOUNDS.score, 'static'),
        ['wall_hit'] = love.audio.newSource(CONFIG.ASSETS.SOUNDS.wall_hit, 'static'),
    }
end

local function load_assets()
    local fonts = load_fonts()
    local sounds = load_sounds()

    return {
        ['sounds'] = sounds,
        ['fonts'] = fonts,
    }
end

return {
    ["load"] = load_assets,
}
