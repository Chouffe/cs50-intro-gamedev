local Class = require 'lib/class'
local CONFIG = require 'config'
local util_math = require 'util/math'

require 'entities/Pipe'

PipePair = Class {}

function PipePair:init(image, y)

    self.x = CONFIG.VIRTUAL_WIDTH
    self.image = image
    self.height = self.image:getHeight()
    self.width = self.image:getWidth()
    self.pair = {
        ['bottom'] = Pipe(image, 'bottom', y),
        ['top'] = Pipe(image, 'top', y - CONFIG.PIPE_GAP),
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
