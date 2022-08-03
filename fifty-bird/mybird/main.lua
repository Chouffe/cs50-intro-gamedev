--[[
    GD50
    Flappy Bird Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple 
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping 
    the screen, making the player's bird avatar flap its wings and move upwards slightly. 
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- virtual resolution handling library
local push = require 'lib/push'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

BACKGROUND_SCROLL_SPEED = 30
BACKGROUND_LOOPING_POINT = 413
GROUND_SCROLL_SPEED = 60

local function load_assets()
    -- images we load into memory from files to later draw onto the screen
    local images = {
        ['background'] = love.graphics.newImage('assets/images/background.png'),
        ['ground'] = love.graphics.newImage('assets/images/ground.png'),
    }
    return {
        ['images'] = images,
    }
end

local function get_initial_gamestate()
    return {
        ['background_scroll'] = 0,
        ['ground_scroll'] = 0,
    }
end

function love.load()
    -- Load assets needed for the game in the `love.assets` table
    love.assets = load_assets()

    -- Load the gamestate
    love.gamestate = get_initial_gamestate()

    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Fifty Bird')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    love.gamestate.background_scroll = (love.gamestate.background_scroll +
        BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    love.gamestate.ground_scroll = (love.gamestate.ground_scroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

function love.draw()
    push:start()

    -- draw the background
    love.graphics.draw(love.assets.images.background, -love.gamestate.background_scroll, 0)

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(love.assets.images.ground, -love.gamestate.ground_scroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
