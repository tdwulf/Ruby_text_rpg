require "sqlite3"

module RubyAdventure
	class NpcData
		attr_accessor 
		def initialize
					
			begin
				create_npc_data_db
			rescue
			end
			
			#CREATE TABLES
			create_main_npc_tbl
			create_npc_dialog_tbl
		
			#UPDATE TABLES 
			update_main_npc_tbl
			update_npc_dialog_tbl
			
			puts "Oh look .. people.. greeaatt"

		end
		
		##
		## NPC DB 
		##
		
		def create_npc_data_db
			@npc_data_db = SQLite3::Database.new "adventure/db/npc_data.db"
			#@npc_data_db.results_as_hash = true
		end 

		##
		## Main NPC TABLE
		##
		
		#create an empty db for world locations
		def create_main_npc_tbl
			n_rows = @npc_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS npc_data (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					name varchar(30),
					prof varchar(30),
					repeat int,
					tod int,
					quest varchar(30),
					descrip varchar(255)
				);
			SQL
		end
		
		def update_main_npc_tbl
			begin
				@npc_data_db.execute ("DELETE from npc_data")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
				## Day flag  0 = night,  1 = day,  2 = both
			# [db_name, name, prof, repeat, tod, quest, descrip]
			[
				["old_man","Sir Morland","Knight",0,2,"kill_rat_king","An aged knight who has clearly seen battle."],
				["undertaker","Mr. Grim","Undertaker",0,1,"kill_skeletons","A well dressed undertaker. He appears scared."],
				["possible_widow","Mrs. Afierin","Wife",0,2,"find_mr_afierin","A frazzled looking woman. She appears to be concerned about something."],
				["ghost_afierin","Ghost of Mr Afierin","Ghost",0,2,"kill_skeleton_king","A hazy fog that seems to resemble Mr. Afierin"]
								
			].each do |dbn,n,p,r,tod,q,d|
				@npc_data_db.execute "insert into npc_data values (?, ?, ?, ?, ?, ?, ?, ? )", nil,dbn,n,p,r,tod,q,d
			end
		end
		
		#query npc data
		def npc_load_data(db_name)
			return @npc_data_db.execute( "select * from npc_data where db_name = ?", db_name )
		end
		
		
		##
		## NPC DIALOG TABLE
		##
		
		#create an empty db for world locations
		def create_npc_dialog_tbl
			n_rows = @npc_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS npc_dialog (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					talk1 varchar(255),
					talk2 varchar(255),
					talk3 varchar(255)

				);
			SQL
		end
		
		def update_npc_dialog_tbl
			begin
				@npc_data_db.execute ("DELETE from npc_dialog")
			rescue
				puts "World data reloading"
			end
			# Execute inserts
				## Day flag  0 = night,  1 = day,  2 = both
			# [db_name, talk1, talk2, talk3]
			[
				["old_man","You look like a strong young warrior.\nI could use your help with something.","A Rat King is terrorizing the town of New Harbor.","I am no longer strong enough to kill him.\nCan you kill him for me?"],
				["undertaker","I was taking some poor souls into the catacombs to lay them to rest.\nI was attacked by a skeleton.","Something very odd is happening in the catacombs.\nI have been doing this job for 30 years and I have never seen anything like this.","Would you pease by getting rid of the skeletons?\nMy livelyhood depends on being able to venture into the catacombs."],
				["possible_widow","Oh, you there. Are you an adventurer?\nYou must help me.","My husband ventured into the catacombs to deal with a skeleton problem.\nHe hasnt returned for days and I am very worried.","Will you go find him and bring him home to me?"],
				["ghost_afierin","Thank You for releasing me.","You must destory the Skeleton King.\nHe is trying to raise an army to destroy New Harbor.","none"]
				
			].each do |dbn,t1,t2,t3|
				@npc_data_db.execute "insert into npc_dialog values (?, ?, ?, ?, ?)", nil,dbn,t1,t2,t3
			end
		end
		
		#query npc data
		def npc_load_dialog(db_name)
			return @npc_data_db.execute( "select * from npc_dialog where db_name = ?", db_name )
		end

		
		
	end
end

