local Class = require 'lib/class'
local CONFIG = require 'config'

Bird = Class {}

function Bird:init(image)
    self.image = image
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = (CONFIG.VIRTUAL_WIDTH - self.width) / 2
    self.y = (CONFIG.VIRTUAL_HEIGHT - self.height) / 2
    self.dy = 0
end

function Bird:update(dt)
    self.y = self.y + self.dy

    if love.keyboard.wasPressed('space') then
        self.dy = self.dy + CONFIG.FLY_FORCE * dt
    else
        self.dy = self.dy + CONFIG.GRAVITY_FORCE * dt
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
