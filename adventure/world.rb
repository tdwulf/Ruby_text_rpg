module RubyAdventure
	attr_accessor
	class World
		def initialize
			@world_data = WorldData.new
		end
		
		def location_detail(place_name)
			@world_data.location_data(place_name)
		end
		
		def location_name(place_name)
			@world_data.location_name(place_name)
		end
		
		def get_mobs(loc_name,tod)
			@world_data.get_mobs(loc_name,tod)
		end
		
		def get_boss_mobs(loc_name,tod)
			@world_data.get_boss_mobs(loc_name,tod)
		end
		
		def get_paths(loc_name)
			@world_data.get_paths(loc_name)
		end
		
		def get_just_paths(loc_name)
			@world_data.get_just_paths(loc_name)
		end
		
		def get_descrip(loc_name)
			@world_data.get_descrip(loc_name)
		end
		
		def get_npcs(db_name,tod)
			@world_data.get_npcs(db_name,tod)
		end	
		
		def get_nodes(db_name,tod,type)
			@world_data.get_nodes(db_name,tod,type)
		end
		
		def get_all_nodes(db_name,tod)
			@world_data.get_all_nodes(db_name,tod)
		end
		
		def get_node_types(db_name,tod)
			node_arr = []
			nodes = @world_data.get_node_types(db_name,tod)
			nodes.each do |x|
				node_arr.push(x[0])
			end
			return node_arr
		end
		
	end
	
end
