module RubyAdventure
	class Node
		attr_accessor :display_node, :db_name, :name, :descrip, :gather_times, :loot_name
		
		def initialize(db_name, name, descrip, gather_times, loot_name)
			@db_name = db_name
			@name = name
			@decrip = descrip
			@gather_times = gather_times
			@loot_name = loot_name
		end
		
		
		def display_node
			puts "You see a #{@name.capitalize}"
			puts "\t #{@decrip}"
		end
		
		
	end
	
end
