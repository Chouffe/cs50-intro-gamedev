--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

local Class = require 'lib/class'
local CONFIG = require 'config'
local gamestate = require 'gamestate'
local util_math = require 'util/math'
local hitbox = require 'hitbox'

require 'entities/Bird'

PlayState = Class { __includes = BaseState }

function PlayState:init()
    -- Load the gamestate
    -- TODO: how can we thread the assets properly here instead of relying on global variables?
    self.gamestate = gamestate.get_initial_gamestate(love.assets)
end

function PlayState:update(dt)

    self.gamestate.entities.bird:update(dt)
    self.gamestate.spawn_pipe_timer = self.gamestate.spawn_pipe_timer + dt

    if self.gamestate.spawn_pipe_timer > CONFIG.SPAWN_TIMER_DELTA then
        local pipe_pair_y = util_math.clamp(
            self.gamestate.last_y + math.random(-CONFIG.PIPE_HEIGHT_MAX_VARIATION, CONFIG.PIPE_HEIGHT_MAX_VARIATION)
            ,
            CONFIG.GROUND_HEIGHT,
            CONFIG.VIRTUAL_HEIGHT
        )
        table.insert(
            self.gamestate.entities.pipe_pairs,
            PipePair(love.assets.images.pipe, pipe_pair_y)
        )
        self.gamestate.last_y = pipe_pair_y
        self.gamestate.spawn_pipe_timer = 0
    end

    for _, pipe_pair in pairs(self.gamestate.entities.pipe_pairs) do
        pipe_pair:update(dt)
    end

    for k, pipe_pair in pairs(self.gamestate.entities.pipe_pairs) do
        if pipe_pair.remove then
            table.remove(self.gamestate.entities.pipe_pairs, k)
        end
    end

    -- Collisions
    local bird = self.gamestate.entities.bird

    -- With Ground
    if bird.y + bird.height > CONFIG.VIRTUAL_HEIGHT - CONFIG.GROUND_HEIGHT then
        gStateMachine:change('title')
    end

    -- With Top
    if bird.y < 0 then
        gStateMachine:change('title')
    end

    -- With pipes
    for _, pipe_pair in pairs(self.gamestate.entities.pipe_pairs) do
        for _, pipe in pairs(pipe_pair.pair) do
            if hitbox.collides(pipe:coords(), bird:coords()) then
                gStateMachine:change('title')
            end
        end
    end
end

function PlayState:render()
    for _, pipe_pair in pairs(self.gamestate.entities.pipe_pairs) do
        pipe_pair:render()

        -- Show hitboxes for debugging
        local bottom_pipe = pipe_pair.pair.bottom
        local bottom_coords = bottom_pipe:coords()
        love.graphics.rectangle('line', bottom_coords.x_start, bottom_coords.y_start, bottom_pipe.width,
            bottom_pipe.height)

        local top_pipe = pipe_pair.pair.top
        local top_coords = top_pipe:coords()
        love.graphics.rectangle('line', top_coords.x_start, top_coords.y_start, top_pipe.width, top_pipe.height)
    end

    self.gamestate.entities.bird:render()
end