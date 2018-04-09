module RubyAdventure
	class Npc
		attr_accessor :display_npc, :talk, :db_name, :name, :prof, :repeat, :tod, :quest, :descrip, :dialog, :q_status
		
		def initialize(db_name, name, prof, repeat, tod, quest, descrip, talk1,talk2,talk3,q_status)
			@db_name = db_name
			@name = name
			@prof = prof
			@repeat = repeat
			@tod = tod
			@quest = quest
			@descrip = descrip
			@dialog = [talk1,talk2,talk3]
			@q_status = q_status
			
		end
		
		
		def display_npc
			puts "You see #{@name.capitalize}"
			puts "\t #{@decrip}"
		end
		
		
		def talk
			@dialog.each do |x|
				if x != "none" && q_status == "open"
					puts x
					sleep 0.5
					#zz = gets.chomp.strip
				else
					puts "Nice to see you again. Thank You for your help"
				end
			end
			if @quest != "none"
				print "Will you help? "
				ans = gets.chomp.strip.downcase
				while ans != "y" && ans != "n"
					print "Please answer 'y' or 'n' "
					#print "Will you help? "
					ans = gets.chomp.strip.downcase
				end
				case ans
					when "y"
						puts "Thank you. Good Bye!"
						return [@quest,@db_name]
					when "n"
						puts "Come find me if you change your mind!"
						return ["none","none"]
				end
			end
			puts "Good Bye!"
			return ["none",@db_name]
		end
		
		#
		
	end
	
end

