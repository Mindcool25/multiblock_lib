core.register_node("multiblock_lib:test_controller", {
    description = "Test Controller",
    drawtype = "normal",
    paramtype2 = "4dir",
    tiles = {
        "multiblock_lib_test_side.png",
        "multiblock_lib_test_side.png",
        "multiblock_lib_test_side.png",
        "multiblock_lib_test_side.png",
        "multiblock_lib_test_side.png",
        {
            image = "multiblock_lib_test_front.png",
            backface_culling = false;
        }
    },
    groups = {
        cracky = 1
    },
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if clicker and clicker:is_player() then
            MB.check_multiblock(node, pos)
        end
    end
})


local big_furnace = {
    structure = {
        {
            {"S","S","S",},
            {"S","S","S",},
            {"S","S","S",},
        },
        {
            {"S","S","S",},
            {"S","S","S",},
            {"S","F","S",},
        },
        {
            {"S","S","S",},
            {"S","S","S",},
            {"S","S","S",},
        },
    },
    key = {
        S = "default:cobble",
        F = "multiblock_lib:test_controller",
    },

    -- Note that this is to get from the top left hand side from the bottom, assume 0 index rather than 1
    root_pos = {
        x = 1,
        y = 1,
        z = 2,
    }
}

local function big_furnace_callback(node, pos)
    core.chat_send_all("Big furnace built")
end

MB.register_multiblock("multiblock_lib:test_controller", big_furnace, big_furnace_callback)
