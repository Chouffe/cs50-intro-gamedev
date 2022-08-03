--[[
    ScoreState Class
]]

local Class = require 'lib/class'
local CONFIG = require 'config'

ScoreState = Class { __includes = BaseState }

function ScoreState:enter(params)
    self.score = params.score
    self.assets = params.assets
end

function ScoreState:update(_)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown', { assets = self.assets })
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(love.assets.fonts.flappy)
    love.graphics.printf('Oof! You lost!', 0, 64, CONFIG.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(love.assets.fonts.medium)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, CONFIG.VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, CONFIG.VIRTUAL_WIDTH, 'center')
end
