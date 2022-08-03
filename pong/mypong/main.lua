local push = require 'lib/push'
local inspect = require 'lib/inspect'

local CONFIG = require 'config'
local hitbox = require 'hitbox'
local paddle = require 'paddle'
local ball = require 'ball'
local gamestate = require 'gamestate'
local assets = require 'assets'

-- Mutable tables that hold the game state and loaded assets
Assets = {}
GameState = {}

function love.load()
    Assets = assets.load()
    GameState = gamestate.get_initial_game_state()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(Assets.fonts.small)

    push:setupScreen(
        CONFIG.VIRTUAL.WIDTH,
        CONFIG.VIRTUAL.HEIGHT,
        CONFIG.WINDOW.WIDTH,
        CONFIG.WINDOW.HEIGHT,
        {
            fullscreen = false,
            resizable = false,
            vsync = true,
        })
end

local function player_update(player, dt)
    paddle.update(player.control_keys, love.keyboard.isDown, player.paddle, dt)
end

function love.update(dt)

    if gamestate.is_game_done(GameState) then
        GameState.mode = 'done'
    end

    -- Intersection calculations
    local paddle_player1 = GameState.entities.player1.paddle
    local paddle_player2 = GameState.entities.player2.paddle
    local ball_paddle_player1_intersection = hitbox.has_intersection(ball.coords(GameState.entities.ball),
        paddle.coords(paddle_player1))
    local ball_paddle_player2_intersection = hitbox.has_intersection(ball.coords(GameState.entities.ball),
        paddle.coords(paddle_player2))

    player_update(GameState.entities.player1, dt)
    player_update(GameState.entities.player2, dt)

    if ball_paddle_player2_intersection or ball_paddle_player1_intersection then
        Assets.sounds.paddle_hit:play()
    end

    if GameState.mode == 'play' then
        -- Threading the collisions to the update function
        ball.update(
            Assets.sounds.score,
            Assets.sounds.wall_hit,
            ball_paddle_player1_intersection,
            ball_paddle_player2_intersection,
            GameState,
            dt)
    end
end

local function play_keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        GameState.mode = 'start'
    end
end

local function start_keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        GameState.mode = 'play'
    end
end

local function draw_serving_player()
    -- Return a random number between 1 and 2
    return math.random(2)
end

local function done_keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        GameState = gamestate.get_initial_game_state()
        local serving_player = draw_serving_player()
        GameState.entities.ball = ball.reset(serving_player)
        GameState.mode = 'play'
    end
end

function love.keypressed(key)
    if GameState.mode == 'play' then
        play_keypressed(key)
    elseif GameState.mode == 'done' then
        done_keypressed(key)
    elseif GameState.mode == 'start' then
        local serving_player = draw_serving_player()
        GameState.entities.ball = ball.reset(serving_player)
        start_keypressed(key)
    end
end

local function draw_scores(CONFIG, font, score1, score2)
    love.graphics.setFont(font)
    love.graphics.print(
        tostring(score1),
        CONFIG.VIRTUAL.WIDTH / 2 - 50,
        CONFIG.VIRTUAL.HEIGHT / 3)

    love.graphics.print(
        tostring(score2),
        CONFIG.VIRTUAL.WIDTH / 2 + 30,
        CONFIG.VIRTUAL.HEIGHT / 3)
end

local function displayFPS(font)
    -- simple FPS display across all states
    love.graphics.setFont(font)
    love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    love.graphics.clear(
        CONFIG.BACKGROUND.COLOR.r,
        CONFIG.BACKGROUND.COLOR.g,
        CONFIG.BACKGROUND.COLOR.b,
        CONFIG.BACKGROUND.COLOR.a
    )

    if GameState.mode == 'start' then
        love.graphics.setFont(Assets.fonts.small)
        love.graphics.printf('Press Enter to start', 0, 20, CONFIG.VIRTUAL.WIDTH, 'center')
        draw_scores(CONFIG, Assets.fonts.score, GameState.entities.player1.score, GameState.entities.player2.score)
    elseif GameState.mode == 'done' then
        local msg = ''
        if GameState.entities.player1.score > GameState.entities.player2.score then
            msg = 'Player 1 won!'
        else
            msg = 'Player 2 won!'
        end
        love.graphics.setFont(Assets.fonts.small)
        love.graphics.printf(msg, 0, 50, CONFIG.VIRTUAL.WIDTH, 'center')
        love.graphics.printf('Press Enter to play again', 0, 20, CONFIG.VIRTUAL.WIDTH, 'center')
        draw_scores(CONFIG, Assets.fonts.score, GameState.entities.player1.score, GameState.entities.player2.score)
    end

    paddle.render(GameState.entities.player1.paddle)
    paddle.render(GameState.entities.player2.paddle)
    ball.render(GameState.entities.ball)
    displayFPS(Assets.fonts.small)

    -- end rendering at virtual resolution
    push:apply('end')
end
