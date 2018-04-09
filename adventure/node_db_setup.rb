require "sqlite3"

module RubyAdventure
	class NodeData
		attr_accessor :show_by_id
		def initialize
			
			begin
				create_node_data_db
			rescue
			end
			
			#CREATE TABLES
			create_main_node_tbl
			
			
			#UPDATE TABLES 
			create_basic_nodes

		end
		
		##
		## NODE DB 
		##
		
		def create_node_data_db
			@node_data_db = SQLite3::Database.new "adventure/db/node_data.db"
			#@node_data_db.results_as_hash = true
		end 
		
		##
		## NODE TABLE
		##
		
		#create an empty db for world locations
		def create_main_node_tbl
			l_rows = @node_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS node_data (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					name varchar(30),
					decrip varchar(255),
					gather_times int,
					loot_name varchar(30)
				);
			SQL
		end
		
		def create_basic_nodes
			begin
				@node_data_db.execute ("DELETE from node_data")
			rescue
				puts "discovering items"
			end
			# Execute inserts
			#[ db_name, name, descrip, gather_times, loot_name]
			[
				["basic_herbs","Basic Herbs","Harvet to recieve basic herbs",3,"basic_herbs"],
				["small_tree","Small Tree","Harvet to recieve basic wood",3,"small_tree"],
				["apple_basket","Apple Basket","There may be delicous apples in this basket",1,"apple_basket"],
				["old_barrel","Old Barrel","There might be something useful in this old barrel",1,"old_barrel"],
				["copper_ore_node","Copper Ore Node","Harvest to recieve copper or other basic ore",3,"copper_ore_node"],
				["bone_pile","Pile of Bones","There may be something usefull in these bones",1,"dirty_loot"],
				["discarded_gear","Discarded Gear","There may be something useful in this pile of old gear",1,"small_loot"]
				
			].each do |dbn,n,d,gt,ln|
				@node_data_db.execute "insert into node_data values (?, ?, ?, ?, ?, ?)", nil,dbn,n,d,gt,ln
			end
		end
		
		
		#query node data
		def load_node_data(db_name)
			return @node_data_db.execute( "select * from node_data where db_name = ?", db_name)
		end
		
	end
end
