MB = {
    multiblocks = {}
}

local default_path = core.get_modpath("multiblock_lib")
dofile(default_path .. "/api/multiblock.lua")

if core.settings:get_bool("multiblocklib_testing_structure_enabled") == true then
    dofile(default_path .. "/examples/big_furnace.lua")
end
