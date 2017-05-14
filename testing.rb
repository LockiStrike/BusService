require_relative 'pivorak'
require_relative 'db_data'


db = Admin.new

#begin
#	puts "enter login to registrate: "
#	user_login = gets.chomp
#	while( not db.check_free_login(user_login))
#		user_login = gets.chomp
#	end
#
#	puts "enter password to registrate: "
#	user_password = gets.chomp
#	db.registration(user_login, user_password)
#	
#	puts "enter q to quit or other character to registrate once more"
#	quit = gets.chomp
#end while(quit != 'q')
# db.add_bus('Varshava', 'ksladfjaskldfjlsakdfjsadf', '25.08.2017', '15:40', '15.06.2017', '21:40', 200)
# db.add_bus('Lviv', 'Kiev', '15.06.2017', '10:40', '17.06.2017', '16:40', 10)

db.show_bus_list
