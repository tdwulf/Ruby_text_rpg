require "sqlite3"

module RubyAdventure
	class ItemData
		attr_accessor :show_by_id
		def initialize
			
			begin
				create_item_data_db
			rescue
				puts "Making something out of the void"
			end
			
			#CREATE TABLES
			create_main_item_tbl
			create_loot_tbl
			create_recipe_tbl
			
			#UPDATE TABLES
			create_basic_items
			create_loot
			create_recipes
			puts "I found SHINIES!!!!!"
	
		end
		
		##
		## ITEM DB 
		##
		
		def create_item_data_db
			@item_data_db = SQLite3::Database.new "adventure/db/item_data.db"
			#@item_data_db.results_as_hash = true
		end 
		
		##
		## ITEM TABLE
		##
		
		def create_main_item_tbl
			i_rows = @item_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS item_data (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					item_name varchar(30),
					descrip varchar(255),
					type varchar(30),
					level int,
					g_value int,
					equipable int,
					rarity varchar(10),
					hp_mod int,
					dmg_mod int,
					armor_mod int,
					consumable int,
					heal int,
					exp_gain int,
					s_value int,
					i_class varchar(10), 
					merch int,
					tod int,
					sp_mod int,
					sp int
				);
			SQL
		end
		
		def create_basic_items
			begin
				@item_data_db.execute ("DELETE from item_data")
			rescue
				puts "discovering items"
			end
			# Execute inserts
			# [ db_name, item_name, decrip, type, level, g_value, equipable, rarity, hp_mod, dmg_mod, armor_mod, consumable, heal, exp, s_value, i_class, merch,tod,spm,sp]
			# i_class options  all, warrior, rogue, mage
			[
				["large_stick","Large Stick","A gnarled log of wood that could be used as a weapon","weapon",0,0,1,"*",0,1,0,0,0,0,5,"all",1,2,0,0],
				["padded_shirt","Padded Shirt","Scruffy old shirt, provides some armor","armor",0,0,1,"*",0,0,1,0,0,0,5,"all",1,2,0,0],
				["tin_ring","Tin Ring","Old Tin ring, it may have some value","ring",0,0,1,"*",1,0,0,0,0,0,5,"all",1,2,0,0],
				["tin_bracer","Tin Bracer","Old Tin bracer, it may have some value","bracer",0,0,1,"*",0,0,0,0,0,0,5,"all",1,2,1,0],
				["apple","Apple","A nurishing snack that replenishes HP and SP","food",0,0,0,"*",0,0,0,1,2,0,2,"all",1,2,0,1],
				["rat_fur","Rat Fur","Piece of rat fur, it has little value.","trash",0,0,0,"-",0,0,0,0,0,0,1,"all",0,0,0,0],
				["soft_wood","Soft Wood","Piece of soft wood used for crafting","material",0,0,0,"*",0,0,0,0,0,0,1,"all",0,0,0,0],
				["basil_leaf","Basil Leaf","Leaf of Basil used for crafting","material",0,0,0,"*",0,0,0,0,0,0,1,"all",0,0,0,0],
				["rotten_apple","Rotten Apple","You could probably eat this, but it may have a better purpose.","food",0,0,0,"*",0,0,0,1,-2,0,1,"all",0,0,0,0],
				["basil_bundle","Basil Bundle","Carefully bundled basil leaves used for crafting","material",0,0,0,"*",0,0,0,0,0,0,3,"all",0,0,0,0],
				["soft_wood_plank","Soft Wood Plank","Plank of soft wood used for crafting","material",0,0,0,"*",0,0,0,0,0,0,3,"all",0,0,0,0],
				["spiced_apple","Spiced Apple","A nurishing snack that replenishes HP and SP","food",0,0,0,"*",0,0,0,1,4,0,5,"all",0,0,0,3],
				["copper_ore","Copper Ore","Lump of copper ore used for crafting","material",0,0,0,"*",0,0,0,0,0,0,1,"all",0,0,0,0],
				["copper_bar","Copper Bar","A small bar of Copper used in crafting","material",1,0,0,"*",0,0,0,0,0,0,5,"all",0,0,0,0],
				["copper_ring","Copper Ring","A crude copper ring that provides some HP bonus","ring",1,0,1,"*",3,0,0,0,0,0,8,"all",0,0,0,0],
				["copper_dagger","Copper Dagger","A crude copper dagger that provides some damage bonus","weapon",1,0,1,"*",0,2,0,0,0,0,16,"rogue",0,0,0,0],
				["copper_sword","Copper Sword","A crude copper sword that provides some damage bonus","weapon",1,0,1,"*",0,2,0,0,0,0,24,"warrior",0,0,0,0],
				["soft_wood_staff","Soft Wood Staff","A crude staff that provides some damage bonus","weapon",1,0,1,"*",0,3,0,0,0,0,16,"mage",0,0,0,0],
				["copper_bracer","Copper Bracer","A crude copper bracer that provides some SP bonus","bracer",1,0,1,"*",0,0,0,0,0,0,16,"all",0,0,2,0],
				["soft_hide","Soft Hide","A scrap of soft hide used to make leather","material",1,0,0,"*",0,0,0,0,0,0,2,"all",1,2,0,0],
				["cotton","Cotton","A cotton scrap used to make fabric","material",1,0,0,"*",0,0,0,0,0,0,2,"all",1,2,0,0],
				["bolt_of_cotton","Bolt of Cotton","A bolt of cotton fabric used to make cloth armor","material",1,0,0,"*",0,0,0,0,0,0,8,"all",0,0,0,0],
				["soft_leather","Soft Leather","A piece of soft leather used in making medium armor","material",1,0,0,"*",0,0,0,0,0,0,8,"all",0,0,0,0],
				["copper_chainmail","Copper Chainmail","Chainmail armor crafted from copper, provides bonus to armor","armor",1,0,1,"*",0,0,3,0,0,0,50,"warrior",0,0,0,0],
				["cotton_cloak","Cotton Cloak","Cloak made of cotton, provides small bonus to armor","armor",1,0,1,"*",0,0,2,0,0,0,50,"mage",0,0,0,0],
				["soft_leather_armor","Soft Leather Armor","Armor made of soft leather provides some bonus to armor","armor",1,0,1,"*",0,0,2,0,0,0,50,"rogue",0,0,0,0],
				["quartz_stone","Quartz Stone","Small quartz gem that can be sold","trash",0,0,0,"*",0,0,0,0,0,0,5,"all",0,0,0,0],
				["thyme_leaf","Thyme Leaf","Leaf of thyme used in crafting","material",0,0,0,"*",0,0,0,0,0,0,1,"all",0,0,0,0],
				["cinnamon","Cinnamon","Stick of cinnamon used in crafting","material",0,0,0,"*",0,0,0,0,0,0,2,"all",0,0,0,0],
				["thyme_bundle","Thyme Bundle","Carefully bundled thyme leaves used for crafting","material",0,0,0,"*",0,0,0,0,0,0,3,"all",0,0,0,0]
				
			].each do |dbn,n,d,t,l,gv,e,r,hm,dm,am,c,h,x,sv,cls,merch,tod,spm,sp|
				@item_data_db.execute "insert into item_data values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil,dbn,n,d,t,l,gv,e,r,hm,dm,am,c,h,x,sv,cls, merch, tod,spm,sp
			end
		end
		
		def get_item_by_db_name(db_name)
			@item_data_db.execute( "select * from item_data where db_name = ?", db_name )
		end
		
		def get_item_by_id(id)
			@item_data_db.execute( "select * from item_data where id = ?", id )
		end
		
		def get_item_name_by_db_name(db_name)
			@item_data_db.execute( "select item_name from item_data where db_name = ?", db_name )
		end
		
		def gear_show_by_id(id)
			db_data = @item_data_db.execute( "select * from item_data where id = ?", id )
			puts ""
			puts ""
			puts "#{db_data[0][2].upcase} (#{db_data[0][8]})"
			puts "\t#{db_data[0][3]}"
			puts ""
			if db_data[0][7] > 0
				puts "This item can be equipped, if you are a high enough level and the required class"
				puts ""
				puts "Level: #{db_data[0][5]}"
				puts "Class: #{db_data[0][16]}"
				puts " "
			else
			end
			
			item_type = db_data[0][4]
			case item_type
				when "weapon", "armor", "ring","bracer"
					puts "Stat bonus when equiped"
					puts "\t+HP: #{db_data[0][9]}"
					puts "\t+SP: #{db_data[0][19]}"
					puts "\t+DMG: #{db_data[0][10]}"
					puts "\t+ARMOR: #{db_data[0][11]}"
					puts""
				when "food"
						puts "This looks like something you can eat"
						puts "\tYou can consume this item to recover #{db_data[0][13]} health" if db_data[0][13] != 0
						puts "\tYou can consume this item to gain #{db_data[0][20]} skill/spell points" if db_data[0][20] != 0
						puts "\tYou can consume this item to gain #{db_data[0][14]} experience" if db_data[0][14] != 0
						puts ""
				when "material"
					puts "Used for crafting various items"
				else
					puts "This doesnt appear to be useful, a merchant may buy it, not sure why they want it. Best not to ask."
			end
			puts ""
			puts "Value: #{db_data[0][6]}g, #{db_data[0][15]}s"
			
		end
		
		
		##
		## LOOT TABLE
		##
		
		#create an empty db for world locations
		def create_loot_tbl
			l_rows = @item_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS loot_data (
					id INTEGER PRIMARY KEY,
					owner_name varchar(30),
					item_name varchar(30),
					item_quantity int,
					owner_type varchar(10)
				);
			SQL
		end
		
		def create_loot
			begin
				@item_data_db.execute ("DELETE from loot_data")
			rescue
				puts "discovering items"
			end
			# Execute inserts
			#[ owner_name, item_name, item_quantity, owner_type]
			[
				["small_rat","rat_fur",2,"mob"],
				["small_rat","rotten_apple",1,"mob"],
				["large_rat","rat_fur",3,"mob"],
				["large_rat","rotten_apple",2,"mob"],
				["basic_herbs","basil_leaf",2,"node"],
				["basic_herbs","thyme_leaf",2,"node"],
				["small_tree","soft_wood",3,"node"],
				["small_tree","cinnamon",2,"node"],
				["apple_basket","apple",1,"node"],
				["apple_basket","rotten_apple",1,"node"],
				["old_barrel","apple",1,"node"],
				["old_barrel","rotten_apple",1,"node"],
				["old_barrel","rat_fur",1,"node"],
				["kill_rats","apple",5,"quest"],
				["kill_rat_king","quartz_stone",2,"quest"],
				["copper_ore_node","copper_ore",3,"node"],
				["copper_ore_node","quartz_stone",2,"node"],
				["small_loot","large_stick",1,"node"],
				["small_loot","padded_shirt",1,"node"],
				["small_loot","tin_ring",1,"node"],
				["small_loot","tin_bracer",1,"node"],
				["small_loot","quartz_stone",1,"node"],
				["dirty_loot","quartz_stone",1,"node"],
				["dirty_loot","rat_fur",2,"node"],
				["dirty_loot","copper_bar",2,"node"],
				["mr_afierin","copper_ring",1,"mob"],
				["mr_afierin","copper_bracer",1,"mob"]
				
				
			].each do |owner_name, item_name, item_quantity, owner_type|
				@item_data_db.execute "insert into loot_data values (?, ?, ?, ?, ?)", nil, owner_name, item_name, item_quantity, owner_type
			end
		end
		
		
		#query loot data
		
		def get_loot_items(owner_name)
			return @item_data_db.execute( "select * from loot_data where owner_name = ?", owner_name )
		end
		
		
		##
		##MERCHANT
		def show_for_sale(plevel,a_tod)
			items = @item_data_db.execute( "select * from item_data where level <= ? and merch = ?", plevel,1)
			puts " "
			print "~"*20
			print "BUY ITEMS"
			print "~"*20
			puts " "
			puts " "
			#[ id, db_name, item_name, decrip, type, level, g_value, equipable, rarity, hp_mod, dmg_mod, armor_mod, consumable, heal, exp, s_value, i_class, merch,tod]
			items.each do | id,dbn,n,d,t,l,gv,e,r,hm,dm,am,c,h,x,sv,cls,merch,tod |
				if tod == a_tod || tod == 2
					puts "  Item ID #{id}: #{n}\t Value: #{gv}g, #{sv}s"
					case t
						when "weapon", "armor", "ring", "bracer"
							puts "\tEquip this #{t} to gain"
							puts "\tDamage: #{dm}  Armor: #{am}  MaxHP: #{hm}"
							print "-"*40
						when "food"
							puts "\tConsume this #{t} to heal for #{h}"
							puts "\tHealth"
							print "-"*40
						else
							puts "\t#{d}"
							print "-"*40
					end
					puts ""
				end
				
			end
		end
		
		
		##
		## Recipe TABLE
		##
		
		#create an empty db for world locations
		def create_recipe_tbl
			l_rows = @item_data_db.execute <<-SQL
				CREATE TABLE IF NOT EXISTS recipe_data (
					id INTEGER PRIMARY KEY,
					db_name varchar(30),
					recipe_name varchar(30),
					ttl_mats int,
					mat_one varchar(30),
					mat_one_q int,
					mat_two varchar(30),
					mat_two_q int,
					mat_three varchar(30),
					mat_three_q int,
					type varchar(30)
					
				);
			SQL
		end
		
		
		
		def create_recipes
			begin
				@item_data_db.execute ("DELETE from recipe_data")
			rescue
				puts "discovering items"
			end
			# Execute inserts
			#[ db_name, recipe_name, ttl_mats, mat_one, mat_one_q, mat_two, mat_two_q, mat_three, mat_three_q, type]
			[
				["basil_bundle","Basil Bundle",1,"basil_leaf",3,"none",0,"none",0,"refine"],
				["thyme_bundle","Thyme Bundle",1,"thyme_leaf",3,"none",0,"none",0,"refine"],
				["spiced_apple","Spiced Apple",2,"apple",1,"cinnamon",1,"none",0,"consumable"],
				["soft_wood_plank","Soft Wood Plank",1,"soft_wood",3,"none",0,"none",0,"refine"],
				["copper_bar","Copper Bar",1,"copper_ore",3,"none",0,"none",0,"refine"],
				["copper_ring","Copper Ring",1,"copper_bar",1,"none",0,"none",0,"jewelry"],
				["copper_dagger","Copper Dagger",1,"copper_bar",2,"none",0,"none",0,"weapon"],
				["copper_sword","Copper Sword",1,"copper_bar",3,"none",0,"none",0,"weapon"],
				["soft_wood_staff","Soft Wood Staff",1,"soft_wood_plank",3,"none",0,"none",0,"weapon"],
				["copper_bracer","Copper Bracer",1,"copper_bar",2,"none",0,"none",0,"jewelry"],
				["bolt_of_cotton","Bolt of Cotton",1,"cotton",3,"none",0,"none",0,"refine"],
				["soft_leather","Soft Leather",1,"soft_hide",3,"none",0,"none",0,"refine"],
				["copper_chainmail","Copper Chainmail",1,"copper_bar",5,"none",0,"none",0,"armor"],
				["cotton_cloak","Cotton Cloak",1,"bolt_of_cotton",5,"none",0,"none",0,"armor"],
				["soft_leather_armor","Soft Leather Armor",1,"soft_leather",5,"none",0,"none",0,"armor"]
				
			].each do |dbn,rn,ttm,mo,moq,mt,mtq,mth,mthq,type|
				@item_data_db.execute "insert into recipe_data values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nil, dbn,rn,ttm,mo,moq,mt,mtq,mth,mthq,type
			end
		end
		
		
		#query loot data
		
		def get_recipes
			return @item_data_db.execute( "select * from recipe_data" )
		end
		
		def get_recipe_by_type(type)
			return @item_data_db.execute( "select * from recipe_data where type=?",type )
		end
		
		def get_recipe_by_id(id)
			return @item_data_db.execute( "select * from recipe_data where id=?",id )
		end
		
		def get_recipe_by_dname(db_name)
			return @item_data_db.execute( "select * from recipe_data where db_name=?",db_name )
		end
		
	end
end
