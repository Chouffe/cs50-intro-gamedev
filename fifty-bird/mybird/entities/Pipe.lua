local Class = require 'lib/class'
local CONFIG = require 'config'

Pipe = Class {}

function Pipe:init(image, orientation, y)
    self.orientation = orientation
    self.x = CONFIG.VIRTUAL_WIDTH
    self.y = y
    self.image = image
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Pipe:update(dt)
    self.x = self.x - CONFIG.GROUND_SCROLL_SPEED * dt
end

function Pipe:render()
    if self.orientation == 'top' then
        love.graphics.draw(self.image, self.x, self.y, 0, 1, -1)
    elseif self.orientation == 'bottom' then
        love.graphics.draw(self.image, self.x, self.y)
    end
end

function Pipe:coords()
    if self.orientation == 'bottom' then
        return {
            ["x_start"] = self.x,
            ["x_end"] = self.x + self.width,
            ["y_start"] = self.y,
            ["y_end"] = self.y + self.height,
        }
    else
        return {
            ["x_start"] = self.x,
            ["x_end"] = self.x + self.width,
            ["y_start"] = self.y - self.height,
            ["y_end"] = self.y,
        }
    end
end
