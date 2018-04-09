require "sqlite3"

module RubyAdventure
	class WorldData
		attr_accessor
		def initialize

			begin
				create_world_data_db
			rescue
				puts "Raising land from the Seas"
			end
			#CREATE TABLES
			create_main_world_tbl
			create_world_descrip_tbl
			create_world_paths_tbl
			create_world_mobs_tbl
			create_world_npcs_tbl
			create_world_bosses_tbl
			create_world_nodes_tbl
			puts "We will add a happy little tree right over here"
			
			#UPDATE TABLES
			update_main_world_tbl
			update_world_descrip_tbl
			update_world_paths_tbl
			update_world_mobs_tbl
			update_world_npc_tbl
			update_world_bosses_tbl
			update_world_nodes_tbl
		
		end
			
		
			
			
		def create_world_data_db
			@world_data_db = SQLite3::Database.new "adventure/db/world_data.db"
			#@game_data_db.results_as_hash = true
		end
		
		##
		## Main Location TABLE
		##
		
		#create an empty db for world locations
		def create_main_world_tbl
			w_rows = @world_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS main_world_data (
					id INTEGER PRIMARY KEY,
					db_name varchar(60),
					place_name varchar(30),
					place_type varchar(30),
					level int, 
					mobs int,
					npcs int,
					loot int, 
					gathering int
				);
			SQL
		end
		
		# update main world table
		def update_main_world_tbl
			begin
				@world_data_db.execute ("DELETE from main_world_data")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
			# [db_name, place_name, place_type, level, mobs, npcs, loot, gathering]
			[
				["new_harbor","New Harbor","town",0,1,1,1,1],
				["new_harbor_orchard","New Harbor Orchard","wilds",0,1,0,1,1],
				["nhce","New Harbor Catacombs Entrance","wilds",0,1,1,1,1],
				["nhc1","New Harbor Catacombs Depth 1","dungeon",0,1,0,1,1],
				["nhc2","New Harbor Catacombs Depth 2","dungeon",0,1,0,1,1],
				["nhc2n","New Harbor Catacombs Depth 2 North","dungeon",0,1,1,1,1],
				["nhc3","New Harbor Catacombs Depth 3","dungeon",0,1,0,1,1],
				["nhc3n","New Harbor Catacombs Depth 3 North","dungeon",0,1,0,1,1],
				["nhc4","New Harbor Catacombs Depth 4","dungeon",0,1,0,1,1],
				["nhc5","New Harbor Catacombs Depth 5","dungeon",1,1,0,1,1],
				["nhc6","New Harbor Catacombs Depth 6","dungeon",1,1,0,1,1],
				["nhc7","New Harbor Catacombs Depth 7","dungeon",1,1,1,1,1],
				["new_harbor_plains","New Harbor Plains","wilds",1,1,1,1,1],
				["new_harbor_shore","New Harbor Shore","wilds",1,1,1,1,1],
				["northern_plains","Northern Plains","wilds",2,1,1,1,1],
				["western_grasslands","Western Grasslands","wilds",2,1,1,1,1],
				["shattered_crags","Shattered Crags","wilds",2,1,1,1,1],
				["central_dark_forest","Central Dark Forest","wilds",3,1,1,1,1],
				["southern_dark_forest","Southern Dark Forest","wilds",3,1,1,1,1],
				["northern_dark_forest","Northern Dark Forest","wilds",4,1,1,1,1],
				["eastern_plains","Eastern Plains","wilds",4,1,1,1,1],
				["salt_spray_fields","Salt Spray Fields","wilds",4,1,1,1,1],
				["salt_spray_port","Salt Spray Port","town",4,1,1,1,1],
				["iron_heart_quarry","Iron Heart Quarry","wilds",5,1,1,1,1],
				["scorched_plains","Scorched Plains","wilds",5,1,1,1,1],
				["northern_salt_spray_marsh","Northern Salt Spray Marsh","wilds",5,1,1,1,1],
				["southern_salt_spray_marsh","Southern Salt Spray Marsh","wilds",5,1,1,1,1],
				["sea_dog_shores","Sea Dog Shores","wilds",5,1,1,1,1],
				["southern_scorpion_sands","Southern Scorpion Sands","wilds",6,1,1,1,1],
				["escne","Eastern Spire Caves North Entrance","dungeon",6,1,1,1,1],
				["escse","Eastern Spire Caves South Entrance","dungeon",6,1,1,1,1],
				["escwe","Eastern Spire Caves West Entrance","dungeon",6,1,1,1,1],
				["esc1","Eastern Spire Caves Cavern One","dungeon",6,1,1,1,1],
				["esc2","Eastern Spire Caves Cavern Two","dungeon",6,1,1,1,1],
				["esc3","Eastern Spire Caves Cavern Three","dungeon",6,1,1,1,1],
				["esc4","Eastern Spire Caves Cavern Four","dungeon",6,1,1,1,1],
				["esc5","Eastern Spire Caves Cavern Five","dungeon",6,1,1,1,1],
				["esc6","Eastern Spire Caves Cavern Six","dungeon",6,1,1,1,1],
				["southern_wyndhaven_grasslands","Southern Wyndhaven Grasslands","wilds",6,1,1,1,1],
				["wyndhaven_swamplands","Wyndhaven Swamplands","wilds",6,1,1,1,1],
				["wyndhaven","Wyndhaven","town",7,1,1,1,1],
				["northern_scorpion_sands","Northern Scorpion Sands","wilds",7,1,1,1,1],
				["sandgrass_plains","Sandgrass Plains","wilds",7,1,1,1,1],
				["spire_view","Spire View","town",7,1,1,1,1],
				["wscne","Western Spire Caves North Entrance","dungeon",8,1,1,1,1],
				["wscee","Western Spire Caves East Entrance","dungeon",8,1,1,1,1],
				["wscse","Western Spire Caves South Entrance","dungeon",8,1,1,1,1],
				["wscwe","Western Spire Caves West Entrance","dungeon",8,1,1,1,1],
				["wsc1","Western Spire Caves Cavern One","dungeon",8,1,1,1,1],
				["wsc2","Western Spire Caves Cavern Two","dungeon",8,1,1,1,1],
				["wsc3","Western Spire Caves Cavern Three","dungeon",8,1,1,1,1],
				["wsc4","Western Spire Caves Cavern Four","dungeon",8,1,1,1,1],
				["wsc5","Western Spire Caves Cavern Five","dungeon",8,1,1,1,1],
				["wsc6","Western Spire Caves Cavern Six","dungeon",8,1,1,1,1],
				["wyndhaven_forest","Wyndhaven Forest","wilds",8,1,1,1,1],
				["northern_wyndhaven_grasslands","Northern Wyndhaven Grasslands","wilds",8,1,1,1,1],
				["spire_mountain_summit","Spire Mountain Summit","wilds",9,1,1,1,1],
				["northern_spire_foothills","Northern Spire Foothills","wilds",9,1,1,1,1],
				["eastern_spire_foothills","Eastern Spire Foothills","wilds",9,1,1,1,1],
				["southern_spire_foothills","Southern Spire Foothills","wilds",9,1,1,1,1],
				["western_spire_foothills","Western Spire Foothills","wilds",9,1,1,1,1],
				["rebel_shores","Rebel Shores","wilds",10,1,1,1,1],
				["eastern_rebel_shores","Eastern Rebel Shores","wilds",10,1,1,1,1],
				["eastern_rebel_battlefields","Eastern Rebel Battlefields","wilds",10,1,1,1,1],
				["central_rebel_battlefields","Central Rebel Battlefields","wilds",10,1,1,1,1],
				["western_rebel_battlefields","Western Rebel Battlefields","wilds",10,1,1,1,1]
				
			].each do |dn,pn,pt,l,mob,n,loot,g|
				@world_data_db.execute "insert into main_world_data values (?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dn,pn,pt,l,mob,n,loot,g
			end
		end
		
		#query location data
		def location_data(place_name)
			return @world_data_db.execute( "select * from main_world_data where db_name = ?", place_name )
		end
		
		#get friendly place name
		def location_name(place_name)
			return @world_data_db.execute( "select place_name from main_world_data where db_name = ?", place_name )
		end
		
		##
		## WORLD Description TABLE
		##
		def create_world_descrip_tbl
			w_rows = @world_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS world_descrip (
					id INTEGER PRIMARY KEY,
					db_name varchar(60),
					descrip varchar(255)
				);
			SQL
		end
		
		def update_world_descrip_tbl
			begin
				@world_data_db.execute ("DELETE from world_descrip")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
			# [db_name, descrip]
			[
				["new_harbor","a sea side town that is a bustle of people.\nThere are Large Rats scurrying in the shadows.\nSomeone should WALK around take care of the Rats"],
				["new_harbor_orchard","a vast orchard with numerous fruit trees.\nThere could be some yummy fruit available to find."],
				["nhce","a large marble building stands at the entrance to the catacombs.\nThis area may be where the rats in New Harbor are coming from."],
				["nhc1","a vast room stretching out in the darkness.\nThe way forward is lined with pillars and various piles of rubble.\nSome of the pillars are scratch, as if a monster had attacked them."],
				["nhc2","a vast room stretching out in the darkness.\nThe way forward is lined with pillars and various piles of rubble.\nSome of the pillars are scratch, as if a monster had attacked them."],
				["nhc2n","there are fresh foot prints on the ground.\nThere may still be someone somewhere in this area."],
				["nhc3","the northern side of the room opens up to a larger area."],
				["nhc3n","a great cavernous room with high ceilings supported by massive pillars.\nThere appears to be some sort of droppings on the ground, possibly bats."],
				["nhc4","the hall way is virtualy indistinguishable from the first portion of the dungeon.\nThe only exception is a large door.\nScript on the door reads 'Only those strong enough shall pass'."],
				["nhc5","a great cavernous room with high ceilings supported by massive pillars.\nThere appears to be some sort of droppings on the ground, possibly bats."],
				["nhc6","a great cavernous room with high ceilings supported by massive pillars.\nThere appears to be some sort of droppings on the ground, possibly bats."],
				["nhc7","there are fresh foot prints on the ground.\nThere may still be someone somewhere in this area."],
				["new_harbor_plains","an expansive area with low rolling hills. \nThere are large webs in some of the trees.\nLooks like very large spiders may have made them."],
				["new_harbor_shore","a small seaside beach. Sea birds and crabs scurry about playfully.\nThere a large reptillian foot prints in the sand."],
				["northern_plains","nil"],
				["western_grass_lands","nil"],
				["shattered_crags","nil"],
				["central_dark_forest","nil"],
				["southern_dark_forest","nil"],
				["northern_dark_forest","nil"],
				["eastern_plains","nil"],
				["salt_spray_fields","nil"],
				["salt_spray_port","nil"],
				["iron_heart_quarry","nil"],
				["scorched_plains","nil"],
				["northern_salt_spray_marsh","nil"],
				["southern_salt_spray_marsh","nil"],
				["sea_dog_shores","nil"],
				["southern_scorpion_sands","nil"],
				["escne","nil"],
				["escse","nil"],
				["escwe","nil"],
				["esc1","nil"],
				["esc2","nil"],
				["esc3","nil"],
				["esc4","nil"],
				["esc5","nil"],
				["esc6","nil"],
				["southern_wyndhaven_grasslands","nil"],
				["wyndhaven_swamplands","nil"],
				["wyndhaven","nil"],
				["northern_scorpion_sands","nil"],
				["sandgrass_plains","nil"],
				["spire_view","nil"],
				["wscne","nil"],
				["wscee","nil"],
				["wscse","nil"],
				["wscwe","nil"],
				["wsc1","nil"],
				["wsc2","nil"],
				["wsc3","nil"],
				["wsc4","nil"],
				["wsc5","nil"],
				["wsc6","nil"],
				["wyndhaven_forest","nil"],
				["northern_wyndhaven_grasslands","nil"],
				["spire_mountain_summit","nil"],
				["northern_spire_foothills","nil"],
				["eastern_spire_foothills","nil"],
				["southern_spire_foothills","nil"],
				["western_spire_foothills","nil"],
				["rebel_shores","nil"],
				["eastern_rebel_shores","nil"],
				["eastern_rebel_battlefields","nil"],
				["central_rebel_battlefields","nil"],
				["western_rebel_battlefields","nil"]
				
			].each do |dn,d|
				@world_data_db.execute "insert into world_descrip values (?, ?, ?)", nil,dn,d
			end
		end
		
		#query mobs
		def get_descrip(loc_name)
			return @world_data_db.execute( "select descrip from world_descrip where db_name = ?", loc_name)
		end
		
		##
		## WORLD PATHS TABLE
		##
		
		def create_world_paths_tbl
			path_rows = @world_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS world_paths (
					id INTEGER PRIMARY KEY,
					db_name varchar(60),
					n_path varchar(30),
					e_path varchar(30),
					s_path varchar(30),
					w_path varchar(30)
				);
			SQL
		end	
		
		def update_world_paths_tbl
			begin
				@world_data_db.execute ("DELETE from world_paths")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
			# [db_name, n_path, e_path, s_path, w_path]
			[
				["new_harbor","new_harbor_plains","nhce","-","new_harbor_orchard"],
				["new_harbor_orchard","-","new_harbor","new_harbor_shore","-"],
				["nhce","-","nhc1","-","new_harbor"],
				["nhc1","-","nhc2","-","nhce"],
				["nhc2","-","nhc3","-","nhc1"],
				["nhc2n","-","nhc3n","-","-"],
				["nhc3","nhc3n","nhc4","-","nhc2"],
				["nhc3n","-","-","nhc3","nhc2n"],
				["nhc4","-","nhc5","-","nhc3"],
				["nhc5","-","nhc6","-","nhc4"],
				["nhc6","-","nhc7","-","nhc5"],
				["nhc7","-","-","-","nhc6"],
				["new_harbor_plains","northern_plains","central_dark_forest","new_harbor","western_grasslands"],
				["new_harbor_shore","new_harbor_orchard","-","-","-"],
				["northern_plains","southern_spire_foothills","northern_dark_forest","new_harbor_plains","wyndhaven_swamplands"],
				["western_grass_lands","wyndhaven_swamplands","new_harbor_plains","shattered_crags","-"],
				["shattered_crags","western_grass_lands","-","-","-"],
				["central_dark_forest","northern_dark_forest","northern_salt_spray_marsh","southern_dark_forest","new_harbor_plains"],
				["southern_dark_forest","central_dark_forest","southern_salt_spray_marsh","sea_dog_shores","-"],
				["northern_dark_forest","iron_heart_quarry","eastern_plains","central_dark_forest","northern_plains"],
				["eastern_plains","scorched_plains","salt_spray_fields","northern_salt_spray_marsh","northern_dark_forest"],
				["salt_spray_fields","-","-","salt_spray_port","eastern_plains"],
				["salt_spray_port","salt_spray_fields","-","-","-"],
				["iron_heart_quarry","escne","scorched_plains","northern_dark_forest","-"],
				["scorched_plains","southern_scorpion_sands","-","eastern_plains","iron_heart_quarry"],
				["northern_salt_spray_marsh","eastern_plains","-","southern_salt_spray_marsh","central_dark_forest"],
				["southern_salt_spray_marsh","northern_salt_spray_marsh","-","-","southern_dark_forest"],
				["sea_dog_shores","southern_dark_forest","-","-","-"],
				["southern_scorpion_sands","northern_scorpion_sands","-","scorched_plains","-"],
				["escne","spire_view","esc4","-","ecs3"],
				["escse","-","esc6","iron_heart_quarry","-"],
				["escwe","esc1","-","-","eastern_spire_foothills"],
				["esc1","esc3","esc2","escee","-"],
				["esc2","-","-","-","esc1"],
				["esc3","-","escne","esc1","-"],
				["esc4","-","esc5","-","escne"],
				["esc5","-","-","esc6","esc4"],
				["esc6","esc5","-","-","escne"],
				["southern_wyndhaven_grasslands","wyndhaven","wyndhaven_swamplands","-","-"],
				["wyndhaven_swamplands","wscse","northern_plains","western_grasslands","southern_wyndhaven_grasslands"],
				["wyndhaven","nothern_wyndhaven_grasslands","wscwe","southern_wyndhaven_grasslands","-"],
				["northern_scorpion_sands","-","-","southern_scorpion_sands","sandgrass_plains"],
				["sandgrass_plains","eastern_rebel_shores","northern_scorpion_sands","-","spire_view"],
				["spire_view","-","sandgrass_plains","escne","-"],
				["wscne","wyndhaven_forest","-","wsc5","-"],
				["wscee","-","western_spire_foothills","-","wsc5"],
				["wscse","wsc1","-","wyndhaven_swampland","-"],
				["wscwe","-","wsc3","-","wyndhaven"],
				["wsc1","-","wsc6","wscse","wsc2"],
				["wsc2","wsc3","wsc1","-","-"],
				["wsc3","-","wsc4","wsc2","wscwe"],
				["wsc4","-","wsc5","-","wsc3"],
				["wsc5","wscne","wscee","wsc6","wsc4"],
				["wsc6","wsc5","-","-","wsc1"],
				["wyndhaven_forest","western_rebel_battlefields","-","wscne","northern_wyndhaven_grasslands"],
				["northern_wyndhaven_grasslands","-","wyndhaven_forest","wyndhaven","-"],
				["spire_mountain_summit","northern_spire_foothills","eastern_spire_foothills","southern_spire_foothills","western_spire_foothills"],
				["northern_spire_foothills","eastern_rebel_battlefields","-","spire_mountain_summit","-"],
				["eastern_spire_foothills","-","escwe","-","spire_mountain_summit"],
				["southern_spire_foothills","spire_mountain_summit","-","northern_plains","-"],
				["western_spire_foothills","-","spire_mountain_summit","-","wscee"],
				["rebel_shores","-","western_rebel_battlefields","-","-"],
				["eastern_rebel_shores","-","-","sandgrass_plains","eastern_rebel_battlefields"],
				["eastern_rebel_battlefields","-","eastern_rebel_shores","northern_spire_foothills","central_rebel_battlefields"],
				["central_rebel_battlefields","-","eastern_rebel_battlefields","-","western_rebel_battlefields"],
				["western_rebel_battlefields","-","central_rebel_battlefields","wyndhaven_forest","rebel_shores"]
				
			].each do |dbn,np,ep,sp,wp|
				@world_data_db.execute "insert into world_paths values (?, ?, ?, ?, ?, ?)", nil,dbn,np,ep,sp,wp
			end
		end
		
		#get paths 
		def get_paths(loc_name)
			return @world_data_db.execute( "select * from world_paths where db_name = ? ", loc_name)
		end
		
		def get_just_paths(loc_name)
			return @world_data_db.execute( "select n_path, e_path, s_path, w_path from world_paths where db_name = ? ", loc_name)
		end
		
		
		##
		## WORLD MOBS TABLE
		##
		def create_world_mobs_tbl
			m_rows = @world_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS world_mobs (
					id INTEGER PRIMARY KEY,
					db_name varchar(60),
					mob_name varchar(30),
					day_flag int
				);
			SQL
		end
		
		def update_world_mobs_tbl
			begin
				@world_data_db.execute ("DELETE from world_mobs")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
				## Day flag  0 = night,  1 = day,  2 = both
			# [db_name, mob_name, day_flag]
			[
				["new_harbor","small_rat",2],
				["new_harbor","large_rat",0],
				["new_harbor_orchard","small_spider",2],
				["nhce","small_rat",2],
				["nhc1","large_rat",2],
				["nhc2","large_rat",2],
				["nhc2n","skeleton",2],
				["nhc3","skeleton",2],
				["nhc3n","skeleton",2],
				["nhc4","skeleton",2],
				["nhc5","skeleton",2],
				["nhc6","skeleton",2],
				["nhc7","skeleton",2]
				
			].each do |dbn,mn,df,b|
				@world_data_db.execute "insert into world_mobs values (?, ?, ?, ? )", nil,dbn,mn,df
			end
		end
		
		#query mobs
		def get_mobs(loc_name,tod)
			if tod == 0
				return @world_data_db.execute( "select * from world_mobs where db_name = ? and day_flag !=1", loc_name)
			elsif tod == 1
				return @world_data_db.execute( "select * from world_mobs where db_name = ? and day_flag !=0", loc_name)
			end
		end
		
		##
		## WORLD BOSSES TABLE
		def create_world_bosses_tbl
			m_rows = @world_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS world_bosses (
					id INTEGER PRIMARY KEY,
					db_name varchar(60),
					boss_name varchar(30),
					day_flag int
				);
			SQL
		end
		
		def update_world_bosses_tbl
			begin
				@world_data_db.execute ("DELETE from world_bosses")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
				## Day flag  0 = night,  1 = day,  2 = both
			# [db_name, boss_name, day_flag]
			[
				["new_harbor","rat_king",2,],
				["nhc2n","mr_afierin",2,],
				["nhc7","skeleton_king",2,]
				
			].each do |dbn,bn,df,b|
				@world_data_db.execute "insert into world_bosses values (?, ?, ?, ? )", nil,dbn,bn,df
			end
		end
		
		#query bosses
		def get_boss_mobs(loc_name,tod)
			if tod == 0
				return @world_data_db.execute( "select * from world_bosses where db_name = ? and day_flag !=1", loc_name)
			elsif tod == 1
				return @world_data_db.execute( "select * from world_bosses where db_name = ? and day_flag !=0", loc_name)
			end
		end
		
		##
		## WORLD NPCS TABLE
		##
		
		def create_world_npcs_tbl
			n_rows = @world_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS world_npcs (
					id INTEGER PRIMARY KEY,
					db_name varchar(60),
					npc_name varchar(30),
					day_flag int
				);
			SQL
		end
		
		def update_world_npc_tbl
			begin
				@world_data_db.execute ("DELETE from world_npcs")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
				## Day flag  0 = night,  1 = day,  2 = both
			# [db_name, npc_name, day_flag]
			[
				["new_harbor","old_man",2],
				["new_harbor","undertaker",0],
				["new_harbor","possible_widow",2],
				["nhc7","ghost_afierin",2]
				
			].each do |dbn,nn,tod|
				@world_data_db.execute "insert into world_npcs values (?, ?, ?, ?)", nil,dbn,nn,tod
			end
		end
		
		def get_npcs(db_name,tod)
			if tod == 0
				return @world_data_db.execute( "select * from world_npcs where day_flag !=1 and db_name=?", db_name)
			elsif tod == 1
				return @world_data_db.execute( "select * from world_npcs where day_flag !=0 and db_name=?", db_name)
				
			end
		end	
		
		##
		## WORLD NODES TABLE
		##
		def create_world_nodes_tbl
			p_rows = @world_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS world_nodes (
					id INTEGER PRIMARY KEY,
					db_name varchar(60),
					node_name varchar(30),
					node_type varchar(30),
					day_flag int
				);
			SQL
		end	
		
		def update_world_nodes_tbl
			begin
				@world_data_db.execute ("DELETE from world_nodes")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
				## Day flag  0 = night,  1 = day,  2 = both
			# [db_name, node_name, node_type, day_flag]
			[
				["new_harbor_orchard","basic_herbs","plant",2],
				["new_harbor_orchard","small_tree","tree",2],
				["new_harbor_orchard","apple_basket","loot",2],
				["new_harbor","old_barrel","loot",2],
				["nhce","copper_ore_node","ore",2],
				["nhc1","bone_pile","loot",2],
				["nhc2","bone_pile","loot",2],
				["nhc2n","bone_pile","loot",2],
				["nhc3","bone_pile","loot",2],
				["nhc3n","bone_pile","loot",2],
				["nhc4","bone_pile","loot",2],
				["nhc5","bone_pile","loot",2],
				["nhc6","bone_pile","loot",2],
				["nhc7","bone_pile","loot",2],
				["nhc1","discarded_gear","loot",2],
				["nhc2","discarded_gear","loot",2],
				["nhc2n","discarded_gear","loot",2],
				["nhc3","discarded_gear","loot",2],
				["nhc3n","discarded_gear","loot",2],
				["nhc4","discarded_gear","loot",2],
				["nhc5","discarded_gear","loot",2],
				["nhc6","discarded_gear","loot",2],
				["nhc7","discarded_gear","loot",2]
				
			].each do |dbn,nn,nt,tod|
				@world_data_db.execute "insert into world_nodes values (?, ?, ?, ?, ?)", nil,dbn,nn,nt,tod
			end
		end

		def get_nodes(db_name,tod,type)
			if tod == 0
				return @world_data_db.execute( "select * from world_nodes where day_flag !=1 and db_name=? and node_type=?", db_name, type)
			elsif tod == 1
				return @world_data_db.execute( "select * from world_nodes where day_flag !=0 and db_name=? and node_type=?", db_name, type)
			end
		end	
		
		def get_all_nodes(db_name,tod)
			if tod == 0
				return @world_data_db.execute( "select * from world_nodes where day_flag !=1 and db_name=?", db_name)
			elsif tod == 1
				return @world_data_db.execute( "select * from world_nodes where day_flag !=0 and db_name=?", db_name)
			end
		end	
		
		def get_node_types(db_name,tod)
			if tod == 0
				return @world_data_db.execute( "select node_type from world_nodes where day_flag !=1 and db_name=?", db_name)
			elsif tod == 1
				return @world_data_db.execute( "select node_type from world_nodes where day_flag !=0 and db_name=?", db_name)
			end
		end
		
	end
end
