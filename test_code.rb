[
	["New Harbor", "You are in a sea side town that is a bustle of people.", "town"],
	["Northern Plains", "You look out on an expansive area with low rolling hills.", "wilds"]		
].each do |x,y,z|

puts x
puts y
puts z				
end
#@game_data_db.execute "insert into world_data values ( ?, ?, ? )", x,y,z
