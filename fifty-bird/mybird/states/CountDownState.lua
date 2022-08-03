--[[
    CountDown Class
]]

local Class = require 'lib/class'
local CONFIG = require 'config'

CountDownState = Class { __includes = BaseState }

function CountDownState:enter(params)
    self.assets = params.assets
end

function CountDownState:init()
    self.count = 3
    self.timer = 0
end

function CountDownState:update(dt)
    if self.timer > 1 then
        self.count = self.count - 1
        self.timer = self.timer - 1
    end

    self.timer = self.timer + dt

    if self.count <= 0 then
        gStateMachine:change('play', { assets = self.assets })
    end
end

function CountDownState:render()
    love.graphics.setFont(self.assets.fonts.huge)
    love.graphics.printf(tostring(self.count), 0, CONFIG.VIRTUAL_HEIGHT / 3, CONFIG.VIRTUAL_WIDTH, 'center')
end
