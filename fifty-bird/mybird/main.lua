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
local gamestate = require 'gamestate'
local assets = require 'assets'

require 'entities/Bird'
require 'entities/PipePair'

-- all code related to game state and state machines
require 'lib/StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountDownState'

-- Global StateMachine for mode transitions
gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end,
    ['countdown'] = function() return CountDownState() end,
}

local function reset_keys_pressed()
    love.keyboard.keysPressed = {}
end

function love.load()
    -- Load assets needed for the game in the `love.assets` table
    love.assets = assets.load()
    local loaded_assets = assets.load()

    -- Load the gamestate
    love.gamestate = gamestate.get_initial_gamestate(loaded_assets)

    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- initialize default font
    love.graphics.setFont(loaded_assets.fonts.flappy)

    -- app window title
    love.window.setTitle('Fifty Bird')

    -- Start music in a loop
    loaded_assets.sounds.music:setLooping(true)
    loaded_assets.sounds.music:play()

    -- initialize our virtual resolution
    push:setupScreen(
        CONFIG.VIRTUAL_WIDTH,
        CONFIG.VIRTUAL_HEIGHT,
        CONFIG.WINDOW_WIDTH,
        CONFIG.WINDOW_HEIGHT,
        {
            vsync = true,
            fullscreen = false,
            resizable = true
        }
    )

    -- Start with the title screen
    gStateMachine:change('title', { assets = loaded_assets })

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

    -- now, we just update the state machine, which defers to the right state
    gStateMachine:update(dt)

    -- Should be move to all gamestate instead so that we can get rid of the love.gamestate dep
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    love.gamestate.background_scroll = (love.gamestate.background_scroll +
        CONFIG.BACKGROUND_SCROLL_SPEED * dt) % CONFIG.BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    love.gamestate.ground_scroll = (love.gamestate.ground_scroll + CONFIG.GROUND_SCROLL_SPEED * dt) %
        CONFIG.VIRTUAL_WIDTH

    reset_keys_pressed()
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    push:start()

    -- Should be moved to all screens instead so that we can get rid of the love.assets dep
    -- draw the background
    love.graphics.draw(love.assets.images.background, -love.gamestate.background_scroll, 0)

    gStateMachine:render()

    love.graphics.setColor(1, 1, 1, 1)

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(love.assets.images.ground, -love.gamestate.ground_scroll,
        CONFIG.VIRTUAL_HEIGHT - CONFIG.GROUND_HEIGHT)

    push:finish()
end
