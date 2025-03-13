function MB.check_multiblock(node, pos)
    -- Setting up initial variable values
    local x = "x"
    local y = "y"
    local z = "z"
    local x_mod = 1
    local y_mod = 1
    local z_mod = 1


    -- Setting coordinate stuff according to main block rotation
    local rotation = node.param2 % 32
    if rotation == 0 then
        x = "x"
        z = "z"
        x_mod = -1
        z_mod = 1
    elseif rotation == 1 then
        x = "z"
        z = "x"
        x_mod = 1
        z_mod = 1
    elseif rotation == 2 then
        x = "x"
        z = "z"
        x_mod = 1
        z_mod = -1
    elseif rotation == 3 then
        x = "z"
        z = "x"
        x_mod = -1
        z_mod = -1
    end

    local structure = MB.get_multiblock_or_nil(node.name)

    if not structure then
        print("No structure for node " .. node.name)
        return
    end

    -- Get in world corner of structure (base layer, top left)
    local corner = {
        x = pos.x + structure["root_pos"][x] * x_mod,
        y = pos.y - structure["root_pos"][y] * y_mod,
        z = pos.z + structure["root_pos"][z] * z_mod,
    }

    -- Iterate over structure
    for layer_idx, layer in pairs(structure["structure"]) do
        for row_idx, row in pairs(layer) do
            for col_idx, col in pairs(row) do
                -- Check what node to look for and if node is in key or just air
                local node_type = structure["key"][col]
                if col == " " then
                    node_type = "air"
                elseif node_type == nil then
                    return
                end
                local curr_pos = {}
                curr_pos[x] = corner[x] + (col_idx - 1) * (x_mod * -1)
                curr_pos[y] = corner[y] + (layer_idx - 1) * y_mod
                curr_pos[z] = corner[z] + (row_idx - 1) * (z_mod * -1)

                -- If the node is either the exact match or has the group given
                -- continue
                local curr_node = core.get_node(curr_pos).name

                if curr_node ~= node_type then
                    if core.get_item_group(curr_node, node_type) == 0 then
                        return
                    end
                end

            end
        end
    end
    structure["callback"](node, pos)
end

-- Register a multiblock with it's callback
-- Structure is a table describing the multiblock
-- See examples/big_furnace.lua
function MB.register_multiblock(root_node, structure, callback)
    if not structure["structure"] or not structure["key"] or not structure["root_pos"] then
        print("Invalid structure")
        return
    end
    if not callback then
        print("No callback given")
    end

    structure["callback"] = callback

    MB.multiblocks[root_node] = structure
end


function MB.get_multiblock_or_nil(root_node)
    if MB["multiblocks"][root_node] then
        return MB["multiblocks"][root_node]
    else
        return nil
    end
end
