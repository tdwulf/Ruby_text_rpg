
module RubyAdventure
	class Player
		attr_accessor :display_character, :p_name, :p_class, :locale, :gold, :exp, :hp, :max_hp, :damage, :armor, :gear, :level, :weapon, :ring, :bracer, :inv, :silver, :sp, :max_sp
		
		def initialize(pname, pclass, new)
			## Worn Gear
			@weapon = []#[0,0] #[item_id, dmg_mod]
			@gear = []#[0,0] #[item_id, armor_mod]
			@ring = []#[0,0] #[item_id, hp_mod]
			@bracer = []#[0,0] #[item_id, sp_mod]
			
			## Stats
			@p_name = pname
			@p_class = pclass
			@locale = "new_harbor"
			@exp = 0
			@level = 0
			@gold = 0
			@hp = 11
			@max_hp = 11
			@damage = 2
			@armor = 2 
			@silver = 30
			@sp = 5
			@max_sp = 5

			@inv = []
			
			@player_data = PlayerData.new(pname,new)
			
			load_stats(@p_name, @p_class, @locale, @exp, @level, @gold, @hp, @max_hp, @damage, @armor, @silver, @sp, @max_sp)
			load_db_gear
		end
		
		def get_ports
			return @player_data.get_port_zones
		end
		
		def get_port_by_id(id)
			return @player_data.get_zone_by_id(id)
		end
		
		def rest(time)
			wait_time = time.to_i
			system "clear" or system "cls"
			puts "You make a fire and lay down to rest"
			print "..zzz"
			sleep wait_time
			print "..zzzZZ.."
			sleep wait_time
			print ".zzz.."
			sleep wait_time
			puts ""
			new_hp = (@max_hp.to_i/10.0)*time.to_i
			new_sp = (@max_sp.to_i/10.0)*time.to_i
			add_hp_sp(new_hp.to_i,new_sp.to_i)
			puts "You awake feeling refreshed"
		end
		
		def add_hp_sp(hp,sp)
			if @hp + hp >= @max_hp
				@hp = @max_hp
			else
				@hp += hp
			end
			if @sp + sp >= @max_sp
				@sp = @max_sp
			else
				@sp += sp
			end
			save_stats
		end
		
		def god
			@gold = 9999
			@max_hp = 9999
			@max_sp = 9999
			@damage = 9999
			@armor = 9999			
		end
		
		def gain_money(gold,silver)
			if gold > 0 && silver > 0
				@silver += silver
				@gold += gold
				puts "You gain #{silver} silver and #{gold} gold"
				if @silver > 100
					@gold += @silver/100
					@silver = @silver%100
				end
			elsif silver > 0
				@silver += silver
				puts "You gain #{silver} silver"
				if @silver > 100
					@gold += @silver/100
					@silver = @silver%100
				end
			elsif gold > 0
				puts "You gain #{gold} gold"
				@gold += gold
			else
				puts "There may be a hole in your wallet"
			end
			save_stats
		end
		
		def spend_money(gold,silver)
			if gold > 0 && silver > 0
				@silver -= silver
				@gold -= gold
				puts "You spend #{silver} silver and #{gold} gold"
			elsif silver > 0
				@silver -= silver
				puts "You spend #{silver} silver"
			elsif gold > 0
				@gold -= gold
				puts "You spend #{gold} gold"
			else
				puts "Was that free??"
			end
			save_stats
		end
		
		def get_npcs(db_name)
			@player_data.get_player_npcs_by_name(db_name)
		end
		
		def add_npc(db_name, name, repeat)
			@player_data.add_player_npcs(db_name, name, repeat)
		end
		
		def get_gear_by_slot(slot)
			@player_data.show_gear(slot)	
		end
		
		def get_gear_detail_by_slot(slot)
			@player_data.show_gear_detail(slot)	
		end
		
		def equip_gear(slot,item_id, bonus)
			@player_data.update_worn_gear(slot, item_id, bonus)
			load_db_gear
			save_stats
		end
		
		def equip_first_gear(slot,item_id, bonus)
			#@player_data.wear_first_gear(slot,item_id,bonus)
			@player_data.update_worn_gear(slot, item_id, bonus)
			load_db_gear
			save_stats
		end
			
		## check if zone opened
		def get_zone_opened(db_name)
			return @player_data.show_zone(db_name)[0][3]
		end
		
		
		##quest queries
		def active_quest_by_kgname(drop_item, q_status)
			return @player_data.active_quest_by_kgname(drop_item, q_status)
		end
		
		def update_kgcount(quest_name, to_set) 
			@player_data.update_kgcount(quest_name, to_set) 
		end
		
		def update_qstatus(quest_name, q_status)
			@player_data.update_qstatus(quest_name, q_status)
		end
		
		def quest_by_quest_name(quest_name)
			return @player_data.quest_by_quest_name(quest_name)
		end
		
		def get_quests
			return @player_data.show_active_quests
		end
		
		def all_player_quests
			return @player_data.show_all_quests
		end
		
		## ALL SKILLS
		def all_skill_by_db_name(db_name)
			return @player_data.get_all_skills_by_db_name(db_name)
		end
		
		## PLAYER SKILLS
		def add_to_player_skills(dbn,n,d,sp,dd,pd,mhd,ap)
			@player_data.add_to_player_skills(dbn,n,d,sp,dd,pd,mhd,ap)
		end
		
		def player_skill_by_db_name(db_name)
			return @player_data.get_player_skill_by_db_name(db_name)
		end
		
		def player_skill_by_id(id)
			return @player_data.get_player_skill_by_id(id)
		end
		
		def show_player_skills
			system "clear" or system "cls"
			puts ""
			print "-"*20
			print "PLAYER SKILLS\n" if @class != "mage"
			print "PLAYER SPELLS\n" if @class == "mage"
			puts ""
			skills = @player_data.get_player_skills
			if skills.length != 0
				skills.each do |id,dbn,n,d,sp,dd,pd,mhd,ap|
					puts ""
					puts "#{n.upcase}  (sp: #{sp})"
					#puts "\t#{d}"
					puts "Deals #{pd*100}% more damage" if pd !=0.0
					puts "Deals #{dd} damage" if dd != 0
					puts "Deals damage equal to #{mhd*100}% of monsters health" if mhd != 0.0
					puts "\tIgnores monster armor" if ap != 0
					puts ""
					puts "-"*40
					puts ""
				end
			else
				puts "You have no skills"
			end
			
		end
		
		
		def add_exp(exp_gain)
			puts "You gained #{exp_gain} experience"
			@exp += exp_gain
			level_up(1) if @exp >=250 && @level < 1
			level_up(2) if @exp >=500 && @level < 2
			level_up(3) if @exp >=1000 && @level < 3
			level_up(4) if @exp >=2000 && @level < 4
			level_up(5) if @exp >=4000 && @level < 5
			level_up(6) if @exp >=8000 && @level < 6
			level_up(7) if @exp >=16000 && @level < 7
			level_up(8) if @exp >=32000 && @level < 8
			level_up(9) if @exp >=70000 && @level < 9
			level_up(10) if @exp >=140000 && @level < 10
			save_stats
		end
		
		def level_up(num) ## may want to take a look at some additional calc for stats per level
			@level = num
			@max_hp +=3
			@max_sp +=2
			@hp = @max_hp
			@sp = @max_sp
			@damage +=1
			@armor +=1
			puts " "*4
			puts "You have leveled up!!"
			puts " "
			puts "\t You are now level #{@level}"
			puts " "*4
			sleep 3
			level_skills(num)
			save_stats
		end
		
		def level_skills(level)
			p_class = @player.class
			case level
				when 1
					skill_add("focused_force_I") 
				when 2
					case p_class
						when "warrior"
							skill_add("bone_crusher")
						when "rogue"
							skill_add("backstab")
						when "mage"
							skill_add("magic_surge") 
					end
				when 3
					update_skill("focused_force_II","focused_force_I")
				when 4
					case p_class
						when "warrior"
							skill_add("lacerate") 
						when "rogue"
							skill_add("glass_dagger")
						when "mage"
							skill_add("fire_ball") 
					end
				when 5
					update_skill("focused_force_III","focused_force_II")
				when 6
					case p_class
						when "warrior"
							skill_add("doom_blade") 
						when "rogue"
							skill_add("dancing_knives")
						when "mage"
							skill_add("magid_missle") 
					end
				when 7
					update_skill("focused_force_IV","focused_force_III")
				when 8
					case p_class
						when "warrior"
							skill_add("final_blow") 
						when "rogue"
							skill_add("poison_blades")
						when "mage"
							skill_add("doom_orb") 
					end
				when 9
					update_skill("focused_force_V","focused_force_IV")
				#when 10  
				else
					puts ""
				
			end
		end
		
		def update_skill(db_name,old_dbn)
			skill = @player_data.get_all_skills_by_db_name(db_name)
			skill.each do |id,dbn,n,d,sp,dd,pd,mhd,ap,sc|
				@player_data.update_player_skill(dbn,n,d,sp,dd,pd,mhd,ap,old_dbn)
				puts "#{n} added to skills"
			end
		end
		
		
		def skill_add(db_name)
			skill = @player_data.get_all_skills_by_db_name(db_name)
			skill.each do |id,dbn,n,d,sp,dd,pd,mhd,ap,sc|
				@player_data.add_to_player_skills(dbn,n,d,sp,dd,pd,mhd,ap)
				puts "#{n} added to skills"
			end
		end
		
		
		
		
		def add_quest(dbn,n,d,kgg,kgn,exp,sr,gr,loot,kgc,qs)
			@player_data.add_quest(dbn,n,d,kgg,kgn,exp,sr,gr,loot,kgc,qs)
		end
		
		def take_dmg(dmg)
			@hp -= dmg
			if @hp <= 0 
				return 0
			else 
				return 1
			end
		end
		
		
		def show_inventory
			inv = @player_data.show_inventory
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
					puts "Slot #{w}: #{y} \tQuantity: #{z}"
				end
				puts " "
				puts "-"*51
				puts " "
			end	
		end
		
		def get_data_from_slot(slot,place)
			case place 
				when "inventory"
					return @player_data.show_inventory_by_id(slot)
				when "storage"
					return @player_data.show_storage_by_id(slot)
				else
					puts "Error getting data from inv/storage slot"
				end
		end
		
		##
		## INVENTORY
		##
	
		def add_to_inv(item_id, item_name, quantity)
			begin
				exists = @player_data.show_inventory_by_item_id(item_id)
			rescue
				exists = []
			end
			if exists.length == 0
				puts "You receive #{quantity} #{item_name}"
				@player_data.add_to_inv(item_id, item_name, quantity)
			elsif exists[0][1] == item_id
				puts "You receive #{quantity} #{item_name}"
				to_add = quantity + exists[0][3]
				@player_data.update_quantity_in_inv(item_id,to_add)
			else
				puts "You receive #{quantity} #{item_name}"
				@player_data.add_to_inv(item_id, item_name, quantity)
			end
			inv = @player_data.get_inv_items
			@player_data.save_player_inv(inv)
				
		end
		
		def remove_from_inv(id,task,gh_value,se_value,sp_value,qty)
			inv_slot = @player_data.show_inventory_by_id(id)
			in_inv = inv_slot[0][3]
			item_id = inv_slot[0][1]
			if inv_slot[0][3] >= 1
				if task == "equip"
					num = 1
				elsif task == "craft"
					num = qty
				elsif inv_slot[0][3] == 1
					num = 1
				else
					puts "You have #{inv_slot[0][3]} #{inv_slot[0][2]}'s"
					print "How many would you like to #{task}? "
					num = gets.chomp.strip.to_i
				end
				if num == inv_slot[0][3]
					puts "#{num} #{inv_slot[0][2]} removed from inventory"
					case task 
						when "deposit"
							to_add = get_data_from_slot(id,"inventory")[0]
							add_to_storage(to_add[1],to_add[2],num)
							@player_data.delete_from_inv(id)
						when "sell"
							b_gold = num*gh_value
							b_silver = num*se_value
							if b_silver > 100
								gold = b_gold+(b_silver/100)
								silver = b_silver%100
							else
								gold = b_gold
								silver = b_silver
							end
							
							gain_money(gold,silver)
							@player_data.delete_from_inv(id)
						when "equip"
							@player_data.delete_from_inv(id)
							save_gear
						when "consume"
							hp = num*gh_value
							exp = num*se_value
							sp = num*sp_value
							add_hp_sp(hp,sp)
							@exp += exp
							@player_data.delete_from_inv(id)
							save_stats
							puts "HP (Hit Points): \t#{@hp.round(2)}/#{@max_hp}" 
							puts "SP (Skill Points): \t#{@sp}/#{@max_sp}" if @p_class != "mage"
							puts "SP (Spell Points): \t#{@sp}/#{@max_sp}" if @p_class == "mage"
							puts "Damage:          \t#{@damage}"
							puts "Armor:           \t#{@armor}"
							sleep 1
						else
							@player_data.delete_from_inv(id)
					end
				elsif num > inv_slot[0][3]
					puts "You cannot #{task} more than you have"
				else
					new_q = (in_inv-num)
					puts "#{num} #{inv_slot[0][2]} removed from inventory"
					@player_data.update_quantity_in_inv(item_id,new_q)
					case task
						when "deposit"
							to_add = get_data_from_slot(id,"inventory")[0]
							add_to_storage(to_add[1],to_add[2],num)
						when "sell"
							b_gold = num*gh_value
							b_silver = num*se_value
							if b_silver > 100
								gold = b_gold+(b_silver/100)
								silver = b_silver%100
							else
								gold = b_gold
								silver = b_silver
							end
							gain_money(gold,silver)
							@player_data.update_quantity_in_inv(item_id,new_q)
						when "consume"
							hp = num*gh_value
							exp = num*se_value
							sp = num*sp_value
							add_hp_sp(hp,sp)
							@exp += exp
							@player_data.update_quantity_in_inv(item_id,new_q)
							save_stats
							puts "HP (Hit Points): \t#{@hp.round(2)}/#{@max_hp}" 
							puts "SP (Skill Points): \t#{@sp}/#{@max_sp}" if @p_class != "mage"
							puts "SP (Spell Points): \t#{@sp}/#{@max_sp}" if @p_class == "mage"
							puts "Damage:          \t#{@damage}"
							puts "Armor:           \t#{@armor}"
							sleep 1
						else
					end
				end
			else
				puts "#{num} #{inv_slot[0][2]} removed from inventory"
				case task
					when "deposit"
						to_add = get_data_from_slot(id,"inventory")[0]
						add_to_storage(to_add[1],to_add[2],1)
						@player_data.delete_from_inv(id)
					when "sell"
						b_gold = num*gh_value
						b_silver = num*se_value
						if b_silver > 100
							gold = b_gold+(b_silver/100)
							silver = b_silver%100
						else
							gold = b_gold
							silver = b_silver
						end
						gain_money(gold,silver)
						@player_data.delete_from_inv(id)
					when "consume"
						hp = num*gh_value
						exp = num*se_value
						sp = num*sp_value
						add_hp_sp(hp,sp)
						@exp += exp
						@player_data.delete_from_inv(id)
						save_stats
						puts "HP (Hit Points): \t#{@hp.round(2)}/#{@max_hp}" 
						puts "SP (Skill Points): \t#{@sp}/#{@max_sp}" if @p_class != "mage"
						puts "SP (Spell Points): \t#{@sp}/#{@max_sp}" if @p_class == "mage"
						puts "Damage:          \t#{@damage}"
						puts "Armor:           \t#{@armor}"
						sleep 1
					else
						@player_data.delete_from_inv(id)
				end
			end
			inv = @player_data.get_inv_items
			@player_data.save_player_inv(inv)
			if task == "deposit"
				store = @player_data.get_storage_items
				@player_data.save_player_storage(store)
			end
			
		end
		
		##
		## STORAGE
		##
		
		def show_storage
			store = @player_data.show_storage
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
					puts "Slot #{w}: #{y} \tQuantity: #{z}"
				end
				puts " "
				puts "-"*51
				puts " "
			end	
		end
		
		def add_to_storage(item_id, item_name, quantity)
			begin
				exists = @player_data.show_storage_by_item_id(item_id)
			rescue
				exists = []
			end
			if exists.length == 0
				puts " #{quantity} #{item_name} added to storage"
				@player_data.add_to_storage(item_id, item_name, quantity)
			elsif exists[0][1] == item_id
				puts " #{quantity} #{item_name} added to storage"
				to_add = quantity + exists[0][3]
				@player_data.update_quantity_in_storage(item_id,to_add)
			else
				puts " #{quantity} #{item_name} added to storage"
				@player_data.add_to_storage(item_id, item_name, quantity)
			end
			store = @player_data.get_storage_items
			@player_data.save_player_storage(store)
				
		end
		
		def remove_from_storage(id,task)
			storage_slot = @player_data.show_storage_by_id(id)
			in_storage = storage_slot[0][3]
			item_id = storage_slot[0][1]
			if storage_slot[0][3] > 1
				puts "You have #{storage_slot[0][3]} #{storage_slot[0][2]}'s"
				print "How many would you like to #{task}? "
				num = gets.chomp.strip.to_i
				if num == storage_slot[0][3]
					puts "#{storage_slot[0][2]} #{task}ed from storage"
					if task == "withdraw"
						to_add = get_data_from_slot(id,"storage")[0]
						add_to_inv(to_add[1],to_add[2],num)
						@player_data.delete_from_storage(id)
					else
						@player_data.delete_from_storage(id)
					end
				else 
					new_q = (in_storage-num)
					puts "#{num} #{storage_slot[0][2]} #{task}ed from storage"
					@player_data.update_quantity_in_storage(item_id,new_q)
					if task == "withdraw"
						to_add = get_data_from_slot(id,"storage")[0]
						add_to_inv(to_add[1],to_add[2],num)
					end
				end
			else
				puts "#{storage_slot[0][2]} #{task}ed from storage"
				if task == "withdraw"
					to_add = get_data_from_slot(id,"storage")[0]
					add_to_inv(to_add[1],to_add[2],1)
					@player_data.delete_from_storage(id)
				else
					@player_data.delete_from_storage(id)
				end
			end
			store = @player_data.get_storage_items
			@player_data.save_player_storage(store)
			if task == "withdraw"
				inv = @player_data.get_inv_items
				@player_data.save_player_inv(inv)
			end
		end
		
		
		
		
		def display_character(place_name)
			puts " "
			puts "Name:  #{@p_name.capitalize} \t Class:  #{@p_class.capitalize}"
			puts "Level:  #{@level} \t Exp:  #{@exp}"
			puts " "
			puts "--"*20
			puts " "
			puts "Silver:     \t#{@silver}"
			puts "Gold:     \t#{@gold}"
			puts "Location: \t#{place_name}"
			puts " "
			puts "--"*20
			puts " "
			puts "HP (Hit Points): \t#{@hp.round(2)}/#{@max_hp}" 
			puts "SP (Skill Points): \t#{@sp}/#{@max_sp}" if @p_class != "mage"
			puts "SP (Spell Points): \t#{@sp}/#{@max_sp}" if @p_class == "mage"
			puts "Damage:          \t#{@damage}"
			puts "Armor:           \t#{@armor}"
			
		end
		
		
		def load_stats(p_name, p_class, locale, exp, level, gold, hp, max_hp, damage, armor, silver,sp, max_sp)
			pcheck = @player_data.stat_tbl_check(p_name)
			if pcheck.length == 0
				@player_data.add_player_stats(p_name, p_class, locale, exp, level, gold, hp, max_hp, damage, armor, silver,sp, max_sp)
			elsif pcheck[0][0] == p_name
				load_db_stats
			else
				puts "Something has gone terrible wrong"
				char_check
			end
			
		end
		
		def save_gear
			@player_data.update_worn_gear("weapon",@weapon[0],@weapon[1])
			@player_data.update_worn_gear("armor",@gear[0],@gear[1])
			@player_data.update_worn_gear("ring",@ring[0],@ring[1])
			@player_data.update_worn_gear("bracer",@bracer[0],@bracer[1])
		end
		
		def load_db_gear
			@weapon = @player_data.show_gear("weapon")[0]
			@gear = @player_data.show_gear("armor")[0]
			@ring = @player_data.show_gear("ring")[0]
			@bracer = @player_data.show_gear("bracer")[0]

			@gameloop
		end

		
		def load_db_stats
			playerhash = @player_data.pull_player_stats
			@p_name = playerhash[0][1]
			@p_class = playerhash[0][2]
			@locale = playerhash[0][3]
			@exp = playerhash[0][4]
			@level = playerhash[0][5]
			@gold = playerhash[0][6]
			@hp = playerhash[0][7]
			@max_hp = playerhash[0][8]
			@damage = playerhash[0][9]
			@armor = playerhash[0][10]
			@silver = playerhash[0][11]
			@sp = playerhash[0][12]
			@max_sp = playerhash[0][13]
			
			@gameloop
		end
		
		def death
			puts "You have died."
			sleep 0.2
			print "Resurecting."
			print ".."
			sleep 0.3
			print ".."
			sleep 0.3
			print ".."
			sleep 0.3
			@locale = "new_harbor"
			@hp = 1
			@exp -= @exp/10
			puts "You have been resurected in New Harbor, you should rest to regain health."
			save_stats
		end
		
		def get_all_inv
			return @player_data.show_inventory
		end
		
		def get_all_storage
			return @player_data.show_storage
		end
		
		def get_inv_item_by_item_id(item_id)
			return @player_data.show_inventory_by_item_id(item_id)
		end
		
		def save_stats
			@player_data.update_player_stats(@p_name, @p_class, @locale, @exp, @level, @gold, @hp, @max_hp, @damage, @armor, @silver, @sp, @max_sp)
		end
		
		#
		# ACHIEVEMENTS 
		
		def get_achievements_by_type(a_db_name, a_type)
			return @player_data.get_achievements_by_type(a_db_name, a_type)
		end
		
		def add_to_achieve(a_type, a_db_name, a_name, a_counted, quantity)
			@player_data.add_to_achieve(a_type, a_db_name, a_name, a_counted, quantity,0)
		end
		
		def update_achieve_count_by_id(a_db_name, quantity)
			@player_data.update_achieve_count_by_id(a_db_name, quantity)
		end
		
		def check_achievement_rank
			rank_list = @player_data.get_all_achievements
			rank_list.each do |id,a_type,a_db_name,a_name,a_counted, quantity, rank|
				case a_type
					when "walk"
						@player_data.update_rank_count_by_id(id, 1) if quantity > 100 && rank < 1
						@player_data.update_rank_count_by_id(id, 2) if quantity > 250 && rank < 2
						@player_data.update_rank_count_by_id(id, 3) if quantity > 550 && rank < 3
						@player_data.update_rank_count_by_id(id, 4) if quantity > 1000 && rank < 4
						@player_data.update_rank_count_by_id(id, 5) if quantity > 3000 && rank < 5
					when "kill"
						case a_counted
							when "location"
								@player_data.update_rank_count_by_id(id, 1) if quantity > 100 && rank < 1
								@player_data.update_rank_count_by_id(id, 2) if quantity > 250 && rank < 2
								@player_data.update_rank_count_by_id(id, 3) if quantity > 550 && rank < 3
								@player_data.update_rank_count_by_id(id, 4) if quantity > 1000 && rank < 4
								@player_data.update_rank_count_by_id(id, 5) if quantity > 3000 && rank < 5
							when "monster"
								@player_data.update_rank_count_by_id(id, 1) if quantity > 10 && rank < 1
								@player_data.update_rank_count_by_id(id, 2) if quantity > 25 && rank < 2
								@player_data.update_rank_count_by_id(id, 3) if quantity > 55 && rank < 3
								@player_data.update_rank_count_by_id(id, 4) if quantity > 100 && rank < 4
								@player_data.update_rank_count_by_id(id, 5) if quantity > 300 && rank < 5
						end
					when "gather"
						case a_counted
							when "location"
								@player_data.update_rank_count_by_id(id, 1) if quantity > 100 && rank < 1
								@player_data.update_rank_count_by_id(id, 2) if quantity > 250 && rank < 2
								@player_data.update_rank_count_by_id(id, 3) if quantity > 550 && rank < 3
								@player_data.update_rank_count_by_id(id, 4) if quantity > 1000 && rank < 4
								@player_data.update_rank_count_by_id(id, 5) if quantity > 3000 && rank < 5
							when "material"
								@player_data.update_rank_count_by_id(id, 1) if quantity > 50 && rank < 1
								@player_data.update_rank_count_by_id(id, 2) if quantity > 125 && rank < 2
								@player_data.update_rank_count_by_id(id, 3) if quantity > 225 && rank < 3
								@player_data.update_rank_count_by_id(id, 4) if quantity > 500 && rank < 4
								@player_data.update_rank_count_by_id(id, 5) if quantity > 1500 && rank < 5
						end
				end
			end
		end
		
		
		def show_map_achievements(place_name)
			check_achievement_rank
			achieves = @player_data.get_location_achievements
			system "clear" or system "cls"
			puts ""
			puts ""
			print "-"*20
			print "#{place_name.upcase}\n"
			puts ""
			print "-"*20
			print "ACHIEVEMENTS"
			puts ""
			puts ""
			achieves.each do |id,a_type,a_db_name,a_name,a_counted, quantity, rank|
				if a_db_name == @locale
					case a_type
						when "walk" 
							puts "\tWalks in current map (#{a_name}) #{quantity}"
								if rank > 0
									puts "\t  Rank: "+ "*"*rank
								else
									puts "\t  Rank: none"
								end
							puts ""
						when "kill"
							puts "\tKills in current map (#{a_name}) #{quantity}"
								if rank > 0
									puts "\t  Rank: "+ "*"*rank
								else
									puts "\t  Rank: none"
								end
							puts ""
						when "gather"
							puts "\tItems gathered in current map (#{a_name}) #{quantity}"
								if rank > 0
									puts "\t  Rank: "+ "*"*rank
								else
									puts "\t  Rank: none"
								end
							puts ""
						else
							puts "unknown achievement type"
					end
				end
			end
			puts "-"*50
		end
		
		
		def show_achievements(a_type,a_counted)
			system "clear" or system "cls"
			check_achievement_rank
			achieves = @player_data.get_achieve_by_type(a_type,a_counted)
				if a_type == "kill"
					puts ""
					print "-"*20
					print "KILLS ACHIEVEMENTS"
					print "-"*20
					puts ""
					achieves.each do |id,a_type,a_db_name,a_name,a_counted, quantity, rank|
						if a_counted == "location"
							puts ""
							puts "\tKills in #{a_name}: #{quantity}"
							if rank > 0
								print "\t  Rank: "+ "*"*rank
							else
								print "\t  Rank: none"
							end
							puts ""
						else
							puts ""
							puts "\t You have killed #{quantity}  #{a_name}'s"
							if rank > 0
								print "\t  Rank: "+ "*"*rank
							else
								print "\t  Rank: none"
							end
							puts ""
						end
					end
				elsif a_type == "gather"
					puts ""
					print "-"*20
					print "GATHERING ACHIEVEMENTS"
					print "-"*20
					puts ""
					achieves.each do |id,a_type,a_db_name,a_name,a_counted, quantity, rank|
						if a_counted == "location"
							puts ""
							puts "\tItems gathered in #{a_name}: #{quantity}"
							if rank > 0
								print "\t  Rank: "+ "*"*rank
							else
								print "\t  Rank: none"
							end
							puts ""
						else
							puts ""
							puts "\t You have gathered #{quantity}  #{a_name}'s"
							if rank > 0
								print "\t  Rank: "+ "*"*rank
							else
								print "\t  Rank: none"
							end
							puts ""
						end
					end	
				elsif a_type == "walk"
					puts ""
					print "-"*20
					print "EXPLORING ACHIEVEMENTS"
					print "-"*20
					puts ""
					achieves.each do |id,a_type,a_db_name,a_name,a_counted, quantity, rank|
						puts ""
						puts "\tWalks in #{a_name}: #{quantity}"
						if rank > 0
							puts "\t  Rank: "+ "*"*rank
						else
							puts "\t  Rank: none"
						end
						puts ""
					end
				else
					puts "no achieve type selected"
				end
				puts "-"*60
			end
		
		#
		
	end
	
end
