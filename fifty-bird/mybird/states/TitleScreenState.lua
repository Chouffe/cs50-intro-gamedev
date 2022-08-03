--[[
    TitleScreenState Class
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

local Class = require 'lib/class'
local CONFIG = require 'config'

TitleScreenState = Class { __includes = BaseState }

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function TitleScreenState:render()
    -- TODO: how do we cleanly thread these assets?
    love.graphics.setFont(love.assets.fonts.flappy)
    love.graphics.printf('Fifty Bird', 0, 64, CONFIG.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(love.assets.fonts.medium)
    love.graphics.printf('Press Enter', 0, 100, CONFIG.VIRTUAL_WIDTH, 'center')
end
