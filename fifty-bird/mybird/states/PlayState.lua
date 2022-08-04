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
    -- self.gamestate = gamestate.get_initial_gamestate(love.assets)
end

function PlayState:enter(params)
    self.assets = params.assets
    self.gamestate = gamestate.get_initial_gamestate(self.assets)
end

function PlayState:update(dt)

    if love.keyboard.wasPressed('d') then
        self.gamestate.debug = not self.gamestate.debug
    end

    if love.keyboard.wasPressed('p') then
        if self.gamestate.pause then
            love.audio.play(self.assets.sounds.music)
        end
        self.gamestate.pause = not self.gamestate.pause
    end

    if self.gamestate.pause then

        -- Compensate for the parallax scrolling
        love.gamestate.background_scroll = (love.gamestate.background_scroll -
            CONFIG.BACKGROUND_SCROLL_SPEED * dt) % CONFIG.BACKGROUND_LOOPING_POINT

        -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
        love.gamestate.ground_scroll = (love.gamestate.ground_scroll - CONFIG.GROUND_SCROLL_SPEED * dt) %
            CONFIG.VIRTUAL_WIDTH
    else
        local bird = self.gamestate.entities.bird
        bird:update(dt)

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
                PipePair(self.assets.images.pipe, pipe_pair_y)
            )
            self.gamestate.last_y = pipe_pair_y
            self.gamestate.spawn_pipe_timer = 0
        end

        for _, pipe_pair in pairs(self.gamestate.entities.pipe_pairs) do
            if not pipe_pair.scored then
                if pipe_pair.x + pipe_pair.width < bird.x then
                    self.gamestate.score = self.gamestate.score + 1
                    self.assets.sounds.score:play()
                    pipe_pair.scored = true
                end

            end

            pipe_pair:update(dt)
        end

        for k, pipe_pair in pairs(self.gamestate.entities.pipe_pairs) do
            if pipe_pair.remove then
                table.remove(self.gamestate.entities.pipe_pairs, k)
            end
        end

        -- With Ground
        if bird.y + bird.height > CONFIG.VIRTUAL_HEIGHT - CONFIG.GROUND_HEIGHT then
            gStateMachine:change('score', { assets = self.assets, score = self.gamestate.score })
            self.assets.sounds.hurt:play()
            self.assets.sounds.explosion:play()
        end

        -- With Top
        if bird.y < 0 then
            gStateMachine:change('score', { assets = self.assets, score = self.gamestate.score })
            self.assets.sounds.hurt:play()
            self.assets.sounds.explosion:play()
        end

        -- With pipes
        for _, pipe_pair in pairs(self.gamestate.entities.pipe_pairs) do
            for _, pipe in pairs(pipe_pair.pair) do
                if hitbox.collides(pipe:coords(), bird:coords()) then
                    gStateMachine:change('score', { assets = self.assets, score = self.gamestate.score })
                    self.assets.sounds.hurt:play()
                    self.assets.sounds.explosion:play()
                end
            end
        end
    end
end

local function displayFPS(font)
    -- simple FPS display across all states
    love.graphics.setFont(font)
    love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
    love.graphics.printf('FPS: ' .. tostring(love.timer.getFPS()), 10, 10, CONFIG.VIRTUAL_WIDTH - 20, 'right')
end

function PlayState:render()
    for _, pipe_pair in pairs(self.gamestate.entities.pipe_pairs) do
        pipe_pair:render()

        -- Show hitboxes for debugging
        -- local bottom_pipe = pipe_pair.pair.bottom
        -- local bottom_coords = bottom_pipe:coords()
        -- love.graphics.rectangle('line', bottom_coords.x_start, bottom_coords.y_start, bottom_pipe.width,
        --     bottom_pipe.height)

        -- local top_pipe = pipe_pair.pair.top
        -- local top_coords = top_pipe:coords()
        -- love.graphics.rectangle('line', top_coords.x_start, top_coords.y_start, top_pipe.width, top_pipe.height)
    end

    self.gamestate.entities.bird:render()

    -- Render score
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(self.assets.fonts.medium)
    love.graphics.printf("Score: " .. tostring(self.gamestate.score), 10, 10, CONFIG.VIRTUAL_WIDTH, 'left')

    if self.gamestate.debug then
        displayFPS(self.assets.fonts.small)
    end

    if self.gamestate.pause then
        love.audio.pause(self.assets.sounds.music)
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.setFont(self.assets.fonts.flappy)
        love.graphics.printf('Game paused', 0, 64, CONFIG.VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(self.assets.fonts.medium)
        love.graphics.printf('Press p to resume', 0, 96, CONFIG.VIRTUAL_WIDTH, 'center')
    end

end
