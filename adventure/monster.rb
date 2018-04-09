module RubyAdventure
	class Monster
		attr_accessor :display_monster, :name, :descrip, :level, :hp, :max_hp, :damage, :armor, :boss, :exp, :d_name, :gold, :silver
		
		def initialize(db_name, name, descrip, level, hp, max_hp, damage, armor, boss, exp, silver, gold)
			@d_name = db_name
			@name = name
			@descrip = descrip
			@level = level 
			@hp = hp
			@max_hp = max_hp 
			@damage = damage
			@armor = armor
			@boss = boss
			@exp = exp
			@silver = silver
			@gold = gold
		end
		
		def attack
			base_dmg = @damage/2
			boss_mod = @damage*0.2
			if @boss == 1
				return rand(base_dmg..@damage)+boss_mod
			else
				return rand(base_dmg..@damage)
			end
		end
		
		def take_dmg(dmg)
			@hp -= dmg
			if @hp <= 0 
				return 0
			else 
				return 1
			end 
		end
		
		def display_monster
			puts "You see a #{@name.capitalize}"
			puts "Level:  #{@level}"
			puts "HP (Hit Points): \t#{@hp}/#{@max_hp}"
		end
		
		
	end
	
end
