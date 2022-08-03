local Class = require 'lib/class'
local CONFIG = require 'config'

Pipe = Class {}

function Pipe:init()
    self.x = CONFIG.VIRTUAL_WIDTH
    self.y = math.random(CONFIG.VIRTUAL_HEIGHT / 4, CONFIG.VIRTUAL_HEIGHT)
    self.image = love.assets.images.pipe
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Pipe:update(dt)
    self.x = self.x - CONFIG.GROUND_SCROLL_SPEED * dt
end

function Pipe:render(dt)
    love.graphics.draw(self.image, self.x, self.y)
end
