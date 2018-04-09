require "sqlite3"

module RubyAdventure
	class MonsterData
		attr_accessor :show_by_id
		def initialize
				
			begin
				create_monster_data_db
			rescue
			end
			
			#CREATE TABLES
			create_main_monster_tbl
			
			#UPDATE TABLES
			create_monsters
			
		end
		
		##
		## GAME_DATA Main DB 
		##
		
		def create_monster_data_db
			@monster_data_db = SQLite3::Database.new "adventure/db/monster_data.db"
			#@monster_data_db.results_as_hash = true
		end 
		
		##
		## MONSTER TABLE
		##
		
		#create an empty db for world locations
		def create_main_monster_tbl
			m_rows = @monster_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS monster_data (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					name varchar(30),
					descrip varchar(255),
					level int,
					hp int,
					max_hp int,
					damage int,
					armor int,
					boss int,
					exp int,
					silver int, 
					gold int
				);
			SQL
		end
		
		def create_monsters
			begin
				@monster_data_db.execute ("DELETE from monster_data")
			rescue
				puts "discovering items"
			end
			# Execute inserts
			#[ db_name, name, descrip, level, hp, max_hp, damage, armor, boss, exp, silver, gold]
			[
				["small_rat","Small Rat","An small ugly rodent with sharp teeth and a hell of an attitude.",0,3,3,1,1,0,2,0,0],
				["large_rat","Large Rat","An larger uglier rodent with sharp teeth and a hell of an attitude.",0,5,5,2,2,0,4,0,0],
				["rat_king","Rat King","Is that rat wearing a crown?",1,8,8,3,2,1,10,0,0],
				["small_spider","Small Spider","No spider should be that large. EVER!",1,5,5,2,2,0,4,0,0],
				["large_spider","Large Spider","That spider is even larger than the other. Gross!",1,10,10,3,3,0,8,0,0],
				["spider_queen","Spider Queen","OMG! That spider is gigantic",2,14,14,4,4,1,20,0,0],
				["skeleton","Skeleton","How is it even walking? It has no flesh, no muscles..",0,5,5,3,1,0,6,0,0],
				["mr_afierin","Mr Afierin","I think he is dead",1,7,7,3,1,1,15,25,0],
				["skeleton_king","Skeleton King","That is a mean looking skeleton",1,10,10,4,2,1,15,25,0]
				
			].each do |dbn,n,d,l,h,mh,dmg,arm,boss,exp,silver,gold|
				@monster_data_db.execute "insert into monster_data values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dbn,n,d,l,h,mh,dmg,arm,boss,exp,silver,gold
			end
		end
		
		
		#query monster data
		def monster_load_data(monster_id)
			return @monster_data_db.execute( "select * from monster_data where id = ?", monster_id )
		end
		def monster_load_data_by_name(monster_name)
			return @monster_data_db.execute( "select * from monster_data where db_name = ?", monster_name )
		end
		
		
		
	end
end
