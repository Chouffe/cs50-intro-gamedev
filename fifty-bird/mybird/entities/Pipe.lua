local Class = require 'lib/class'
local CONFIG = require 'config'

Pipe = Class {}

function Pipe:init(orientation, y)
    self.orientation = orientation
    self.x = CONFIG.VIRTUAL_WIDTH
    self.y = y
    self.image = love.assets.images.pipe
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Pipe:update(dt)
    self.x = self.x - CONFIG.GROUND_SCROLL_SPEED * dt
end

function Pipe:render(dt)
    if self.orientation == 'top' then
        love.graphics.draw(self.image, self.x, self.y, 0, 1, -1)
    elseif self.orientation == 'bottom' then
        love.graphics.draw(self.image, self.x, self.y)
    end
end
