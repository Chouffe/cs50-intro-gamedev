local CONFIG = require 'config'

local function render(ball)
    love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)
end

local function reset(serving_player)
    local dx = serving_player == 1 and 130 or -130
    local dy = math.random(-50, 50) * 1.5
    return {
        ['width'] = CONFIG.BALL.WIDTH,
        ['height'] = CONFIG.BALL.HEIGHT,
        ['x'] = (CONFIG.VIRTUAL.WIDTH + CONFIG.BALL.WIDTH) / 2,
        ['y'] = (CONFIG.VIRTUAL.HEIGHT + CONFIG.BALL.HEIGHT) / 2,
        ['dx'] = dx,
        ['dy'] = dy,
    }
end

local function coords(ball)
    return {
        ["x_start"] = ball.x,
        ["y_start"] = ball.y,
        ["x_end"] = ball.x + ball.width,
        ["y_end"] = ball.y + ball.height,
    }
end

-- How do we deal with logic across different entities?
local function update(score_sound, wall_hit_sound, paddle1_collision, paddle2_collision, GameState, dt)
    local ball = GameState.entities.ball

    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Reflection
    if ball.y <= 0 then
        ball.dy = -ball.dy
        wall_hit_sound:play()
    elseif ball.y >= CONFIG.VIRTUAL.HEIGHT - CONFIG.BALL.HEIGHT then
        ball.dy = -ball.dy
        wall_hit_sound:play()
    end

    if paddle1_collision then
        ball.dx = -ball.dx + math.random(1, 15)
        ball.dy = ball.dy + math.random(-50, 50)
        ball.x = GameState.entities.player1.paddle.x + CONFIG.PADDLE.WIDTH + 1
    elseif paddle2_collision then
        ball.dx = -ball.dx - math.random(1, 15)
        ball.dy = ball.dy + math.random(-50, 50)
        ball.x = GameState.entities.player2.paddle.x - 1 - CONFIG.BALL.WIDTH
    end

    if ball.x <= 0 then
        score_sound:play()
        local serving_player = 2
        ball = reset(serving_player)
        GameState.mode = 'start'
        GameState.entities.player2.score = GameState.entities.player2.score + 1
    elseif ball.x >= CONFIG.VIRTUAL.WIDTH then
        score_sound:play()
        local serving_player = 1
        ball = reset(serving_player)
        GameState.mode = 'start'
        GameState.entities.player1.score = GameState.entities.player1.score + 1
    end
    return ball
end

return {
    ["render"] = render,
    ["coords"] = coords,
    ["reset"] = reset,
    ["update"] = update,
}
