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
local Class = require 'lib/class'
local CONFIG = require 'config'

require 'entities/Bird'
require 'entities/Pipe'

local function load_assets()
    -- images we load into memory from files to later draw onto the screen
    local images = {
        ['background'] = love.graphics.newImage('assets/images/background.png'),
        ['ground'] = love.graphics.newImage('assets/images/ground.png'),
        ['bird'] = love.graphics.newImage('assets/images/bird.png'),
        ['pipe'] = love.graphics.newImage('assets/images/pipe.png'),
    }
    return {
        ['images'] = images,
    }
end

local function get_initial_gamestate()
    return {
        ['entities'] = {
            ['pipes'] = {},
            ['bird'] = Bird(),
        },
        ['background_scroll'] = 0,
        ['ground_scroll'] = 0,
        ['spawn_pipe_timer'] = 0,
    }
end

local function reset_keys_pressed()
    love.keyboard.keysPressed = {}
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
    push:setupScreen(CONFIG.VIRTUAL_WIDTH, CONFIG.VIRTUAL_HEIGHT, CONFIG.WINDOW_WIDTH, CONFIG.WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    reset_keys_pressed()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    love.gamestate.background_scroll = (love.gamestate.background_scroll +
        CONFIG.BACKGROUND_SCROLL_SPEED * dt) % CONFIG.BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    love.gamestate.ground_scroll = (love.gamestate.ground_scroll + CONFIG.GROUND_SCROLL_SPEED * dt) %
        CONFIG.VIRTUAL_WIDTH

    love.gamestate.entities.bird:update(dt)
    love.gamestate.spawn_pipe_timer = love.gamestate.spawn_pipe_timer + dt

    -- MOVE the spawn rate in config
    if love.gamestate.spawn_pipe_timer > 2 then
        table.insert(love.gamestate.entities.pipes, Pipe())
        love.gamestate.spawn_pipe_timer = 0
    end

    for k, pipe in pairs(love.gamestate.entities.pipes) do
        pipe:update(dt)
    end

    for k, pipe in pairs(love.gamestate.entities.pipes) do
        if pipe.x + pipe.width < 0 then
            table.remove(love.gamestate.entities.pipes, k)
        end
    end

    reset_keys_pressed()
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    push:start()

    -- draw the background
    love.graphics.draw(love.assets.images.background, -love.gamestate.background_scroll, 0)

    for k, pipe in pairs(love.gamestate.entities.pipes) do
        pipe:render()
    end

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(love.assets.images.ground, -love.gamestate.ground_scroll, CONFIG.VIRTUAL_HEIGHT - 16)

    love.gamestate.entities.bird:render()

    push:finish()
end
