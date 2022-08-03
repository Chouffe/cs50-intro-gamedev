local CONFIG = require 'config'

local function render(paddle)
    love.graphics.rectangle('fill', paddle.x, paddle.y, paddle.width, paddle.height)
end

local function coords(paddle)
    return {
        ["x_start"] = paddle.x,
        ["y_start"] = paddle.y,
        ["x_end"] = paddle.x + paddle.width,
        ["y_end"] = paddle.y + paddle.height,
    }
end

-- TODO: should only use dy and dx to update here
-- One should not couple the control keys with the update
local function update(control_keys, is_down_fn, paddle, dt)
    if is_down_fn(control_keys.up) then
        paddle.y = math.max(0, paddle.y - CONFIG.PADDLE.SPEED * dt)
    elseif is_down_fn(control_keys.down) then
        paddle.y = math.min(CONFIG.VIRTUAL.HEIGHT - CONFIG.PADDLE.HEIGHT,
            paddle.y + CONFIG.PADDLE.SPEED * dt)
    end
    return paddle
end

return {
    ["render"] = render,
    ["coords"] = coords,
    ["update"] = update,
}
