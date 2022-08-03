local Class = require 'lib/class'
local CONFIG = require 'config'

Bird = Class {}

function Bird:init()
    self.image = love.assets.images.bird
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = (CONFIG.VIRTUAL_WIDTH - self.width) / 2
    self.y = (CONFIG.VIRTUAL_HEIGHT - self.height) / 2
    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + CONFIG.GRAVITY * dt
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end