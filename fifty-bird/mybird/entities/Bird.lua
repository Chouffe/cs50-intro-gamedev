local Class = require 'lib/class'
local CONFIG = require 'config'

Bird = Class {}

function Bird:init(image, jump_sound)
    self.image = image
    self.jump_sound = jump_sound
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
        self.jump_sound:play()
    else
        self.dy = self.dy + CONFIG.GRAVITY_FORCE * dt
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:coords()
    return {
        ["x_start"] = self.x,
        ["x_end"] = self.x + self.width,
        ["y_start"] = self.y,
        ["y_end"] = self.y + self.width,
    }
end
