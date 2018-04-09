require "sqlite3"

module RubyAdventure
	class PlayerData
		attr_accessor
		def initialize(pname,new)
				
			begin
				create_player_data_db(pname)
			rescue
				puts "Searching for a hero..."
			end
			
			
			# CREATE TABLES
			create_stats_tbl 
			create_inventory_tbl
			create_storage_tbl
			create_quest_tbl
			
			create_zones_tbl
			create_achievement_tbl
			create_all_skills_tbl
			create_player_skills_tbl
			create_main_npc_tbl
			puts "Doing some other creation things"
			create_gear_tbl

				
			#UPDATE TABLES
			if new == 1
				update_inventory_tbl
				update_storage_tbl 
				create_default_gear 
				update_zones_tbl
			end
			
			update_all_skills_tbl
			#update_quest_tbl ## will destroy Quests-- here for debug only
		
			
		end
		
		##
		## PLAYER_DATA DB 
		##
		
		def create_player_data_db(pname)
			@player_data_db = SQLite3::Database.new "adventure/db/#{pname}_data.db"
			#@game_data_db.results_as_hash = true
		end 
		
		#
		# Stats TABLE
		#
		def create_stats_tbl
			h_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS stats (
					id INTEGER PRIMARY KEY,
					name varchar(30),
					pclass varchar(30),
					locale varchar(60),
					exp int,
					level int,
					gold int,
					hp int,
					max_hp int,
					damage int,
					armor int,
					silver int, 
					sp int,
					max_sp int
				);
			SQL
		end
		
		def pull_player_stats
			return @player_data_db.execute( "select * from stats" )
		end
		
		def stat_tbl_check(pname)
			return @player_data_db.execute( "select name from stats where name = ?", pname )
		end
		
		##
		## GEAR TABLE
		##
		
		#create an empty dtable for inventory
		def create_gear_tbl
			p_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS gear (
					id INTEGER PRIMARY KEY,
					slot varchar,
					item_id int,
					bonus int
				);
			SQL
		end
		
		def create_default_gear
			begin
				@player_data_db.execute ("DELETE from gear")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
			[
				["armor",2,1],
				["weapon",1,1],
				["ring",3,1],
				["bracer",4,1]
				
			].each do |slot,item_id,bonus|
				@player_data_db.execute( "insert into gear values (?, ?, ?,? )", nil, slot, item_id, bonus)
			end
		end
		
		# query all gear data
		def show_gear(slot)
			return @player_data_db.execute( "select item_id, bonus from gear where slot = ?", slot )
		end
		
		def show_gear_detail(slot)
			return @player_data_db.execute( "select * from gear where slot = ?", slot )
		end
		
		def show_all_gear
			return @player_data_db.execute( "select * from gear" )
		end
				
		#
		# UPDATE GEAR
		def update_worn_gear(slot, item_id, bonus)
			stm = @player_data_db.prepare "UPDATE gear Set item_id=? WHERE slot=?"; stm.bind_param 1, item_id; stm.bind_param 2, slot;stm.execute;stm.close
			stm = @player_data_db.prepare "UPDATE gear Set bonus=? WHERE slot=?"; stm.bind_param 1, bonus; stm.bind_param 2, slot;stm.execute;stm.close
		end
		
		#
		# ADD Gear -- used when wearing a type of gear for first time
		def wear_first_gear(slot,item_id,bonus)
			@player_data_db.execute( "insert into gear values (?, ?, ?,? )", nil, slot, item_id, bonus)
		end
		
		
		
		
		##
		## INVENTORY TABLE
		##
							
		#create an empty dtable for inventory
		def create_inventory_tbl
			p_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS inventory (
					id INTEGER PRIMARY KEY,
					item_id integer,
					item_name varchar(60),
					quantity integer
				);
			SQL
		end
		
		## SAVE Player Inventory
		##
		def save_player_inv(inv)
			begin
				@player_data_db.execute ("DELETE from inventory")
			rescue
				puts "World data reloading"
			end
			inv.each do |x,y,z|
				@player_data_db.execute "insert into inventory values (?, ?, ?, ? )", nil,x,y,z
			end
		end
		
		def get_inv_items
			return @player_data_db.execute( "select item_id, item_name, quantity from inventory" )
		end
		
		def update_inventory_tbl
			begin
				@player_data_db.execute ("DELETE from inventory")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
			# [item_id, item_name, quantity]
			[
				[5, "Apple", 15],
				[3, "Tin Ring", 1],
				[1, "Large Stick", 1],
				[4, "Tin Bracer", 1],
				[2, "Padded Shirt", 1]
				
			].each do |x,y,z|
				@player_data_db.execute "insert into inventory values (?, ?, ?, ? )", nil,x,y,z
			end
		end
		##
		## NEED for each in the whole table to create an array of arrays
		#query all inventory data to load
		def show_inventory
			return @player_data_db.execute( "select * from inventory" )
		end
		
		def show_inventory_by_id(id)
			return @player_data_db.execute( "select * from inventory where id=?",id )
		end
		
		def show_inventory_by_item_id(item_id)
			return @player_data_db.execute( "select * from inventory where item_id=?",item_id )
		end
		
		def update_quantity_in_inv(item_id, num)
			stm = @player_data_db.prepare "UPDATE inventory Set quantity=? WHERE item_id=?"; stm.bind_param 1, num; stm.bind_param 2, item_id;stm.execute;stm.close
		end
		
		def delete_from_inv(id)
			@player_data_db.execute("DELETE from inventory WHERE ID = ?", id)
		end
		
		def add_to_inv(item_id, item_name, quantity)
			@player_data_db.execute "insert into inventory values (?, ?, ?, ?)", nil,item_id, item_name, quantity
		end
		
		
		##
		## ZONES TABLE
		##
		
		#create an empty dtable for inventory
		def create_zones_tbl
			p_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS zones (
					id INTEGER PRIMARY KEY,
					db_name varchar(60),
					zone_name varchar(60),
					opened int,
					portal int
				);
			SQL
		end
		
		def update_zones_tbl
			begin
				@player_data_db.execute ("DELETE from zones")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
			# [db_name, zone_name, opened, portal]
			[
				["new_harbor","New Harbor",1,1],
				["salt_spray_port","Salt Spray Port",1,0],
				["wyndhaven","Wyndhaven",1,0],
				["spire_view","Spire View",1,0]
				
			].each do |v,x,y,z|
				@player_data_db.execute "insert into zones values (?, ?, ?, ?, ? )", nil,v ,x,y,z
			end
		end
		
		def open_zone(db_name, opened)
			stm = @player_data_db.prepare "UPDATE zones Set opened=? WHERE db_name=?"; stm.bind_param 1, opened; stm.bind_param 2, db_name;stm.execute;stm.close
		end
		
		def activate_portal(zone_name, portal)
			stm = @player_data_db.prepare "UPDATE zones Set portal=? WHERE db_name=?"; stm.bind_param 1, portal; stm.bind_param 2, db_name;stm.execute;stm.close
		end
		
		def show_zone(db_name)
			return @player_data_db.execute( "select * from zones where db_name =?", db_name)
		end
		
		def get_port_zones
			return @player_data_db.execute( "select * from zones where portal =1")
		end
		
		def get_zone_by_id(id)
			return @player_data_db.execute( "select * from zones where id =?", id)
		end
		
		
		
		#
		## Player NPC TABLE
		##
		
		#create an empty db for storage
		def create_main_npc_tbl
			s_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS npcs (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					name varchar(30),
					repeat int
					
				);
			SQL
		end
		
		
		def add_player_npcs(dbn,n,r)
			@player_data_db.execute "insert into npcs values (?, ?, ?, ? )", nil,dbn,n,r
		end
		
		def get_player_npcs
			return @player_data_db.execute( "select db_name, name, repeat from npcs" )
		end
		
		def get_player_npcs_by_name(db_name)
			return @player_data_db.execute( "select db_name, name, repeat from npcs where db_name =?",db_name )
		end
		
		
		
		##
		## STORAGE TABLE
		##
		
		#create an empty db for storage
		def create_storage_tbl
			s_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS storage (
					id INTEGER PRIMARY KEY,
					item_id integer,
					item_name varchar(60),
					quantity integer
				);
			SQL
		end
		
		def save_player_storage(store)
			begin
				@player_data_db.execute ("DELETE from storage")
			rescue
				puts "World data reloading"
			end
			store.each do |x,y,z|
				@player_data_db.execute "insert into storage values (?, ?, ?, ? )", nil,x,y,z
			end
		end
		
		def get_storage_items
			return @player_data_db.execute( "select item_id, item_name, quantity from storage" )
		end
		
		
		def update_storage_tbl
			begin
				@player_data_db.execute ("DELETE from storage")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
			# [db_name, item_name, quantity]
			[
				[1, "Large Stick", 1],
				[3, "Apple", 10],
				
			].each do |x,y,z|
				@player_data_db.execute "insert into storage values (?, ?, ?, ? )", nil,x,y,z
			end
		end
		##
		## NEED for each in the whole table to create an array of arrays
		#query all storage data to load

		def show_storage
			return @player_data_db.execute( "select * from storage" )
		end
		
		def show_storage_by_id(id)
			return @player_data_db.execute( "select * from storage where id=?",id )
		end
		
		def show_storage_by_item_id(item_id)
			return @player_data_db.execute( "select * from storage where item_id=?",item_id )
		end
		
		def update_quantity_in_storage(item_id, num)
			stm = @player_data_db.prepare "UPDATE storage Set quantity=? WHERE item_id=?"; stm.bind_param 1, num; stm.bind_param 2, item_id;stm.execute;stm.close
		end
		
		def delete_from_storage(id)
			@player_data_db.execute("DELETE from storage WHERE ID = ?", id)
		end
		
		def add_to_storage(item_id, item_name, quantity)
			@player_data_db.execute "insert into storage values (?, ?, ?, ?)", nil,item_id, item_name, quantity
		end
	
		
		##
		## PLAYER Quest TABLE
		##
		
		#create an empty db for quests
		def create_quest_tbl
			q_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS quests (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					name varchar(30),
					descrip varchar(255),
					k_g_goal int,
					k_g_name varchar(30),
					exp_reward int,
					silver_reward int,
					gold_reward int,
					loot_reward varcar(30),
					k_g_count int,
					q_status varchar(5)
					
				);
			SQL
		end
		
		## PLAY QUEST TABLE UPDATE 
		def update_quest_tbl
			begin
				@player_data_db.execute ("DELETE from quests")
			rescue
				puts "Searching for jobs"
			end
			# Execute inserts
			#[ db_name, quest_name, descrip, k_g_goal, k_g_name, exp_reward, silver_reward, gold_reward, loot_reward, k_g_count, q_status] ** q_tatus A = Active, C = Completed, D = Dropped
	
			[				
				#["kill_rats", "eRATicate", "Kill 10 small rats",1, "small_rat",25,0,3,"apple_basket",0,"A"],
				["get_wood", "Woody", "Gather 15 soft wood",1, "soft_wood",25,0,3,"none",0,"A"]
				
			].each do |dbn,n,d,kgg,kgn,exp,sr,gr,loot,kgc,qs|
				@player_data_db.execute "insert into quests values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dbn,n,d,kgg,kgn,exp,sr,gr,loot,kgc,qs
			end
		end
		
		##
		## NEED for each in the whole table to create an array of arrays
		#query all storage data to load
		
		def add_quest(dbn,n,d,kgg,kgn,exp,sr,gr,loot,kgc,qs)
			@player_data_db.execute "insert into quests values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dbn,n,d,kgg,kgn,exp,sr,gr,loot,kgc,qs
		end
		
		def active_quest_by_kgname(kgname, qstatus)
			return @player_data_db.execute( "select * from quests where k_g_name=? and q_status=?",kgname, qstatus) # 
		end
		
		## Update kgcount
		def update_kgcount(quest_name, amount)
			stm = @player_data_db.prepare "UPDATE quests Set k_g_count = ? WHERE db_name=?"; stm.bind_param 1, amount; stm.bind_param 2, quest_name;stm.execute;stm.close
		end
		
		## Update q_status
		def update_qstatus(quest_name, qstatus)
			stm = @player_data_db.prepare "UPDATE quests Set q_status=? WHERE db_name=?"; stm.bind_param 1, qstatus; stm.bind_param 2, quest_name;stm.execute;stm.close
		end
		
		def quest_by_quest_name(quest_name)
			return @player_data_db.execute( "select * from quests where db_name=?",quest_name) 
		end
		
		# show active quests 
		def show_active_quests
			return @player_data_db.execute( "select * from quests where q_status='A'") 
		end
		
		# show all quests 
		def show_all_quests
			return @player_data_db.execute( "select * from quests") 
		end
		
		
		##
		## ACHIEVEMENT TABLE
		##
		
		#create an empty db for storage
		def create_achievement_tbl
			s_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS achievements (
					id INTEGER PRIMARY KEY,
					a_type int,
					a_db_name varchar(30),
					a_name varchar(60),
					a_counted varchar(30),
					quantity int,
					rank int
				);
			SQL
		end
		
		def get_all_achievements
			return @player_data_db.execute( "select * from achievements")
		end
		
		def get_location_achievements
			return @player_data_db.execute( "select * from achievements where a_counted = 'location'")
		end
		
		def get_achievements_by_type(a_db_name, a_type)
			return @player_data_db.execute( "select * from achievements where a_db_name= ? and a_type=?", a_db_name, a_type) 
		end
		
		def add_to_achieve(a_type, a_db_name, a_name, a_counted, quantity,rank)
			@player_data_db.execute "insert into achievements values (?, ?, ?, ?, ?, ?, ?)", nil, a_type, a_db_name, a_name, a_counted, quantity, rank
		end
		
		def update_achieve_count_by_id(id, quantity)
			stm = @player_data_db.prepare "UPDATE achievements Set quantity = quantity + ? WHERE id=?"; stm.bind_param 1, quantity; stm.bind_param 2, id;stm.execute;stm.close
		end
		
		def update_rank_count_by_id(id, rank)
			stm = @player_data_db.prepare "UPDATE achievements Set rank = ? WHERE id=?"; stm.bind_param 1, rank; stm.bind_param 2, id;stm.execute;stm.close
		end
		
		def get_achieve_by_type(a_type, a_counted)
			return @player_data_db.execute( "select * from achievements where a_type=? and a_counted =?", a_type, a_counted) 
		end
		
		##
		## ALL SKILLS TABLE
		##
		
		#create an empty db for quests
		def create_all_skills_tbl
			q_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS all_skills (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					name varchar(30),
					descrip varchar(255),
					sp_cost int,
					d_dmg int,
					p_dmg float,
					mh_dmg float,
					a_pen int,
					s_class varchar(10)
						
				);
			SQL
		end
		
		## ALL SKILL TABLE UPDATE 
		def update_all_skills_tbl
			begin
				@player_data_db.execute ("DELETE from all_skills")
			rescue
				puts "Searching for jobs"
			end
			# Execute inserts
			#[ db_name, name, descrip, sp_cost, d_dmg, p_dmg, mh_dmg, a_pen, s_class]
	
			[				
				["focused_force_I","Focused Force I","Focus your power to deal 10% more damage",1,0,0.1,0,0,"all"],
				["focused_force_II","Focused Force II","Focus your power to deal 20% more damage",2,0,0.2,0,0,"all"],
				["focused_force_III","Focused Force III","Focus your power to deal 30% more damage",4,0,0.3,0,0,"all"],
				["focused_force_IV","Focused Force IV","Focus your power to deal 40% more damage",8,0,0.4,0,0,"all"],
				["focused_force_V","Focused Force V","Focus your power to deal 50% more damage",16,0,0.5,0,0,"all"],
				["bone_crasher","Bone Crusher","Attack with great force dealing damage equal to 20% of your foes HP",6,0,0,0.2,0,"warrior"],
				["lacerate","Lacerate","Slice your foe dealing 20 armor ignoring damage.",8,20,0,0,1,"warrior"],
				["doom_blade","Doom Blade","Conjure doom upon your weapon dealing 35% of your foes health that ignores armor.",12,0,0,0.35,1,"warrior"],
				["final_blow","Final Blow","Attack with all of your strength to deal double damage",18,0,1,0,0,"warrior"],
				["backstab","Backstab","Stab your foe in the back dealing 10 direct damage",6,10,0,0,0,"rogue"],
				["glass_dagger","Glass Dagger","Cause a deep wound to your target that deals damage equal to 20% of their current health.",8,0,0,0.3,0,"rogue"],
				["dancing_knives","Dancing Knives","Slice at your foe quickly dealing 20 armor ignoring damage",12,20,0,0,1,"rogue"],
				["poison_blades","Poison Blades","Poison your foe dealing double damage",18,0,1,0,0,"rogue"],
				["magic_surge","Magic Surge","Strike your foe with a burst of magic damage dealing 10% of your foes health, which ignores armor",6,0,0,0.1,1,"mage"],
				["fire_ball","Fire Ball","Shoot a fireball at your foe dealing 15 direct damage",8,15,0,0,0,"mage"],
				["magic_missle","Magic Missle","Shoot a magic Missle at your foe dealing 30% of your foes health.",12,0,0,0.3,0,"mage"],
				["doom_orb","Doom Orb","Surround your foe with an orb of doom. Dealing tripple damage",18,0,2,0,0,"mage"]
				
			].each do |dbn,n,d,sp,dd,pd,mhd,ap,sc|
				@player_data_db.execute "insert into all_skills values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dbn,n,d,sp,dd,pd,mhd,ap,sc
			end
		end
		
		def get_all_skills_by_db_name(db_name)
			return @player_data_db.execute( "select * from all_skills where db_name=?",db_name)
		end
		
		##
		## PLAYER SKILLS TABLE
		##
		
		#create an empty db for quests
		def create_player_skills_tbl
			q_rows = @player_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS player_skills (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					name varchar(30),
					descrip varchar(255),
					sp_cost int,
					d_dmg int,
					p_dmg float,
					mh_dmg float,
					a_pen int
						
				);
			SQL
		end
		
		### PLAYER SKILL TABLE UPDATE 
		def update_player_skills_tbl
			begin
				@player_data_db.execute ("DELETE from player_skills")
			rescue
				puts "Searching for jobs"
			end
			# Execute inserts
			#[ db_name, name, descrip, sp_cost, d_dmg, p_dmg, mh_dmg, a_pen]
	
			[				
				["focused_force","Focused Force","Focus your power to deal 10% more damage",1,0,0.1,0,0]
				
			].each do |dbn,n,d,sp,dd,pd,mhd,ap|
				@player_data_db.execute "insert into player_skills values (?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dbn,n,d,sp,dd,pd,mhd,ap
			end
		end
		
		def add_to_player_skills(dbn,n,d,sp,dd,pd,mhd,ap)
			@player_data_db.execute "insert into player_skills values (?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dbn,n,d,sp,dd,pd,mhd,ap
		end
		
		def update_player_skill(dbn,n,d,sp,dd,pd,mhd,ap,old_dbn)
			stm = @player_data_db.prepare "UPDATE player_skills Set name=? WHERE db_name=?"; stm.bind_param 1, n; stm.bind_param 2, old_dbn;stm.execute;stm.close
			stm = @player_data_db.prepare "UPDATE player_skills Set descrip=? WHERE db_name=?"; stm.bind_param 1, d; stm.bind_param 2, old_dbn;stm.execute;stm.close
			stm = @player_data_db.prepare "UPDATE player_skills Set sp_cost=? WHERE db_name=?"; stm.bind_param 1, sp; stm.bind_param 2, old_dbn;stm.execute;stm.close
			stm = @player_data_db.prepare "UPDATE player_skills Set d_dmg=? WHERE db_name=?"; stm.bind_param 1, dd; stm.bind_param 2, old_dbn;stm.execute;stm.close
			stm = @player_data_db.prepare "UPDATE player_skills Set p_dmg=? WHERE db_name=?"; stm.bind_param 1, pd; stm.bind_param 2, old_dbn;stm.execute;stm.close
			stm = @player_data_db.prepare "UPDATE player_skills Set mh_dmg=? WHERE db_name=?"; stm.bind_param 1, mhd; stm.bind_param 2, old_dbn;stm.execute;stm.close
			stm = @player_data_db.prepare "UPDATE player_skills Set a_pen=? WHERE db_name=?"; stm.bind_param 1, ap; stm.bind_param 2, old_dbn;stm.execute;stm.close
			stm = @player_data_db.prepare "UPDATE player_skills Set db_name=? WHERE db_name=?"; stm.bind_param 1, dbn; stm.bind_param 2, old_dbn;stm.execute;stm.close
		end
		
		def get_player_skills
			return @player_data_db.execute( "select * from player_skills")
		end
		
		def get_player_skill_by_db_name(db_name)
			return @player_data_db.execute( "select * from player_skills where db_name =?", db_name)
		end
		
		def get_player_skill_by_id(id)
			return @player_data_db.execute( "select * from player_skills where id =?", id)
		end
		
		#
		# UPDATE STATS
		
		#update all stats
		def update_player_stats(pname, pclass, locale, exp, level, gold, hp, max_hp, damage, armor, silver,sp, max_sp)
			update_locale(pname, locale)
			update_exp(pname, exp)
			update_level(pname, level)
			update_gold(pname, gold)
			update_hp(pname, hp)
			update_max_hp(pname, max_hp)
			update_damage(pname, damage)
			update_armor(pname,armor)
			update_silver(pname,silver)
			update_sp(pname,sp)
			update_max_sp(pname,max_sp)
		end
		
		#add stats
		def add_player_stats(pname, pclass, locale, exp, level, gold, hp, max_hp, damage, armor, silver,sp,max_sp)
			@player_data_db.execute("insert into stats (id, name, pclass, locale, exp, level, gold, hp, max_hp, damage, armor, silver,sp,max_sp) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)", nil, pname, pclass, locale, exp, level, gold, hp, max_hp, damage, armor, silver, sp, max_sp)
		end
		
		#update individual stat
		def update_locale(pname, locale)
			stm = @player_data_db.prepare "UPDATE stats Set locale=? WHERE name=?"; stm.bind_param 1, locale; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_exp(pname, exp)
			stm = @player_data_db.prepare "UPDATE stats Set exp=? WHERE name=?"; stm.bind_param 1, exp; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_level(pname, level)
			stm = @player_data_db.prepare "UPDATE stats Set level=? WHERE name=?"; stm.bind_param 1, level; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_gold(pname, gold)
			stm = @player_data_db.prepare "UPDATE stats Set gold=? WHERE name=?"; stm.bind_param 1, gold; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_hp(pname, hp)
			stm = @player_data_db.prepare "UPDATE stats Set hp=? WHERE name=?"; stm.bind_param 1, hp; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_max_hp(pname, max_hp)
			stm = @player_data_db.prepare "UPDATE stats Set max_hp=? WHERE name=?"; stm.bind_param 1, max_hp; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_damage(pname, damage)
			stm = @player_data_db.prepare "UPDATE stats Set damage=? WHERE name=?"; stm.bind_param 1, damage; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_armor(pname,armor)
			stm = @player_data_db.prepare "UPDATE stats Set armor=? WHERE name=?"; stm.bind_param 1, armor; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_silver(pname,silver)
			stm = @player_data_db.prepare "UPDATE stats Set silver=? WHERE name=?"; stm.bind_param 1, silver; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_sp(pname,sp)
			stm = @player_data_db.prepare "UPDATE stats Set sp=? WHERE name=?"; stm.bind_param 1, sp; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		def update_max_sp(pname,max_sp)
			stm = @player_data_db.prepare "UPDATE stats Set max_sp=? WHERE name=?"; stm.bind_param 1, max_sp; stm.bind_param 2, pname;stm.execute;stm.close
		end
		
		
		
		
	end
end
