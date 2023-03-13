local modpath = minetest.get_modpath("treeparticles")

treeparticles = {}

treeparticles.get_node_group = function(name, group)
    if not minetest.registered_nodes[name] or not minetest.registered_nodes[name].groups[group] then
        return 0
    end
    return minetest.registered_nodes[name].groups[group]
end


treeparticles.leaves_above = function(pos, tree)
	local posup = {x=pos.x, y=pos.y + 1, z=pos.z}
	local leafrating = treeparticles.get_node_group(minetest.get_node(posup).name, "leaves")
	if leafrating ~= nil and leafrating ~= 0 then
		return true, posup
	elseif minetest.get_node(posup).name == tree then
		return treeparticles.leaves_above(posup, tree)
	else
		return false
	end
end

treeparticles.register_tree = function(def)
	if def == nil then
		print("[ERROR]treeparticles failed to register tree: empty defininition")
	end
	minetest.register_node(def.modname .. ":" .. def.nodename, {
		description = def.description,
		paramtype = "light",
		drawtype = "normal",
		tiles = {
			def.texture.top,
			def.texture.top,
			def.texture.side,
			def.texture.side,
			def.texture.side,
			def.texture.side,
		},
		walkable = true,
		climbable = false,
		sunlight_propagates = false,
		groups = {choppy=2, flammable=1,},
		on_punch = function(pos)
			local istrue, leaf_pos = treeparticles.leaves_above(pos, def.modname .. ":" .. def.nodename)
			if istrue and leaf_pos ~= nil then
				minetest.add_particlespawner({
					amount = 150,
					time = 2,
					minpos = {x=leaf_pos.x - 1, y=leaf_pos.y - 1, z=leaf_pos.z - 1},
					maxpos = {x=leaf_pos.x + 1, y=leaf_pos.y, z=leaf_pos.z + 1},
					minvel = {x = -0.8, y = -1, z = -0.8},
					maxvel = {x = 0.8, y = -3, z = 0.8},
					minacc = {x = -0.1, y = -1, z = -0.1},
					mixacc = {x = 0.2, y = -3, z = 0.2},
					minexptime = 2,
					maxexptime = 10,
					minsize = 0.5,
					maxsize = 1.2,
					collisiondetection = false,
					texture = def.particleimage,
					vertical = true,
				})
			end
		end
	})
end

-- REGISTER TREES

local treedef = {
	modname = "treeparticles",
	nodename = "tree",
	description = "Tree",
	texture = {
		top = "treeparticles_tree.png",
		side = "treeparticles_tree_side.png",
	},
	particleimage = "treeparticles_leaf.png",
}

local beechdef = {
	modname = "treeparticles",
	nodename = "beech_tree",
	description = "Beech Tree",
	texture = {
		top = "treeparticles_beech.png",
		side = "treeparticles_beech_side.png",
	},
	particleimage = "treeparticles_leaf.png",
}

local birchdef = {
	modname = "treeparticles",
	nodename = "birch_tree",
	description = "Birch Tree",
	texture = {
		top = "treeparticles_birch.png",
		side = "treeparticles_birch_side.png",
	},
	particleimage = "treeparticles_leaf.png",
}

local mapledef = {
	modname = "treeparticles",
	nodename = "maple_tree",
	description = "Maple Tree",
	texture = {
		top = "treeparticles_maple.png",
		side = "treeparticles_maple_side.png",
	},
	particleimage = "treeparticles_leaf.png",
}

treeparticles.register_tree(treedef)
treeparticles.register_tree(beechdef)
treeparticles.register_tree(birchdef)
treeparticles.register_tree(mapledef)

-- REGISTER LEAVES

treeparticles.register_leaves = function(def)
	minetest.register_node(def.modname .. ":" .. def.name, {
		description = def.dname .. "Leaves",
		paramtype = "light",
		drawtype = "glasslike",
		tiles = {def.modname .. "_" .. def.name .."_leaves.png"},
		walkable = true,
		climbable = false,
		sunlight_propagates = true,
		groups = {snappy=3, leafdecay=1, leaves=1, flammable=1,},
	})
end

local oakldef = {
	name = "oak",
	dname = "Oak",
	modname = "treeparticles",
}
local beechldef = {
	name = "beech",
	dname = "Beech",
	modname = "treeparticles",
}
local birchldef = {
	name = "birch",
	dname = "Birch",
	modname = "treeparticles",
}
local mapleldef = {
	name = "maple",
	dname = "Maple",
	modname = "treeparticles",
}
treeparticles.register_leaves(oakldef)
treeparticles.register_leaves(beechldef)
treeparticles.register_leaves(birchldef)
treeparticles.register_leaves(mapleldef)

-- normal minetest overwrite

minetest.override_item("default:tree", {
	on_punch = function(pos)
		local istrue, leaf_pos = treeparticles.leaves_above(pos, "default:tree")
		if istrue and leaf_pos ~= nil then
			particle_def = {
				amount = 150,
				time = 2,
				minpos = {x=leaf_pos.x - 1, y=leaf_pos.y - 1, z=leaf_pos.z - 1},
				maxpos = {x=leaf_pos.x + 1, y=leaf_pos.y, z=leaf_pos.z + 1},
				minvel = {x = -0.8, y = -1, z = -0.8},
				maxvel = {x = 0.8, y = -3, z = 0.8},
				minacc = {x = -0.1, y = -1, z = -0.1},
				mixacc = {x = 0.2, y = -3, z = 0.2},
				minexptime = 2,
				maxexptime = 10,
				minsize = 0.5,
				maxsize = 1.2,
				collisiondetection = false,
				texture = "treeparticles_leaf.png",
				vertical = true,
			}
			minetest.add_particlespawner(particle_def)
		end
	end
})

minetest.override_item("default:pine_tree", {
	on_punch = function(pos)
		local istrue, leaf_pos = treeparticles.leaves_above(pos, "default:pine_tree")
		if istrue and leaf_pos ~= nil then
			particle_def = {
				amount = 150,
				time = 2,
				minpos = {x=leaf_pos.x - 1, y=leaf_pos.y - 1, z=leaf_pos.z - 1},
				maxpos = {x=leaf_pos.x + 1, y=leaf_pos.y, z=leaf_pos.z + 1},
				minvel = {x = -0.8, y = -1, z = -0.8},
				maxvel = {x = 0.8, y = -3, z = 0.8},
				minacc = {x = -0.1, y = -1, z = -0.1},
				mixacc = {x = 0.2, y = -3, z = 0.2},
				minexptime = 2,
				maxexptime = 10,
				minsize = 0.5,
				maxsize = 1.2,
				collisiondetection = false,
				texture = "treeparticles_leaf.png",
				vertical = true,
			}
			minetest.add_particlespawner(particle_def)
		end
	end
})

minetest.override_item("default:aspen_tree", {
	on_punch = function(pos)
		local istrue, leaf_pos = treeparticles.leaves_above(pos, "default:aspen_tree")
		if istrue and leaf_pos ~= nil then
			particle_def = {
				amount = 150,
				time = 2,
				minpos = {x=leaf_pos.x - 1, y=leaf_pos.y - 1, z=leaf_pos.z - 1},
				maxpos = {x=leaf_pos.x + 1, y=leaf_pos.y, z=leaf_pos.z + 1},
				minvel = {x = -0.8, y = -1, z = -0.8},
				maxvel = {x = 0.8, y = -3, z = 0.8},
				minacc = {x = -0.1, y = -1, z = -0.1},
				mixacc = {x = 0.2, y = -3, z = 0.2},
				minexptime = 2,
				maxexptime = 10,
				minsize = 0.5,
				maxsize = 1.2,
				collisiondetection = false,
				texture = "treeparticles_leaf.png",
				vertical = true,
			}
			minetest.add_particlespawner(particle_def)
		end
	end
})

minetest.override_item("default:jungletree", {
	on_punch = function(pos)
		local istrue, leaf_pos = treeparticles.leaves_above(pos, "default:jungletree")
		if istrue and leaf_pos ~= nil then
			particle_def = {
				amount = 150,
				time = 2,
				minpos = {x=leaf_pos.x - 1, y=leaf_pos.y - 1, z=leaf_pos.z - 1},
				maxpos = {x=leaf_pos.x + 1, y=leaf_pos.y, z=leaf_pos.z + 1},
				minvel = {x = -0.8, y = -1, z = -0.8},
				maxvel = {x = 0.8, y = -3, z = 0.8},
				minacc = {x = -0.1, y = -1, z = -0.1},
				mixacc = {x = 0.2, y = -3, z = 0.2},
				minexptime = 2,
				maxexptime = 10,
				minsize = 0.5,
				maxsize = 1.2,
				collisiondetection = false,
				texture = "treeparticles_leaf.png",
				vertical = true,
			}
			minetest.add_particlespawner(particle_def)
		end
	end
})

minetest.override_item("default:acacia_tree", {
	on_punch = function(pos)
		local istrue, leaf_pos = treeparticles.leaves_above(pos, "default:acacia_tree")
		if istrue and leaf_pos ~= nil then
			particle_def = {
				amount = 150,
				time = 2,
				minpos = {x=leaf_pos.x - 1, y=leaf_pos.y - 1, z=leaf_pos.z - 1},
				maxpos = {x=leaf_pos.x + 1, y=leaf_pos.y, z=leaf_pos.z + 1},
				minvel = {x = -0.8, y = -1, z = -0.8},
				maxvel = {x = 0.8, y = -3, z = 0.8},
				minacc = {x = -0.1, y = -1, z = -0.1},
				mixacc = {x = 0.2, y = -3, z = 0.2},
				minexptime = 2,
				maxexptime = 10,
				minsize = 0.5,
				maxsize = 1.2,
				collisiondetection = false,
				texture = "treeparticles_leaf.png",
				vertical = true,
			}
			minetest.add_particlespawner(particle_def)
		end
	end
})
