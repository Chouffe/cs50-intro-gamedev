local CONFIG = require 'config'

local function get_initial_game_state()
    return {
        ['mode'] = 'start',
        ['entities'] = {
            ['ball'] = {
                ['width'] = CONFIG.BALL.WIDTH,
                ['height'] = CONFIG.BALL.HEIGHT,
                ['x'] = (CONFIG.VIRTUAL.WIDTH + CONFIG.BALL.WIDTH) / 2,
                ['y'] = (CONFIG.VIRTUAL.HEIGHT + CONFIG.BALL.HEIGHT) / 2,
                ['dx'] = 0,
                ['dy'] = 0,
            },
            ['player1'] = {
                ['control_keys'] = { ['up'] = 'w', ['down'] = 's' },
                ['score'] = 0,
                ['paddle'] = {
                    ['width'] = CONFIG.PADDLE.WIDTH,
                    ['height'] = CONFIG.PADDLE.HEIGHT,
                    ['x'] = 10,
                    ['y'] = 30,
                    ['dx'] = 0,
                    ['dy'] = 0,
                },
            },
            ['player2'] = {
                ['control_keys'] = { ['up'] = 'up', ['down'] = 'down' },
                ['score'] = 0,
                ['paddle'] = {
                    ['width'] = CONFIG.PADDLE.WIDTH,
                    ['height'] = CONFIG.PADDLE.HEIGHT,
                    ['x'] = CONFIG.VIRTUAL.WIDTH - 10,
                    ['y'] = CONFIG.VIRTUAL.HEIGHT - 50,
                    ['dx'] = 0,
                    ['dy'] = 0,
                },
            },
        },
    }
end

local function is_game_done(GameSate)
    return GameState.entities.player1.score >= CONFIG.GAME_END.SCORE or
        GameState.entities.player2.score >= CONFIG.GAME_END.SCORE
end

return {
    ["get_initial_game_state"] = get_initial_game_state,
    ["is_game_done"] = is_game_done,
}
