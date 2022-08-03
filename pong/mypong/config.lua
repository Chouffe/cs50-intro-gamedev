-- Should we use a yaml file instead?

return {
    ['ASSETS'] = {
        ['SOUNDS'] = {
            ['paddle_hit'] = 'assets/sounds/paddle_hit.wav',
            ['score'] = 'assets/sounds/score.wav',
            ['wall_hit'] = 'assets/sounds/wall_hit.wav',
        },
        ['FONTS'] = {
            ['PATH'] = 'assets/fonts/font.ttf',
        },
    },
    ['BACKGROUND'] = {
        ['COLOR'] = {
            ['r'] = 40 / 255,
            ['g'] = 45 / 255,
            ['b'] = 52 / 255,
            ['a'] = 255 / 255,
        },
    },
    ['GAME_END'] = { ['SCORE'] = 3 },
    ['WINDOW'] = {
        ['WIDTH'] = 1280,
        ['HEIGHT'] = 720,
    },
    ['VIRTUAL'] = {
        ['WIDTH'] = 432,
        ['HEIGHT'] = 243,
    },
    ['BALL'] = {
        ['WIDTH'] = 4,
        ['HEIGHT'] = 4,
    },
    ['PADDLE'] = {
        ['SPEED'] = 200,
        ['WIDTH'] = 5,
        ['HEIGHT'] = 20,
    },
}
