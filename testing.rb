require_relative 'pivorak'
# require_relative 'db_data'



puts "Welcome to LockiStrike bus service!\n"
puts "To make some action use /[command name]\n"
puts "To see list of command use /commands"


def start_working
    puts "Do you want to log in( '/log in' ) in or registrate( '/registrate' )"

end



active_user = User.new
active_user.log_in('Vlad', "1234")
# active_user.show_bus_list
# number = gets.chomp
# position = gets.chomp
# active_user.buy_ticket(number, position)
# number = gets.chomp
# position = gets.chomp
# active_user.buy_ticket(number, position)
active_user.show_bought_tickets

# puts "registration\n"
# begin
# puts "name: "
# name = gets.chomp
# end while(not active_user.free_login?(name))
# puts "password: "
# password = gets.chomp
# active_user.registration(name, password)
# active_user.log_in(name, '2')
# command = ""
# begin
    

# end where 

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

# db.show_bus_list



# arr.each do |el|
#     puts el
# end
