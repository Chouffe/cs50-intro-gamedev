local Class = require 'lib/class'
local CONFIG = require 'config'
local util_math = require 'util/math'

require 'entities/Pipe'

PipePair = Class {}

function PipePair:init(last_y)

    self.x = CONFIG.VIRTUAL_WIDTH
    self.image = love.assets.images.pipe
    self.height = self.image:getHeight()
    self.width = self.image:getWidth()
    local bottom_y = util_math.clamp(last_y + math.random(-25, 25), 15, CONFIG.VIRTUAL_HEIGHT)
    self.pair = {
        ['bottom'] = Pipe('bottom', bottom_y),
        ['top'] = Pipe('top', bottom_y - CONFIG.PIPE_GAP),
    }
end

function PipePair:update(dt)
    self.pair.bottom:update(dt)
    self.pair.top:update(dt)
end

function PipePair:render()
    self.pair.bottom:render()
    self.pair.top:render()
end
