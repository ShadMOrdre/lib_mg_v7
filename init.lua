lib_mg_v7 = {}
lib_mg_v7.name = "lib_mg_v7"
lib_mg_v7.ver_max = 0
lib_mg_v7.ver_min = 1
lib_mg_v7.ver_rev = 0
lib_mg_v7.ver_str = lib_mg_v7.ver_max .. "." .. lib_mg_v7.ver_min .. "." .. lib_mg_v7.ver_rev
lib_mg_v7.authorship = "ShadMOrdre.  Additional credits to Termos' Islands mod; Gael-de-Sailleys' Valleys; duane-r Valleys_c, burli mapgen, and paramats' mapgens"
lib_mg_v7.license = "LGLv2.1"
lib_mg_v7.copyright = "2020"
lib_mg_v7.path_mod = minetest.get_modpath(minetest.get_current_modname())
lib_mg_v7.path_world = minetest.get_worldpath()

local S
local NS
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	-- S = function(s) return s end
	-- internationalization boilerplate
	S, NS = dofile(lib_mg_v7.path_mod.."/intllib.lua")
end
lib_mg_v7.intllib = S

minetest.log(S("[MOD] lib_mg_v7:  Loading..."))
minetest.log(S("[MOD] lib_mg_v7:  Version:") .. S(lib_mg_v7.ver_str))
minetest.log(S("[MOD] lib_mg_v7:  Legal Info: Copyright ") .. S(lib_mg_v7.copyright) .. " " .. S(lib_mg_v7.authorship) .. "")
minetest.log(S("[MOD] lib_mg_v7:  License: ") .. S(lib_mg_v7.license) .. "")


	local abs   = math.abs
	local max   = math.max
	local min   = math.min
	local floor = math.floor

	lib_mg_v7.heightmap = {}
	lib_mg_v7.cliffmap = {}
	lib_mg_v7.biomemap = {} 
	lib_mg_v7.heatmap = {} 
	lib_mg_v7.humiditymap = {} 

	lib_mg_v7.water_level = 0

	local nobj_cliffs = nil
	local nbuf_cliffs = nil

	local nobj_heatmap = nil
	local nbuf_heatmap = nil
	local nobj_heatblend = nil
	local nbuf_heatblend = nil
	local nobj_humiditymap = nil
	local nbuf_humiditymap = nil
	local nobj_humidityblend = nil
	local nbuf_humidityblend = nil

	local c_air			= minetest.get_content_id("air")
	local c_ignore		= minetest.get_content_id("ignore")
	
	local c_desertsand		= minetest.get_content_id("default:desert_sand")
	local c_desertsandstone		= minetest.get_content_id("default:desert_sandstone")
	local c_desertstone		= minetest.get_content_id("default:desert_stone")
	local c_sand			= minetest.get_content_id("default:sand")
	local c_sandstone		= minetest.get_content_id("default:sandstone")
	local c_silversand		= minetest.get_content_id("default:silver_sand")
	local c_silversandstone		= minetest.get_content_id("default:silver_sandstone")
	local c_stone			= minetest.get_content_id("default:stone")
	local c_brick			= minetest.get_content_id("default:stonebrick")
	local c_block			= minetest.get_content_id("default:stone_block")
	local c_desertstoneblock	= minetest.get_content_id("default:desert_stone_block")
	local c_desertstonebrick	= minetest.get_content_id("default:desert_stonebrick")
	local c_obsidian		= minetest.get_content_id("default:obsidian")
	local c_dirt			= minetest.get_content_id("default:dirt")
	local c_dirtdry			= minetest.get_content_id("default:dry_dirt")
	local c_dirtgrass		= minetest.get_content_id("default:dirt_with_grass")
	local c_dirtdrygrass		= minetest.get_content_id("default:dirt_with_dry_grass")
	local c_dirtdrydrygrass		= minetest.get_content_id("default:dry_dirt_with_dry_grass")
	local c_dirtperm		= minetest.get_content_id("default:permafrost")
	local c_top			= minetest.get_content_id("default:dirt_with_grass")
	local c_coniferous		= minetest.get_content_id("default:dirt_with_coniferous_litter")
	local c_rainforest		= minetest.get_content_id("default:dirt_with_rainforest_litter")
	local c_snow			= minetest.get_content_id("default:dirt_with_snow")
	local c_ice			= minetest.get_content_id("default:ice")
	local c_water			= minetest.get_content_id("default:water_source")


--[[
	local c_stone			= minetest.get_content_id("lib_materials:stone")
	local c_brick			= minetest.get_content_id("lib_materials:stone_brick")
	local c_block			= minetest.get_content_id("lib_materials:stone_block")
	local c_cobble			= minetest.get_content_id("lib_materials:stone_cobble")
	local c_mossy			= minetest.get_content_id("lib_materials:stone_cobble_mossy")
	local c_gravel			= minetest.get_content_id("lib_materials:stone_gravel")

	local c_desertsandstone		= minetest.get_content_id("lib_materials:stone_sandstone_desert")
	local c_desertstone		= minetest.get_content_id("lib_materials:stone_desert")
	local c_desertstoneblock	= minetest.get_content_id("lib_materials:stone_desert_block")
	local c_desertstonebrick	= minetest.get_content_id("lib_materials:stone_desert_brick")
	local c_sandstone]		= minetest.get_content_id("lib_materials:stone_sandstone")
	local c_obsidian		= minetest.get_content_id("lib_materials:stone_obsidian")
	
	local c_sand			= minetest.get_content_id("lib_materials:sand")
	local c_desertsand		= minetest.get_content_id("lib_materials:sand_desert")

	local c_dirt			= minetest.get_content_id("lib_materials:dirt")
	local c_dirtgrass		= minetest.get_content_id("lib_materials:dirt_with_grass")
	local c_dirtdrygrass		= minetest.get_content_id("lib_materials:dirt_with_grass_dry")
	local c_dirtperma		= minetest.get_content_id("lib_materials:dirt_permafrost")
	local c_top			= minetest.get_content_id("lib_materials:dirt_with_grass_green")
	local c_coniferous		= minetest.get_content_id("lib_materials:litter_coniferous")
	local c_rainforest		= minetest.get_content_id("lib_materials:litter_rainforest")
	
	local c_snow			= minetest.get_content_id("lib_materials:dirt_with_snow")
	
	local c_water			= minetest.get_content_id("lib_materials:liquid_water_source")
	local c_river			= minetest.get_content_id("lib_materials:liquid_water_river_source")
	
	local c_lava			= minetest.get_content_id("lib_materials:liquid_lava_source")
	
	local c_tree			= minetest.get_content_id("lib_ecology:tree_default_trunk")
--]]

	local np_v7_alt = {
		flags = "eased",
		lacunarity = 2.0,
		offset = 0,
		scale = 50,
		spread = {x = 1200, y = 1200, z = 1200},
		seed = 5934,
		octaves = 8,
		persist = 0.3,
	}
	local np_v7_base = {
		flags = "eased",
		lacunarity = 2.0,
		offset = 0,
		scale = 210,
		spread = {x = 1200, y = 1200, z = 1200},
		seed = 5934,
		octaves = 8,
		persist = 0.3,
	}

	local np_v7_height = {
		flags = "eased",
		lacunarity = 2.0,
		offset = 0,
		scale = 1,
		spread = {x = 1000, y = 1000, z = 1000},
		seed = 4213,
		octaves = 8,
		persist = 0.3,
	}
	local np_v7_persist = {
		flags = "eased",
		lacunarity = 2.0,
		offset = 0.6,
		scale = 0.1,
		spread = {x = 2000, y = 2000, z = 2000},
		seed = 539,
		octaves = 3,
		persist = 0.6,
	}

	local np_v7_cliffs = {
		offset = 0,					
		scale = 0.72,
		spread = {x = 180, y = 180, z = 180},
		seed = 78901,
		octaves = 5,
		persist = 0.5,
		lacunarity = 2.19,
	}

	local np_heat = {
		flags = "defaults",
		lacunarity = 2,
		offset = 50,
		scale = 50,
		spread = {x = (1000), y = (1000), z = (1000)},
		seed = 5349,
		octaves = 3,
		persist = 0.5,
	}
	local np_heat_blend = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.5,
		spread = {x = 8, y = 8, z = 8},
		seed = 13,
		octaves = 2,
		persist = 1,
	}
	local np_humid = {
		flags = "defaults",
		lacunarity = 2,
		offset = 50,
		scale = 50,
		spread = {x = (1000), y = (1000), z = (1000)},
		seed = 842,
		octaves = 3,
		persist = 0.5,
	}
	local np_humid_blend = {
		flags = "defaults",
		lacunarity = 2,
		offset = 0,
		scale = 1.5,
		spread = {x = 8, y = 8, z = 8},
		seed = 90003,
		octaves = 2,
		persist = 1,
	}


	lib_mg_v7.mountain_altitude = np_v7_base.scale * 0.75
	local cliffs_thresh = floor((np_v7_alt.scale) * 0.5)


	local function rangelim(v, min, max)
		if v < min then return min end
		if v > max then return max end
		return v
	end


	local function get_terrain_height_cliffs(theight,cheight)
			-- cliffs
		local t_cliff = 0
		if theight > 1 and theight < cliffs_thresh then 
			local clifh = max(min(cheight,1),0) 
			if clifh > 0 then
				clifh = -1 * (clifh - 1) * (clifh - 1) + 1
				t_cliff = clifh
				theight = theight + (cliffs_thresh - theight) * clifh * ((theight < 2) and theight - 1 or 1)
			end
		end
		return theight, t_cliff
	end


	local mapgen_times = {
		liquid_lighting = {},
		loop2d = {},
		loop3d = {},
		mainloop = {},
		make_chunk = {},
		noisemaps = {},
		preparation = {},
		setdata = {},
		writing = {},
	}

	local data = {}


	minetest.register_on_generated(function(minp, maxp, seed)
		
		-- Start time of mapchunk generation.
		local t0 = os.clock()
		
		local sidelen = maxp.x - minp.x + 1
		local permapdims2d = {x = sidelen, y = sidelen, z = 0}
		local permapdims3d = {x = sidelen, y = sidelen, z = sidelen}

		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		data = vm:get_data()
		local a = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
		local csize = vector.add(vector.subtract(maxp, minp), 1)
	
		nobj_cliffs = nobj_cliffs or minetest.get_perlin_map(np_v7_cliffs, permapdims2d)
		nbuf_cliffs = nobj_cliffs:get_2d_map({x=minp.x,y=minp.z})
	
		nobj_heatmap = nobj_heatmap or minetest.get_perlin_map(np_heat, permapdims3d)
		nbuf_heatmap = nobj_heatmap:get_2d_map({x=minp.x,y=minp.z})
		nobj_heatblend = nobj_heatblend or minetest.get_perlin_map(np_heat_blend, permapdims3d)
		nbuf_heatblend = nobj_heatblend:get_2d_map({x=minp.x,y=minp.z})
		nobj_humiditymap = nobj_humiditymap or minetest.get_perlin_map(np_humid, permapdims3d)
		nbuf_humiditymap = nobj_humiditymap:get_2d_map({x=minp.x,y=minp.z})
		nobj_humidityblend = nobj_humidityblend or minetest.get_perlin_map(np_humid_blend, permapdims3d)
		nbuf_humidityblend = nobj_humidityblend:get_2d_map({x=minp.x,y=minp.z})
	
		-- Mapgen preparation is now finished. Check the timer to know the elapsed time.
		local t1 = os.clock()
	
		local write = false
		
	
	--2D HEIGHTMAP GENERATION
		local index2d = 0
	
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
	
				index2d = (z - minp.z) * csize.x + (x - minp.x) + 1

				local vterrain = 0

				local ncliff = nbuf_cliffs[z-minp.z+1][x-minp.x+1]

				local hselect = minetest.get_perlin(np_v7_height):get_2d({x=x,y=z})
				local hselect = rangelim(hselect, 0, 1)

				local persist = minetest.get_perlin(np_v7_persist):get_2d({x=x,y=z})

				np_v7_base.persistence = persist;
				local height_base = minetest.get_perlin(np_v7_base):get_2d({x=x,y=z})
	
				np_v7_alt.persistence = persist;
				local height_alt = minetest.get_perlin(np_v7_alt):get_2d({x=x,y=z})
	
				if (height_alt > height_base) then
					vterrain = floor(height_alt)
				else
					vterrain = floor((height_base * hselect) + (height_alt * (1 - hselect)))
				end


				local t_y, t_c = get_terrain_height_cliffs(vterrain,ncliff)
				lib_mg_v7.heightmap[index2d] = t_y
				lib_mg_v7.cliffmap[index2d] = t_c

				lib_mg_v7.heatmap[index2d] = (nbuf_heatmap[z-minp.z+1][x-minp.x+1] + nbuf_heatblend[z-minp.z+1][x-minp.x+1])
				lib_mg_v7.humiditymap[index2d] = nbuf_humiditymap[z-minp.z+1][x-minp.x+1] + nbuf_humidityblend[z-minp.z+1][x-minp.x+1]
			end
		end
	
		local t2 = os.clock()
	
		local t3 = os.clock()
	--
	--2D HEIGHTMAP RENDER
		local index2d = 0
		for z = minp.z, maxp.z do
			for y = minp.y, maxp.y do
				for x = minp.x, maxp.x do
				 
					index2d = (z - minp.z) * csize.x + (x - minp.x) + 1   
					local ivm = a:index(x, y, z)

					local write_3d = false
					local theight = lib_mg_v7.heightmap[index2d]
					local t_cliff = lib_mg_v7.cliffmap[index2d] or 0
					local nheat = lib_mg_v7.heatmap[index2d]
					local nhumid = lib_mg_v7.humiditymap[index2d]
					local t_biome_name = ""
	
					local fill_depth = 4
					local top_depth = 1
	

	--BUILD BIOMES.
	--
--[[
					local t_name = lib_mg_v7.get_biome_name(nheat,nhumid,theight)

					local b_name, b_cid, b_top, b_top_d, b_fill, b_fill_d, b_stone, b_water_top, b_water_top_d, b_water, b_river, b_riverbed, b_riverbed_d, b_caveliquid, b_dungeon, b_dungeonalt, b_dungeonstair, b_dust, b_ymin, b_ymax, b_heat, b_humid = unpack(lib_mg_v7.biome_info[t_name]:split("|", false))

					t_stone = b_stone
					t_dirt = b_fill
					if t_cliff > 0 then
						t_dirt = b_stone
					end
					fill_depth = tonumber(b_fill_d) or 6
					t_top = b_top
					top_depth = tonumber(b_top_d) or 1
					t_water_top = b_water_top
					t_river = b_river

					t_biome_name = t_name
					lib_mg_v7.biomemap[index2d] = t_name
--]]

					local t_air = c_air
					local t_ignore = c_ignore
					local t_top = c_top
					local t_filler = c_dirt
					local t_stone = c_stone
					local t_sand = c_sand
					local t_water = c_water
					local t_water_top = c_water

					if nhumid <= 25 then
						if nheat <= 25 then
							t_top = c_ice
							t_filler = c_dirtperm
							t_stone = c_stone
							t_sand = c_silversand
							t_water = c_ice
						elseif nheat <= 50 and nheat > 25 then
							t_top = c_silversand
							t_filler = c_silversand
							t_stone = c_silversandstone
							t_sand = c_silversand
							t_water = c_water
						elseif nheat <= 75 and nheat > 50 then
							t_top = c_sand
							t_filler = c_sand
							t_stone = c_desertsandstone
							t_sand = c_sand
							t_water = c_water
						else
							t_top = c_desertsand
							t_filler = c_desertsand
							t_stone = c_desertstone
							t_sand = c_desertsand
							t_water = c_water
						end
					elseif nhumid <= 50 and nhumid > 25 then
						if nheat <= 25 then
							t_top = c_dirtperm
							t_filler = c_dirtperm
							t_stone = c_stone
							t_sand = c_silversand
							t_water = c_water
						elseif nheat <= 50 and nheat > 25 then
							t_top = c_dirtdrygrass
							t_filler = c_dirtdry
							t_stone = c_sandstone
							t_sand = c_sand
							t_water = c_water
						elseif nheat <= 75 and nheat > 50 then
							t_top = c_dirtdrydrygrass
							t_filler = c_dirtdry
							t_stone = c_sandstone
							t_sand = c_sand
							t_water = c_water
						else
							t_top = c_dirtdry
							t_filler = c_desertsandstone
							t_stone = c_desertstone
							t_sand = c_sand
							t_water = c_water
						end
					elseif nhumid <= 75 and nhumid > 50 then
						if nheat <= 25 then
							t_top = c_snow
							t_filler = c_dirt
							t_stone = c_stone
							t_sand = c_silversand
							t_water = c_water
						elseif nheat <= 50 and nheat > 25 then
							t_top = c_dirtdrygrass
							t_filler = c_dirt
							t_stone = c_stone
							t_sand = c_sand
							t_water = c_water
						elseif nheat <= 75 and nheat > 50 then
							t_top = c_dirtgrass
							t_filler = c_dirt
							t_stone = c_stone
							t_sand = c_sand
							t_water = c_water
						else
							t_top = c_dirtgrass
							t_filler = c_dirt
							t_stone = c_desertstone
							t_sand = c_sand
							t_water = c_water
						end
					else
						if nheat <= 50 then
							t_top = c_coniferous
							t_filler = c_dirt
							t_stone = c_desertsandstone
							t_sand = c_sand
							t_water = c_water
						else
							t_top = c_rainforest
							t_filler = c_dirt
							t_stone = c_desertstone
							t_sand = c_desertsand
							t_water = c_water
						end
					end

					if t_cliff > 0 then
						t_filler = t_stone
					end
					if y > lib_mg_v7.mountain_altitude then
						t_top = t_stone
						t_filler = t_stone
					end


--NODE PLACEMENT FROM HEIGHTMAP
--
					local t_node = t_ignore

				--2D Terrain
					if y < (theight - (fill_depth + top_depth)) then
						t_node = t_stone
					elseif y >= (theight - (fill_depth + top_depth)) and y < (theight - top_depth) then
						t_node = t_filler
					elseif y >= (theight - top_depth) and y <= theight then
						if y <= lib_mg_v7.water_level then
							t_node = t_sand
						else
							t_node = t_top
						end
					elseif y > theight and y <= lib_mg_v7.water_level then
					--Water Level (Sea Level)
						t_node = t_water
					end

					data[ivm] = t_node
					write = true

				end
			end
		end
		
		local t4 = os.clock()
	
		if write then
			vm:set_data(data)
		end
	
		local t5 = os.clock()
		
		if write then
	
			minetest.generate_ores(vm,minp,maxp)
			minetest.generate_decorations(vm,minp,maxp)
				
			vm:set_lighting({day = 0, night = 0})
			vm:calc_lighting()
			vm:update_liquids()
		end
	
		local t6 = os.clock()
	
		if write then
			vm:write_to_map()
		end
	
		local t7 = os.clock()
	
		-- Print generation time of this mapchunk.
		local chugent = math.ceil((os.clock() - t0) * 1000)
		print ("[lib_mg_v7] Mapchunk generation time " .. chugent .. " ms")
	
		table.insert(mapgen_times.noisemaps, 0)
		table.insert(mapgen_times.preparation, t1 - t0)
		table.insert(mapgen_times.loop2d, t2 - t1)
		table.insert(mapgen_times.loop3d, t3 - t2)
		table.insert(mapgen_times.mainloop, t4 - t3)
		table.insert(mapgen_times.setdata, t5 - t4)
		table.insert(mapgen_times.liquid_lighting, t6 - t5)
		table.insert(mapgen_times.writing, t7 - t6)
		table.insert(mapgen_times.make_chunk, t7 - t0)
	
		-- Deal with memory issues. This, of course, is supposed to be automatic.
		local mem = math.floor(collectgarbage("count")/1024)
		if mem > 1000 then
			print("lib_mg_v7 is manually collecting garbage as memory use has exceeded 500K.")
			collectgarbage("collect")
		end
	end)

	local function mean( t )
		local sum = 0
		local count= 0
	
		for k,v in pairs(t) do
			if type(v) == 'number' then
				sum = sum + v
				count = count + 1
			end
		end
	
		return (sum / count)
	end

	minetest.register_on_shutdown(function()

		if lib_mg_v7.mg_add_voronoi == true then
			lib_mg_v7.save_neighbors()
		end

		if #mapgen_times.make_chunk == 0 then
			return
		end
	
		local average, standard_dev
		minetest.log("lib_mg_v7 lua Mapgen Times:")
	
		average = mean(mapgen_times.liquid_lighting)
		minetest.log("  liquid_lighting: - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.loop2d)
		minetest.log(" 2D Noise loops: - - - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.loop3d)
		minetest.log(" 3D Noise loops: - - - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.mainloop)
		minetest.log(" Main Render loops: - - - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.make_chunk)
		minetest.log("  makeChunk: - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.noisemaps)
		minetest.log("  noisemaps: - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.preparation)
		minetest.log("  preparation: - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.setdata)
		minetest.log("  writing: - - - - - - - - - - - - - - - -  "..average)
	
		average = mean(mapgen_times.writing)
		minetest.log("  writing: - - - - - - - - - - - - - - - -  "..average)
	end)





minetest.log(S("[MOD] lib_mg_v7:  Successfully loaded."))


