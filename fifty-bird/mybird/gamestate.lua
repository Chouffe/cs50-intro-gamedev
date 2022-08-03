require 'entities/Bird'

local function get_initial_gamestate(assets)
    return {
        ['scrolling'] = true,
        ['last_y'] = 200,
        ['entities'] = {
            ['pipe_pairs'] = {},
            ['bird'] = Bird(assets.images.bird),
        },
        ['background_scroll'] = 0,
        ['ground_scroll'] = 0,
        ['spawn_pipe_timer'] = 0,
    }
end

return {
    ["get_initial_gamestate"] = get_initial_gamestate,
}
