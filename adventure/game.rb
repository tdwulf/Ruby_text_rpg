
module RubyAdventure
	class Game
		attr_accessor :run_command, :quest_data
		
		def initialize
			@tod = 1
			@game_running = true
			@game_battle = false
			@inv_running = false
			@game_gather = false
			@storage_running = false
			@game_merchant = false
			@quest_board = false
			@npc_running = false
			@craft_table = false
			@world = World.new
			@game_data = GameData.new
			@monster_data = MonsterData.new
			@item_data = ItemData.new
			@npc_data = NpcData.new
			@node_data = NodeData.new
			@quest_data = QuestData.new
			sleep 1
			char_check
		end
		
		
		def game_loop
			while @game_running == true do
				time = Time.now
				puts " "
				if time.hour.to_i % 2 == 0 
					puts "It is currently night time" ## @tod = 0
					puts "\t Beware of stronger monsters lurking about"
					@tod = 0
				else
					puts "It is currently day time"
					@tod = 1
				end
				### add in some day of week check for additional spawn events
				puts " "
				print 'What do you do? >> '
				action = gets.chomp.strip
				run_command(action)
			end
		end
		
		def battle_loop
			while @game_battle == true
				##Battle Loop
				system "clear" or system "cls"
				puts " "
				puts "oxxxx{::::::::::>  <::::::::::}xxxxo"
				puts ""
				if @monster.boss == 1
					puts "You are in a BOSS battle with a level #{@monster.level}, '#{@monster.name}'"
				else
					puts "You are in a battle with a level #{@monster.level}, #{@monster.name}"
				end
				puts "\t#{@monster.descrip}"
				puts " "
				puts "#{@monster.name} HP: #{@monster.hp.round(2)}/#{@monster.max_hp}"
				puts " "
				puts "Your HP: #{@player.hp.round(2)}/#{@player.max_hp}"
				puts "Your SP: #{@player.sp}/#{@player.max_sp}"
				puts " "
				print 'Fight Action? >> '
				action = gets.chomp.strip
				run_battle_command(action)
			end
		end
		
		
		def inv_loop
			while @inv_running == true do
				show_full_inv_data
				puts " "
				print 'Inventory Action? >> '
				action = gets.chomp.strip
				inv_command(action)
			end
		end
		def storage_loop
			while @storage_running == true do
				@player.show_storage
				puts " "
				print 'Storage Action? >> '
				action = gets.chomp.strip
				storage_command(action)
			end
		end
		
		def gathering_loop
			while @game_gather == true do
				@node.display_node
				puts " "
				print 'Gathering Action? >> '
				action = gets.chomp.strip
				gather_command(action)
			end
		end
		
		def merchant_loop
			while @game_merchant == true do
				puts " "
				puts " "
				print "-"*20
				print "Welcome to the Merchant"
				puts " "
				puts "Would you like to buy or sell?"
				puts " "
				print "Merchant Action? >> "
				action = gets.chomp.strip
				merchant_command(action)
			end
		end
		
		def quest_board_loop
			while @quest_board == true
				system "clear" or system "cls"
				puts " "
				puts " "
				print "-"*20
				print "Available Quests"
				puts ""
				puts ""
				display_open_quests
				puts ""
				print "Quest Board Action? >> "
				action = gets.chomp.strip
				quest_board_command(action)
			end
		end
		
		def npc_loop
			while @npc_running == true
				system "clear" or system "cls"
				puts " "
				puts " "
				@npc.display_npc
				puts ""
				puts ""
				print "NPC Action? >> "
				action = gets.chomp.strip
				npc_command(action)
			end
		end
		
		
		def craft_loop(menu)
			while @craft_table == true
				system "clear" or system "cls"
				puts " "
				puts " "
				display_craft_table(menu)
				puts ""
				puts ""
				print "Crafting Action? >> "
				action = gets.chomp.strip
				craft_command(action)
			end
		end
		
		
		
		
		def char_check
			print 'Enter your character\'s name '
			pname = gets.chomp.strip
			pcheck = @game_data.check_player(pname)
			if pcheck.length == 0
				puts "Creating new character"
				sleep 0.2
				print "."
				sleep 0.2
				print ".."
				sleep 0.2
				print "..."
				puts " "
				char_build(pname)
			elsif pcheck[0][0] == pname
				puts "user exists"
				char_login(pname)
			else
				puts "Something has gone terrible wrong"
				char_check
			end
		end
		
		def char_login(pname)
			system "clear" or system "cls" 
			puts " " * 5 
			puts "Welcome back #{pname}"
			puts ""
			print "Please enter your password "
			trys = 0
			passwd = gets.chomp.strip
			password = cipher(passwd).join
			while trys < 3 do
				if @game_data.check_pass(pname)[0][0] != password
					trys +=1
					print "Type your password again "
					passwd = gets.chomp.strip
				else
					@player = Player.new(pname,"Pleb",0)
					@player.load_db_stats
					@player.load_db_gear
					run_command("stats")
					trys = 5
					game_loop
				end
			end
			
		end
		
		def char_build(pname)
			puts "Welcome #{pname.capitalize}, Please choose a class"
			puts '	1. Warrior'
			puts '	2. Rogue' 
			puts '	3. Mage' 
			print 'Please type a number (1-3)'
			pclass = gets.chomp.strip.to_i
			while pclass != 1 && pclass != 2 && pclass != 3 do
				print 'Please type a number (1-3)'
				pclass = gets.chomp.strip.to_i
			end
			case pclass
				when 1
					pclass = "warrior"
				when 2
					pclass = "rogue"
				when 3
					pclass = "mage"
			end
			@player = Player.new(pname, pclass,1)
			puts ""
			puts ""
			puts "Your name is #{@player.p_name.capitalize}, welcome"  #DEBUGGING
			puts "Your class is #{@player.p_class.capitalize}.."   #DEBUGGING
			puts " "
			sleep 1
			set_pass
			system "clear" or system "cls"
			puts "Welcome to the game, type help to see list of commands." ### should be more info here
			game_loop
		end
		
		def set_pass
			print "Please select a password: "
			passwd = gets.chomp.strip
			puts ""
			print "Please re-enter your password: "
			passwd2 = gets.chomp.strip
			if passwd == passwd2
				password = cipher(passwd).join
				@game_data.add_player(@player.p_name, password)
			else
				puts "Passwords do not match"
				sleep 1
				set_pass
			end
		end
		
		def cipher(string, shift = 5)
			alphabet   = Array('a'..'z')
			encrypter  = Hash[alphabet.zip(alphabet.rotate(shift))]
			string.chars.map { |c| encrypter.fetch(c, " ") }
		end
		
		
		### COMMANDS
		def run_command(action)
			loc_data = @world.location_detail(@player.locale)
			paths = @world.get_paths(@player.locale)
			descrip = @world.get_descrip(@player.locale)
			case action
				when "cls"
					system "clear" or system "cls"
					game_loop
				when "log", "ql"
					show_quests
					game_loop
				when "exit"
					@game_running = false
					game_loop
				when "inv"
					@inv_running = true
					system "clear" or system "cls"
					inv_loop
				when "port", "portal"
					if loc_data[0][3] == "town"
						system "clear" or system "cls"
						show_portal
					else
						puts "You must be in a town to access the portal."
						game_loop
					end	
				when "quests", "jobs"
					if loc_data[0][3] == "town"
						@quest_board = true
						system "clear" or system "cls"
						quest_board_loop
					else
						puts "You must be in a town to access available quest jobs."
						game_loop
					end	
				when "craft"
					if loc_data[0][3] == "town"
						@craft_table = true
						system "clear" or system "cls"
						craft_loop("main")
					else
						puts "You must be in a town to access available quest jobs."
						game_loop
					end	
				when "merchant", "shop","merch"
					if loc_data[0][3] == "town"
						@game_merchant = true
						system "clear" or system "cls"
						merchant_loop
					else
						puts "You must be in a town to access the merchant"
						game_loop
					end	
				when "storage", "bank"
					if loc_data[0][3] == "town"
						@storage_running = true
						system "clear" or system "cls"
						storage_loop
					else
						puts "You must be in a town to access storage"
						game_loop
					end
				when "skills", "spells"
					@player.show_player_skills
					game_loop
				when "l1"
					@player.level_up(1)
				when "l2"
					@player.level_up(2)
				when "XX"
					skill = @player.all_skill_by_db_name("focused_force_1")
					skill.each do |id,dbn,n,d,sp,dd,pd,mhd,ap,sc|
						@player.add_to_player_skills(dbn,n,d,sp,dd,pd,mhd,ap)
						puts "#{n} added to skills"
					end
					sleep 1
					game_loop
				when "stats"
					system "clear" or system "cls"
					@player.display_character(loc_data[0][2])
					game_loop
				when "help", "h" 
					@game_data.view_help_by_state("main")
					game_loop
				when "look"
					system "clear" or system "cls"
					puts ""
					puts ""
					puts ""
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]} #{descrip[0][0]}"
					puts "--"*20
					puts ""
					puts "PATHS"
					path_names = @world.get_just_paths(@player.locale)[0]
					begin 
						puts "\tTo the North: #{@world.location_detail(paths[0][2])[0][2]}" if path_names[0] != "-" 
					rescue 
					end
					begin 
						puts "\tTo the East: #{@world.location_detail(paths[0][3])[0][2]}" if path_names[1] != "-" 
					rescue 
					end
					begin 
						puts "\tTo the South: #{@world.location_detail(paths[0][4])[0][2]}" if path_names[2] != "-" 
					rescue 
					end
					begin 
						puts "\tTo the West: #{@world.location_detail(paths[0][5])[0][2]}" if path_names[3] != "-" 
					rescue 
					end
					puts ""
					game_loop
				when "sinv"
					show_full_inv_data
				when "IAMGOD"
					system "clear" or system "cls"
					@player.god
					@player.display_character("#{loc_data[0][1]}")
					game_loop
				when "save" 
					@player.save_stats
					@player.save_gear
					puts "Player Saved"
					game_loop
				when "load"
					system "clear" or system "cls"
					@player.load_db_gear
					@player.load_db_stats
					@player.display_character("#{loc_data[0][1]}")
					game_loop
				when "weapon"
					system "clear" or system "cls"
					puts "No weapon equiped" if @player.weapon[0] == 0
					@item_data.gear_show_by_id(@player.weapon[0]) if @player.weapon[0] != 0
					game_loop
				when "armor"
					system "clear" or system "cls"
					puts "No armor equiped" if @player.gear[0] == 0
					@item_data.gear_show_by_id(@player.gear[0]) if @player.gear[0] != 0
					game_loop
				when "ring"
					system "clear" or system "cls"
					puts "No ring equiped" if @player.ring[0] == 0
					@item_data.gear_show_by_id(@player.ring[0]) if @player.ring[0] != 0
					game_loop
				when "bracer"
					system "clear" or system "cls"
					puts "No ring equiped" if @player.bracer[0] == 0
					@item_data.gear_show_by_id(@player.bracer[0]) if @player.bracer[0] != 0
					game_loop
				when "rest"
					print "How long would you like to rest for? (enter 1-10) "
					time = gets.chomp.strip
					@player.rest(time)
					game_loop
				when "walk", "w"
					system "clear" or system "cls"
					achieve = @player.get_achievements_by_type(@player.locale, "walk")
					if achieve.length == 0
						@player.add_to_achieve("walk", @player.locale, loc_data[0][2], "location", 1)
					else
						@player.update_achieve_count_by_id(achieve[0][0], 1)
					end
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]} #{descrip[0][0]}"
					puts " "
					rnd_num = rand(1..100)
					count_bosses = @world.get_boss_mobs(loc_data[0][1],@tod).length.to_i
					count_mobs = @world.get_mobs(loc_data[0][1],@tod).length.to_i
					count_nodes = @world.get_all_nodes(loc_data[0][1],@tod).length.to_i
					count_npcs = @world.get_npcs(@player.locale,@tod).length.to_i
					rand_boss = rand(count_bosses)-1
					begin
						b_name = @world.get_boss_mobs(@player.locale,@tod)[rand_boss][2]
					rescue
						b_name ="none"
					end
					begin
						q_boss = @player.active_quest_by_kgname(b_name, "A")[0][5]
					rescue
						q_boss = "none"
					end
					
					if rnd_num <= 25 && loc_data[0][5] != 0 && count_bosses != 0 && q_boss != "none"
						create_monster(b_name)
						@game_battle = true
						battle_loop
					elsif rnd_num <= 25 && loc_data[0][5] != 0 && count_mobs != 0
						@game_battle = true
						rand_mob = rand(count_mobs)-1
						m_name = @world.get_mobs(@player.locale,@tod)[rand_mob][2]
						create_monster(m_name)
						battle_loop
					elsif rnd_num <= 60 && loc_data[0][8] !=0 && count_nodes != 0
						nodes = @world.get_node_types(@player.locale,@tod)
						rnd_node = nodes.sample
						node = @world.get_nodes(loc_data[0][1],@tod,rnd_node.to_s)[0]
						node_name = node[2]
						create_node(node_name)
						@game_gather = true
						gathering_loop
					elsif rnd_num >= 61 && count_npcs != 0
						begin
							npc_list = @world.get_npcs(@player.locale,@tod)
							rand_npc = rand(count_npcs)-1
							npc = npc_list[rand_npc]
							npc_name = npc[2]
							begin
								p_npc = @player.get_npcs(npc_name)[0][0]
							rescue
								p_npc = "vacant"
							end
							if npc[3] == 1 || p_npc != npc_name
								@npc_running = true
								create_npc(npc_name)
								npc_loop
							end
						end
					else
						game_loop
					end
				when "north"
					if paths[0][2] != "-"
						new_loc = @world.location_detail(paths[0][2])
						if @player.level < new_loc[0][4]
							puts "Level #{new_loc[0][4]} is required to travel to #{new_loc[0][2]}"
						#elsif @player.get_zone_opened(new_loc[0][1]) == 0
							#puts "This area is not currently accessable"
						else
							system "clear" or system "cls"
							@player.locale = new_loc[0][1]
							@player.save_stats
							puts "Traveling to #{new_loc[0][2]}"
							sleep 1.5
							run_command("look")
						end
					else 
						puts "There is no clear path in that direction"
					end
					game_loop
							
				when "east"
					if paths[0][3] != "-"
						new_loc = @world.location_detail(paths[0][3])
						if @player.level < new_loc[0][4]
							puts "Level #{new_loc[0][4]} is required to travel to #{new_loc[0][2]}"
						#elsif @player.get_zone_opened(new_loc[0][1]) == 0
							#puts "This area is not currently accessable"
						else
							system "clear" or system "cls"
							@player.locale = new_loc[0][1]
							@player.save_stats
							puts "Traveling to #{new_loc[0][2]}"
							sleep 1.5
							run_command("look")
						end
					else 
						puts "There is no clear path in that direction"
					end
					game_loop
				when "south"
					if paths[0][4] != "-"
						new_loc = @world.location_detail(paths[0][4])
						if @player.level < new_loc[0][4]
							puts "Level #{new_loc[0][4]} is required to travel to #{new_loc[0][2]}"
						#elsif @player.get_zone_opened(new_loc[0][1]) == 0
							#puts "This area is not currently accessable"
						else
							system "clear" or system "cls"
							@player.locale = new_loc[0][1]
							@player.save_stats
							puts "Traveling to #{new_loc[0][2]}"
							sleep 1.5
							run_command("look")
						end
					else 
						puts "There is no clear path in that direction"
					end
					game_loop
				when "west"
					if paths[0][5] != "-"
						new_loc = @world.location_detail(paths[0][5])
						if @player.level < new_loc[0][4]
							puts "Level #{new_loc[0][4]} is required to travel to #{new_loc[0][2]}"
						#elsif @player.get_zone_opened(new_loc[0][1]) == 0
							#puts "This area is not currently accessable"
						else
							system "clear" or system "cls"
							@player.locale = new_loc[0][1]
							@player.save_stats
							puts "Traveling to #{new_loc[0][2]}"
							sleep 1.5
							run_command("look")
						end
					else 
						puts "There is no clear path in that direction"
					end
					game_loop
				when "map"
					system "clear" or system "cls"
					@player.show_map_achievements(loc_data[0][2])
					game_loop
				when "steps"
					system "clear" or system "cls"
					@player.show_achievements("walk","location")
					game_loop
				when "kills"
					system "clear" or system "cls"
					@player.show_achievements("kill","monster")
					game_loop
				when "gathered"
					system "clear" or system "cls"
					@player.show_achievements("gather","material")
					game_loop
				else
					puts "Invalid Command - type help for more commands"
					game_loop
			end
		end
		
		##
		## BATTLE COMMANDS
		
		def run_battle_command(action)
			loc_data = @world.location_detail(@player.locale)
			case action 
				when "run", "r"
					if rand(100) > 66
						puts "You run away from the fight"
						@game_battle = false
						@monster = nil
						game_loop
					else
						puts "You try to run but fail"
						sleep 0.2
						puts "#{@monster.name} attacks you"
						sleep 0.1
						playerdmg = @monster.attack - (@player.armor/2.0)
						playerdmg = 0.0 if playerdmg < 0.0
						if @player.take_dmg(playerdmg) == 0
							@game_battle = false
							@monster = nil
							@player.death
							game_loop
						else
							puts "You have taken #{playerdmg.round(2)} damage."
							puts "HP: #{@player.hp.round(2)}/#{@player.max_hp}"
							battle_loop
						end
					end
				when "skills","spells"
					@player.show_player_skills
					puts ""
					print "Press enter to continue "
					escape = gets
					battle_loop
				when "1","s1"
					skill = @player.player_skill_by_id(1)
					if skill.length != 0
						if skill [0][4] <= @player.sp
							dmg = skill_dmg(1)
							attack(dmg,skill[0][8],"skill")
						else
							puts "You do not have enough SP to use #{skill [0][2]}"
							sleep 1
							battle_loop
						end
					else
						puts "Skill 1 is empty" if @player.class != "mage"
						puts "Spell 1 is empty" if @player.class == "mage"
						sleep 1
						battle_loop
					end
				when "2","s2"
					skill = @player.player_skill_by_id(2)
					if skill.length != 0
						if skill [0][4] <= @player.sp
							dmg = skill_dmg(2)
							attack(dmg,skill[0][8],"skill")
						else
							puts "You do not have enough SP to use #{skill [0][2]}"
							sleep 1
							battle_loop
						end
					else
						puts "Skill 2 is empty" if @player.class != "mage"
						puts "Spell 2 is empty" if @player.class == "mage"
						sleep 1
						battle_loop
					end
				when "3","s3"
					skill = @player.player_skill_by_id(3)
					if skill.length != 0
						if skill [0][4] <= @player.sp
							dmg = skill_dmg(3)
							attack(dmg,skill[0][8],"skill")
						else
							puts "You do not have enough SP to use #{skill [0][2]}"
							sleep 1
							battle_loop
						end
					else
						puts "Skill 3 is empty" if @player.class != "mage"
						puts "Spell 3 is empty" if @player.class == "mage"
						sleep 1
						battle_loop
					end
				when "4","s4"
					skill = @player.player_skill_by_id(4)
					if skill.length != 0
						if skill [0][4] <= @player.sp
							dmg = skill_dmg(4)
							attack(dmg,skill[0][8],"skill")
						else
							puts "You do not have enough SP to use #{skill [0][2]}"
							sleep 1
							battle_loop
						end
					else
						puts "Skill 4 is empty" if @player.class != "mage"
						puts "Spell 4 is empty" if @player.class == "mage"
						sleep 1
						battle_loop
					end
				when "5","s5"
					skill = @player.player_skill_by_id(5)
					if skill.length != 0
						if skill [0][4] <= @player.sp
							dmg = skill_dmg(5)
							attack(dmg,skill[0][8],"skill")
						else
							puts "You do not have enough SP to use #{skill [0][2]}"
							sleep 1
							battle_loop
						end
					else
						puts "Skill 5 is empty" if @player.class != "mage"
						puts "Spell 5 is empty" if @player.class == "mage"
						sleep 1
						battle_loop
					end
				when "attack", "a"
					base_dmg = @player.damage/2
					dmg = rand(base_dmg..@player.damage)
					attack(dmg,0,"base")
					game_loop
				when "help"
					@game_data.view_help_by_state("battle")
					sleep 3
					battle_loop
				when "rest"
					puts "You cannot rest while fighting"
				when "consume"
					show_full_inv_data
					print "Type a Slot number to consume item(s) "
					id = gets.chomp.strip
					item_id = @player.get_data_from_slot(id,"inventory")[0][1]
					item = @item_data.get_item_by_id(item_id)
					if item[0][12] == 1 && item[0][5] <= @player.level
						@player.remove_from_inv(id,"consume",item[0][13],item[0][14],item[0][20],0)
						sleep 0.2
						puts " "
						puts "#{@monster.name} attacks you"
						sleep 0.1
						playerdmg = @monster.attack - (@player.armor/3.0)
						playerdmg = 0.0 if playerdmg < 0.0
						if @player.take_dmg(playerdmg) == 0
							@game_battle = false
							@monster = nil
							@player.death
							game_loop
						else
							puts "You have taken #{playerdmg.round(2)} damage."
							puts "HP: #{@player.hp.round(2)}/#{@player.max_hp}"
							sleep 1
							battle_loop
						end
					else
						puts "This item is not consumable"
					end
					
					battle_loop
				else
					puts "Invalid Command - type help for more commands"
					battle_loop
			end
		end
		
		##
		## INVENTORY COMMANDS
		def inv_command(action)
			loc_data = @world.location_detail(@player.locale)
			case action
				when "close", "exit"
					@inv_running = false
					system "clear" or system "cls"
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
					game_loop
				when "help", "h"
					@game_data.view_help_by_state("inventory")
					inv_loop
				when "delete", "del"
					print "Type a Slot number to delete item(s) "
					id = gets.chomp.strip
					@player.remove_from_inv(id, "delete")
					inv_loop
				when "inspect"
					print "Type a slot number to inspect the item in it"
					id = gets.chomp.strip
					item_id = @player.get_data_from_slot(id,"inventory")[0][1]
					puts " " 
					puts " "
					@item_data.gear_show_by_id(item_id)
					puts " " 
					puts " "
				when "sell", "s"
					if loc_data[0][3] == "town"
						show_full_inv_data
						puts " "
						print "Type a Slot number to sell item(s) "
						id = gets.chomp.strip
						item_id = @player.get_data_from_slot(id,"inventory")[0][1]
						value = @item_data.get_item_by_id(item_id)
						gvalue = value[0][6]
						svalue = value[0][15]
						@player.remove_from_inv(id,"sell",gvalue,svalue,0,0)
					else
						puts "You must be in a town to sell items"
						game_loop
					end
					inv_loop
				when "equip"
					print "Type a Slot number to equip the item "
					id = gets.chomp.strip
					item_id = @player.get_data_from_slot(id,"inventory")[0][1]
					item = @item_data.get_item_by_id(item_id)
					if item[0][7] == 1 && item[0][16] == "all" && item[0][5] <= @player.level || item[0][7] == 1 && item[0][16] == @player.p_class && item[0][5] <= @player.level
						slot = item[0][4]
						equipped = @player.get_gear_detail_by_slot(slot)
						if equipped.length.to_i != 0 && equipped[0][2] != 0
							e_id = equipped[0][2]
							e_name = @item_data.get_item_by_id(e_id)[0][2]
							e_bonus = equipped[0][3]
							@player.add_to_inv(e_id, e_name, 1)
							case slot
								when "weapon"
									bonus = item[0][10]
									@player.damage -= e_bonus
									@player.damage += bonus
								when "armor"
									bonus = item[0][11]
									@player.armor -= e_bonus
									@player.armor += bonus
								when "ring"
									bonus = item[0][9]
									@player.max_hp -= e_bonus
									@player.max_hp += bonus
								when "bracer"
									bonus = item[0][19]
									@player.max_sp -= e_bonus
									@player.max_sp += bonus
								else
							end
							@player.equip_gear(slot, item[0][0], bonus)
							@player.remove_from_inv(id,"equip",0,0,0,0)
						else
							case slot
								when "weapon"
									bonus = item[0][10]
									@player.damage += bonus
								when "armor"
									bonus = item[0][11]
									@player.armor += bonus
								when "ring"
									bonus = item[0][9]
									@player.max_hp += bonus
								when "bracer"
									bonus = item[0][19]
									@player.max_sp += bonus
								else
							end
							@player.equip_first_gear(slot, item[0][0], bonus)
							@player.remove_from_inv(id,"equip",0,0,0,0)
						end
					else
						puts "This item is not equipable"
					end
					inv_loop
				when "consume"
					print "Type a Slot number to consume item(s)"
					id = gets.chomp.strip
					item_id = @player.get_data_from_slot(id,"inventory")[0][1]
					item = @item_data.get_item_by_id(item_id)
					if item[0][12] == 1 && item[0][5] <= @player.level
						@player.remove_from_inv(id,"consume",item[0][13],item[0][14],item[0][20],0)
					else
						puts "This item is not consumable"
					end
					inv_loop
				when "equip"
					puts "NOT YET!!"
					inv_loop
				else
					puts "Invalid Command - type help for more commands"
					inv_loop
				end
		end
		
		##
		## STORAGE COMMANDS
		def storage_command(action)
			loc_data = @world.location_detail(@player.locale)
			case action
				when "close", "exit", "leave"
					@storage_running = false
					system "clear" or system "cls"
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
					game_loop
				when "help", "h"
					@game_data.view_help_by_state("storage")
					storage_loop
				when "deposit", "d"
					@player.show_inventory
					print "Type a Slot number to deposit item(s) "
					id = gets.chomp.strip
					@player.remove_from_inv(id,"deposit",0,0,0,0) 
					storage_loop
				when "withdraw", "w"
					@player.show_storage
					print "Type a Slot number to withdraw item(s) "
					id = gets.chomp.strip
					@player.remove_from_storage(id,"withdraw")
					storage_loop
				when "inspect"
					print "Type a slot number to inspect the item in it"
					id = gets.chomp.strip
					item_id = @player.get_data_from_slot(id,"storage")[0][1]
					puts " " 
					puts " "
					@item_data.gear_show_by_id(item_id)
					puts " " 
					puts " "
				else
					puts "Invalid Command - type help for more commands"
					storage_loop
				end
		end
		
		##
		## GATHER COMMANDS
		def gather_command(action)
			loc_data = @world.location_detail(@player.locale)
			case action
				when "leave", "exit"
					@game_gather = false
					@node = nil
					system "clear" or system "cls"
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
					game_loop
				when "help", "h"
					@game_data.view_help_by_state("gather")
					gathering_loop
				when "gather", "harvest", "mine", "chop", "g"
					if @node.gather_times == 0
						@game_gather = false
						@node = nil
						system "clear" or system "cls"
						puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
						game_loop
					else
						@node.gather_times -= 1
						loot_table = @item_data.get_loot_items(@node.loot_name)
						loot_count = loot_table.length.to_i 
						if loot_count != 0
							if rand(100) >= 1 
								drop = rand(loot_count)-1
								drop_item = @item_data.get_item_by_db_name(loot_table[drop][2])
								drop_q = loot_table[drop][3]
								r_drop = rand(drop_q)
								if r_drop != 0
									@player.add_to_inv(drop_item[0][0], drop_item[0][2], r_drop)
									check_quest(drop_item[0][1], r_drop)
									
									achieve = @player.get_achievements_by_type(@player.locale, "gather")
									if achieve.length == 0
										@player.add_to_achieve("gather", @player.locale, loc_data[0][2],"location", r_drop)
									else
										@player.update_achieve_count_by_id(achieve[0][0], r_drop)
									end
									
									achieve2 = @player.get_achievements_by_type(drop_item[0][1], "gather")
									if achieve2.length == 0
										@player.add_to_achieve("gather",drop_item[0][1],drop_item[0][2],"material", r_drop)
									else
										@player.update_achieve_count_by_id(achieve2[0][0], r_drop)
									end
									
									
								else
									puts "You gather, finding nothing of value."
									sleep 0.5
								end
							else
								puts "You gather, finding nothing of value."
								sleep 0.5
							end
							#gathering_loop
						end
						if @node.gather_times == 0
							puts "There is nothing left to gather"
							sleep 1
							@game_gather = false
							@node = nil
							system "clear" or system "cls"
							puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
							game_loop
						end
						gathering_loop
					end
						
				else
					puts "Invalid Command - type help for more commands"
					gathering_loop
				end
		end
		
		##
		## MERCHANT COMMANDS
		
		def merchant_command(action)
			loc_data = @world.location_detail(@player.locale)
			case action
				when "leave", "exit", "close"
					@game_merchant = false
					system "clear" or system "cls"
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
					game_loop
				when "help", "h"
					@game_data.view_help_by_state("merchant")
					merchant_loop
				when "buy", "b"
					@item_data.show_for_sale(@player.level,@tod)
					print "Type a Item ID number to buy item(s) "
					id = gets.chomp.strip.to_i
					begin
						item = @item_data.get_item_by_id(id)[0]
					rescue
						puts "Invalid input" 
						sleep 1
						merchant_loop
					end
					puts ""
					print "How #{item[2]}'s would you like to buy? "
					amount = gets.chomp.strip.to_i
					if amount == "x"
						merchant_loop
					end
					b_gold = item[6]*amount
					b_silver = item[15]*amount
					if b_silver > 100
						gold = b_gold+(b_silver/100)
						silver = b_silver%100
					else
						gold = b_gold
						silver = b_silver
					end
					if silver > @player.silver && (gold+1) <= @player.gold
						@player.gold -= 1
						@player.silver +=100
						@player.add_to_inv(id, item[2], amount)
						@player.spend_money(gold,silver)
					elsif silver <= @player.silver && gold <= @player.gold
						@player.add_to_inv(id, item[2], amount)
						@player.spend_money(gold,silver)
					else
						puts "You do not have enough money."
						puts "Your Money: #{@player.gold}g #{@player.silver}s"
						puts "Cost: #{gold}g #{silver}s"
					end					
					merchant_loop
				when "sell", "s"
					show_full_inv_data
					puts " "
					print "Type a Slot number to sell item(s) "
					id = gets.chomp.strip
					item_id = @player.get_data_from_slot(id,"inventory")[0][1]
					value = @item_data.get_item_by_id(item_id)
					gvalue = value[0][6]
					svalue = value[0][15]
					@player.remove_from_inv(id,"sell",0,svalue.to_int,0,0)
					merchant_loop
				else
					puts "Invalid Command - type help for more commands"
					merchant_loop
				end
					
		end
		
		##
		## Quest board COMMANDS
		
		def quest_board_command(action)
			loc_data = @world.location_detail(@player.locale)
			case action
				when "leave", "exit", "close"
					@quest_board = false
					system "clear" or system "cls"
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
					game_loop
				when "help", "h"
					@game_data.view_help_by_state("merchant")
					quest_board_loop
				when "take", "claim", "add", "a", "c"
					puts "Type a Quest ID to claim a quest "
					id = gets.chomp.strip
					q = @quest_data.get_quest_by_id(id)[0]
					@player.add_quest(q[1],q[2],q[3],q[4],q[5],q[6],q[7],q[8],q[9],0,"A")
					puts ""
					puts "Quest, #{q[2]} accepted."
					sleep 1
					quest_board_loop
				else
					puts "Invalid Command - type help for more commands"
					quest_board_loop
			end
		end	
		
		
		##
		## NPC COMMANDS
		def npc_command(action)
			loc_data = @world.location_detail(@player.locale)
			case action
				when "leave", "exit", "close"
					@npc = nil
					@npc_running = false
					system "clear" or system "cls"
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
					game_loop
				when "help", "h"
					@game_data.view_help_by_state("npc")
					npc_loop
				when "talk", "t"
					talk = @npc.talk
					if talk[0] != "none"
						q = @quest_data.load_quest_data(talk[0])[0]
						@player.add_quest(q[1],q[2],q[3],q[4],q[5],q[6],q[7],q[8],q[9],0,"A")
						puts ""
						puts "Quest, #{q[2]} accepted."
						sleep 2
					end
					if talk[1] != "none"
						begin
							p_npc = @player.get_npcs(talk[1])
							if talk[1] == p_npc[0][1]
								puts ""
							end
						rescue
							@player.add_npc(@npc.db_name,@npc.name,@npc.repeat)
						end
					end
					@npc = nil
					@npc_running = false
					game_loop
				else
					puts "Invalid Command - type help for more commands"
					npc_loop
			end		
		end
		
		def craft_command(action)
			loc_data = @world.location_detail(@player.locale)
			case action
				when "leave", "exit", "close"
					@craft_table = false
					system "clear" or system "cls"
					puts "You are in the #{loc_data[0][3]} of #{loc_data[0][2]}"
					game_loop
				when "help", "h"
					@game_data.view_help_by_state("crafting")
					craft_loop("main")
				when "0","main","m"
					display_craft_table("main")
				when "1","refine","r"
					display_craft_table("refine")
				when "2","consumable","c"
					display_craft_table("consumable")
				when "3","weapons","w"
					display_craft_table("weapons")
				when "4","armor","a"
					display_craft_table("armor")
				when "5","jewelry","j"
					display_craft_table("jewelry")
				else
					puts "Invalid Command - type help for more commands"
					craft_loop("main")
			end
		end
		
		def display_craft_table(menu)
			case menu
				when "main"
					puts "CRAFTING TABLE"
					puts ""
					puts "Type the number of a crafting type below"
					puts ""
					puts "\t 1. Refine"
					puts "\t 2. Consumables"
					puts "\t 3. Weapons"
					puts "\t 4. Armor"
					puts "\t 5. Jewelry"
					puts ""
				when "refine"
					puts "CRAFTING TABLE - Material Refinement"
					puts ""
					puts ""
					recipes = @item_data.get_recipe_by_type("refine")
					show_recipes(recipes)
					print "Type the number of the item you wish to craft? (0 to exit) "
					mat_id = gets.chomp.strip.to_i
					if mat_id != 0
						craft_item(mat_id)
					else 
						craft_loop("main")
					end
					puts ""
					puts "Would like to refine something else? (y/n)  " 
					answer = gets.chomp.strip
					craft_loop("refine") if answer == "y"
					craft_loop("main") if answer != "y"
					
				when "consumable"
					puts "CRAFTING TABLE - Consumable Items"
					puts ""
					puts ""
					recipes = @item_data.get_recipe_by_type("consumable")
					show_recipes(recipes)
					print "Type the number of the item you wish to craft? (0 to exit) "
					mat_id = gets.chomp.strip.to_i
					if mat_id != 0
						craft_item(mat_id)
					else 
						craft_loop("main")
					end
					puts ""
					puts "Would like to craft something else? (y/n)  " 
					answer = gets.chomp.strip
					craft_loop("consumable") if answer == "y"
					craft_loop("main") if answer != "y"
				
				when "weapons"
					puts "CRAFTING TABLE - Weapons"
					puts ""
					puts ""
					recipes = @item_data.get_recipe_by_type("weapon")
					show_recipes(recipes)
					print "Type the number of the item you wish to craft? (0 to exit) "
					mat_id = gets.chomp.strip.to_i
					if mat_id != 0
						craft_item(mat_id)
					else 
						craft_loop("main")
					end
					puts ""
					puts "Would like to craft something else? (y/n)  " 
					answer = gets.chomp.strip
					craft_loop("weapon") if answer == "y"
					craft_loop("main") if answer != "y"
				when "armor"
					puts "CRAFTING TABLE - Armor"
					puts ""
					puts ""
					recipes = @item_data.get_recipe_by_type("armor")
					show_recipes(recipes)
					print "Type the number of the item you wish to craft? (0 to exit) "
					mat_id = gets.chomp.strip.to_i
					if mat_id != 0
						craft_item(mat_id)
					else 
						craft_loop("main")
					end
					puts ""
					puts "Would like to craft something else? (y/n)  " 
					answer = gets.chomp.strip
					craft_loop("armor") if answer == "y"
					craft_loop("main") if answer != "y"
				when "jewelry"
					puts "CRAFTING TABLE - Jewelry"
					puts ""
					puts ""
					recipes = @item_data.get_recipe_by_type("jewelry")
					show_recipes(recipes)
					print "Type the number of the item you wish to craft? (0 to exit) "
					mat_id = gets.chomp.strip.to_i
					if mat_id != 0
						craft_item(mat_id)
					else 
						craft_loop("main")
					end
					puts ""
					puts "Would like to craft something else? (y/n)  " 
					answer = gets.chomp.strip
					craft_loop("jewelry") if answer == "y"
					craft_loop("main") if answer != "y"
				else
					craft_loop("main")
			end
		end
	
		def show_recipes(recipes)
			recipes.each do |id, dbn,rn,ttm,mo,moq,mt,mtq,mth,mthq,type|
				item = @item_data.get_item_by_db_name(dbn)
				mat1 = @item_data.get_item_name_by_db_name(mo)[0][0] if mo != "none"
				mat2 = @item_data.get_item_name_by_db_name(mt)[0][0] if mt != "none"
				mat3 = @item_data.get_item_name_by_db_name(mth)[0][0] if mth != "none"
				puts "Recipe: #{id}   #{rn}"
				puts "\t #{item[0][3]}"
				print "Materials:   #{mat1}(#{moq})"
				print "    #{mat2}(#{mtq})" if mt != "none"
				print "    #{mat3}(#{mthq})" if mth != "none"
				puts ""
				puts "-"*50
				puts ""
			end
		end
		
		
		def craft_item(recipe_id)
			to_remove = []
			item = @item_data.get_recipe_by_id(recipe_id)[0]
			mat1 = @item_data.get_item_by_db_name(item[4])[0]
			p_mat1 = @player.get_inv_item_by_item_id(mat1[0])
			if p_mat1.length.to_i == 0 
				puts "Not enough #{mat1[2]}"
				sleep 2
				craft_loop("main")
			elsif p_mat1[0][3] < item[5]
				puts "Not enough #{mat1[2]}"
				sleep 2
				craft_loop("main")
			else
				to_remove.push([p_mat1[0][0],item[5]])
			end
			if item[6] != "none"    
				mat2 = @item_data.get_item_by_db_name(item[6])[0]
				p_mat2 = @player.get_inv_item_by_item_id(mat2[0])
				if p_mat2.length.to_i == 0 
					puts "Not enough #{mat2[2]}"
					sleep 2
					craft_loop("main")
				elsif p_mat2[0][3] < item[7]
					puts "Not enough #{mat2[2]}"
					sleep 2
					craft_loop("main")
				else
					to_remove.push([p_mat2[0][0],item[7]])
				end
			end
			if item[8] != "none" 
				mat3 = @item_data.get_item_by_db_name(item[8])[0]
				p_mat3 = @player.get_inv_item_by_item_id(mat3[0])
				if p_mat3.length.to_i == 0 
					puts "Not enough #{mat3[2]}"
					sleep 2
					craft_loop("main")
				elsif p_mat3[0][3] < item[9]
					puts "Not enough #{mat3[2]}"
					sleep 2
					craft_loop("main")
				else
					to_remove.push([p_mat3[0][0],item[9]])
				end
			end 
			to_remove.each do |id,qty|
				@player.remove_from_inv(id,"craft",0,0,0,qty)
			end
			item_id = @item_data.get_item_by_db_name(item[1])[0][0]
			@player.add_to_inv(item_id, item[2].to_s, 1) #### for some reason the item is not adding to inv
			puts ""
			puts ""
		
		end
		
		
		##
		## SHOW FULL INVENTORY
		def show_full_inv_data
			inv = @player.get_all_inv
			if inv.length == 0
				puts "Your inventory is empty"
			else
				puts " "
				print "-"*20
				print " INVENTORY "
				print "-"*20
				puts " "
				puts " "
				inv.each do |w,x,y,z|
					i_data = @item_data.get_item_by_id(x)[0]
					b_gold = i_data[6]*z
					b_silver = i_data[15]*z 
					if b_silver > 100
						gold = b_gold+(b_silver/100)
						silver = b_silver%100
					else
						gold = b_gold
						silver = b_silver
					end
					puts "  Slot #{w}: #{y} (#{z})\t Total Value: #{gold}g, #{silver}s"
				end
				puts " "
				puts "-"*51
				puts " "
			end	
		end
		
		## Show detailed storage
		def show_full_storage_data
			store = @player.get_all_storage
			if store.length == 0
				puts "Your storage is empty"
			else
				puts " "
				print "-"*20
				print " STORAGE "
				print "-"*20
				puts " "
				puts " "
				store.each do |w,x,y,z|
					s_data = @item_data.get_item_by_id(x)[0]
					puts "  Slot #{w}: #{y} (#{z})\t Total Value: #{s_data[6]*z}g, #{s_data[15]*z}s"
				end
				puts " "
				puts "-"*51
				puts " "
			end	
		end
		
		def show_portal
			ports = @player.get_ports
			print "-"*20
			print "ZONE PORTAL\n"
			ports.each do |id,dbn,zn,o,p|
				puts ""
				puts "Location ID: #{id}    #{zn}"
				puts ""
				puts "-"*50
			end
			puts ""
			puts ""
			print "Choose a location ID to port to "
			choice = gets.chomp.strip
			if choice == "x"
				game_loop
			else
				port = @player.get_port_by_id(choice.to_i)
				puts "!DBUG   game.rb:1349  port #{port}"
				sleep 2
				begin
					if port[0][3] == 1 && port[0][4] == 1
						@player.locale = port[0][1]
						system "clear" or system "cls"
						puts "Porting to #{port[0][2]}.."
						sleep 1
						@player.save_stats
						game_loop
					else
						puts "Zone not available"
						sleep 2
						game_loop 
						#run_command("portal")
					end
				rescue
					puts "Invalid selection"
					sleep 2
					game_loop
					#run_command("portal")
				end
			end
		end
		
		
		
		## ATTACK && SKILLS
		##
		def skill_dmg(id)
			skill = @player.player_skill_by_id(id)
			dmg = 0
			skill.each do |id,dbn,n,d,sp,dd,pd,mhd,ap|
				dmg += (pd*@player.damage)+@player.damage if pd != 0.0
				dmg += dd if dd != 0
				dmg += mhd*@monster.max_hp if mhd != 0.0
				@player.sp -= sp
				puts "You used #{n} against the #{@monster.name}"
			end
			return dmg
		end
		
		def attack(dmg,ap,type)
			loc_data = @world.location_detail(@player.locale)
			if ap == 0
				mod_dmg = dmg - (@monster.armor/3.0)
			else
				mod_dmg = dmg
			end
			mod_dmg = 0.0 if mod_dmg < 0.0 
			puts "You attack the #{@monster.name}" if type == "base"
			sleep 0.2
			puts "You deal #{mod_dmg.round(2)} to #{@monster.name}"
			sleep 0.7
			if @monster.take_dmg(mod_dmg) == 0
				puts "You have killed the #{@monster.name}"
				puts " "
				check_quest(@monster.d_name, 1)
				achieve = @player.get_achievements_by_type(@player.locale, "kill")
				if achieve.length == 0
					@player.add_to_achieve("kill", @player.locale, loc_data[0][2],"location", 1)
				else
					@player.update_achieve_count_by_id(achieve[0][0], 1)
				end
				achieve2 = @player.get_achievements_by_type(@monster.d_name, "kill")
				if achieve2.length == 0
					@player.add_to_achieve("kill", @monster.d_name, @monster.name,"monster", 1)
				else
					@player.update_achieve_count_by_id(achieve2[0][0], 1)
				end
				@player.add_exp(@monster.exp)
				g = @monster.gold
				s = @monster.silver
				mrg = rand(g).to_i
				mrs = rand(s).to_i
				if mrg > 0 || mrs > 0
					@player.gain_money(mrg,mrs)
				end
				#### 
				loot_table = @item_data.get_loot_items(@monster.d_name)
				loot_count = loot_table.length.to_i 
				if loot_count != 0
					if rand(100) >= 1 
						drop = rand(loot_count)-1
						drop_item = @item_data.get_item_by_db_name(loot_table[drop][2])
						drop_q = loot_table[drop][3]
						r_drop = rand(drop_q)
						if r_drop != 0
							@player.add_to_inv(drop_item[0][0], drop_item[0][2], r_drop)
							check_quest(drop_item[0][1], r_drop)
						else
							puts "You search the the dead #{@monster.name}, finding nothing of value."
						end
					else
						puts "You search the the dead #{@monster.name}, finding nothing of value."
					end
				end
				
				####
				@monster = nil
				@game_battle = false
			
				game_loop
			else
				sleep 0.2
				puts "#{@monster.name} attacks you"
				sleep 0.2
				playerdmg = @monster.attack - (@player.armor/2.0)
				playerdmg = 0.0 if playerdmg < 0.0
				if @player.take_dmg(playerdmg) == 0
					@game_battle = false
					@monster = nil
					@player.death
					game_loop
				else
					puts "You have taken #{playerdmg.round(2)} damage."
					puts "HP: #{@player.hp}/#{@player.max_hp}"
					sleep 0.7
					battle_loop
				end
			end
		end
		
		
		def show_quests
			system "clear" or system "cls"
			print "-"*20
			print " Active Quests "
			print "-"*20
			puts ""
			quests = @player.get_quests
			quests.each do |i,dbn,n,d,kgg,kgn,exp,sr,gr,loot,kgc,qs|
				if loot != "none"
					item = @item_data.get_loot_items(dbn)[0][2]
					item_name = @item_data.get_item_name_by_db_name(item)[0][0]
				end
				puts " "
				puts "  #{n}"
				puts "\t #{d}"
				puts "\t EXP: #{exp} \t Money: #{gr}g, #{sr}s"
				puts "\t Item: #{item_name.to_s}" if loot != "none"
				puts "-"*55
			end
		end
		
		##CHECK AND UPDATE QUESTS
		def check_quest(drop_item, amount)
			q_data = @player.active_quest_by_kgname(drop_item,"A")
			if q_data.length !=0
				q_data.each do | array |
					to_set = amount + array[10].to_i
					@player.update_kgcount(array[1], to_set) 
					puts "Quest progress updated"
					end
				new_data = @player.active_quest_by_kgname(drop_item,"A")
				new_data.each do | arr |
					if arr[10].to_i >= arr[4].to_i
						@player.update_qstatus(arr[1],"C")
						complete_quest(arr[1])
					end
				end
			end
		end
		
		def complete_quest(quest_name)
			completed = @player.quest_by_quest_name(quest_name)[0]
			puts "Quest #{completed[2]} Completed"
			@player.add_exp(completed[6])
			@player.gain_money(completed[8],completed[7])
			loot_table = @item_data.get_loot_items(completed[1])
			loot_count = loot_table.length.to_i
			if loot_count != 0
				drop = rand(loot_count)-1
				drop_item = @item_data.get_item_by_db_name(loot_table[drop][2])
				drop_q = loot_table[drop][3]
				@player.add_to_inv(drop_item[0][0], drop_item[0][2], drop_q)
			end
		end
		
		def display_open_quests
			#system "clear" or system "cls"
			q_count = 0
			open_jobs = @quest_data.get_quest_loc(@player.locale)
			open_jobs.each do |id,dbn,n,d,kgg,kgn,exp,sr,gr,loot,lvl,loc,tod|
			p_quest = @player.quest_by_quest_name(dbn)
				if p_quest.length == 0 && lvl <= @player.level
					if tod == @tod || tod == 2
						q_count +=1
						puts "Quest ID: #{id}"
						puts "\t'#{n}'"
						puts "\t#{d}"
						puts "\t\tRewards:  #{gr}g #{sr}s "
						puts "\t\tExperience:  #{exp}"
						if loot != "none"
							loot = @item_data.get_loot_items(dbn)
							quantity = loot[0][3]
							item_name = @item_data.get_item_name_by_db_name(loot[0][2])[0][0]
							puts "\t\tItem:  #{item_name}(#{quantity})"
						end
					end
				end
			end
			if q_count == 0
				puts "Im sorry there are no quests available at this time."
				puts "Try again tommorow, or at a a higher level."
			end
		end
		
		
		#create Monster
		def create_monster(monster_name)
			ma = @monster_data.monster_load_data_by_name(monster_name)[0]
			if @player.level > ma[4]
				#[ db_name, name, descrip, level, hp, max_hp, damage, armor, boss, exp, silver, gold]
				mod = @player.level - ma[4]
				@monster = Monster.new(ma[1], ma[2], ma[3], ma[4]+mod, ma[5]+mod, ma[6]+mod, ma[7]+mod, ma[8]+mod, ma[9], ma[10], ma[11], ma[12])
			else 
				@monster = Monster.new(ma[1], ma[2], ma[3], ma[4], ma[5], ma[6], ma[7], ma[8], ma[9], ma[10], ma[11], ma[12])
			end
		end
		
		#create Node
		def create_node(node_name)
			n = @node_data.load_node_data(node_name)[0]
			@node = Node.new(n[1], n[2], n[3], n[4], n[5])
		end
		
		#create NPC
		def create_npc(npc_name) #[db_name, name, prof, repeat, tod, quest, descrip]
			npc = @npc_data.npc_load_data(npc_name)[0]
			talk = @npc_data.npc_load_dialog(npc_name)[0]
			
			begin
				p_quest = @player.quest_by_quest_name(npc[6]) 
				if p_quest[0][1] == npc[6]
					@npc = Npc.new(npc[1],npc[2],npc[3],npc[4],npc[5],"none",npc[7],"none","none","none","taken")
				end
			rescue
				@npc = Npc.new(npc[1],npc[2],npc[3],npc[4],npc[5],npc[6],npc[7],talk[2],talk[3],talk[4],"open")
			end
		end
		
		
	end 

end
