require_relative 'pivorak'
# require_relative 'db_data'

user_commands = ["/log_in", "/registrate", "/bus_list", "/buy_ticket", "/bought_tickets", "/commands", "/exit"]
admin_commands = ["/log_in", "/registrate", "/add_bus", "/update_bus", "/remove_bus", "/bought_tickets", "/commands", "/exit"]
user = nil

def command?(input)
    if input == '/log_in' || input == "/registrate" || input == "/buy_ticket" || input == "/bought_tickets" || input == "/commands" || input == "/exit" \
        || input == "/add_bus" || input == "/update_bus" || input == "/remove_bus" || input == "/bought_tickets" || input == "/bus_list"
        return true
    else
        return false
    end
    # user_commands = ["/log_in", "/registrate", "/buy_list", "/buy_ticket", "/bought_tickets", "/commands", "/exit"]
    # admin_commands = ["/log_in", "/registrate", "/add_bus", "/update_bus", "/remove_bus", "/bought_tickets", "/commands", "/exit"]
    # return user_commands.include?(input) || admin_commands.include?(input)
end

def list_of_command
    puts "Commands where [optional argument] (required argument): \n\n"
    puts "For user: \n"
    puts "/log_in for log in as user"
    puts "/registrate for registrate as user"
    puts "/bus_list to see busses shedule"
    puts "/buy_ticket to buy avaliable ticket"
    puts "/bought_tickets to see all your bought tickets\n\n"
    puts "/commands to see all commands"
    puts "/log_out to log out from your account"
    puts "/exit to close program"
    puts "For admin: \n"
    puts "/log_in"
    puts "/registrate"
    puts "/add_bus"
    puts "update_bus"
    puts "/remove_bus"
    puts "/bought_tickets"
    puts "/commands to see all commands"
    puts "/log_out to log out from your account"
    puts "/exit to close program"
end

def log_in(user)
    begin
        puts "Enter your login: \n"
        name = gets.chomp
        puts "Enter your password: \n"
        pass = gets.chomp
    end while(not user.log_in(name, pass))
end

def registrate_user(user)
    begin    
        puts "Enter your login: \n"
        name = gets.chomp
        puts "Enter your password: \n"
        pass = gets.chomp
    end while(not user.registration(name, pass))

end

def registrate_admin(user)
    begin    
        puts "Enter your login: \n"
        name = gets.chomp
        puts "Enter your password: \n"
        pass = gets.chomp
        puts "enter secret key"
        key = gets.chomp
    end while(not user.registration(name, pass, key))
end


def user_buy_ticket(user)
    begin
        user.show_bus_list
        puts "Choose your bus by number"
        number = gets.chomp
        user.show_seats_map(number)
        puts "Choose your seats"
        position = gets.chomp
    end while( not user.buy_ticket(number, position) )
end

def admin_add_bus(user)
    puts "Enter start point of route"
    from_place = gets.chomp
    puts "Enter end point of route"
    to_place = gets.chomp
    puts "Enter start data of route as dd.mm.yyyy"
    start_data = gets.chomp
    puts "Enter start time of route as hh.mm (24 hours format)"
    start_time = gets.chomp
    puts "Enter end data of route as dd.mm.yyyy"
    end_data = gets.chomp
    puts "Enter end time of route as hh.mm (24 hours format)"
    end_time = gets.chomp
    puts "Enter seats count of bus"
    seats_count = gets.chomp
    user.add_bus(from_place, to_place, start_data, start_time, end_data, end_time, seats_count)
end

def admin_remove_bus(user)
    
    begin
        user.show_bus_list
        puts "Choose bus to remove"
        number = gets.chomp
    end while not user.remove_bus(number)

end

def admin_update_bus(user)
    begin
        user.show_bus_list
        puts "Choose bus to update"
        number = gets.chomp
    end while not user.update_bus(number)
end


def pre_working(user)
    flag = false
    begin
        puts "Do you want to log in( '/log_in' ) in or registrate( '/registrate' )"
        input = gets.chomp
        case input
        when '/log_in'
            log_in(user)
            flag = true
        when '/registrate'
            if user.class == User
                registrate_user(user)
            elsif user.class == Admin
                registrate_admin(user)
            end
            flag = true

        else
            puts "Incorrect input, try once more"
            flag = false
        end

    end while(not flag)
end

def start_working
    begin 
        puts "Are you user( 'u' ) or admin( 'a' )?\n"
        command = gets.chomp
        if command == 'u'
            user = User.new
            is_admin = false
            correct_command = true
        elsif command == 'a'
            user = Admin.new
            is_admin = true
            correct_command = true
        else
            puts "incorrect input try once more"
            correct_command = false
        end
    end while (not correct_command)

    pre_working(user)
    return user
end

def commands_parser(input, user)

    case input
    when '/log_in'
        puts "You can't log in when you are already loggen in"
    when '/registrate'
        puts "You can't registrate when you are already logged in"
    when '/bus_list'
        user.show_bus_list
    when '/buy_ticket'
        if user.class == Admin
            puts "You can't buy tickets as admin"
        elsif user.class == User
            user_buy_ticket(user)
        end
    when "/bought_tickets"
        if user.class == Admin
            puts "You can't buy tickets as admin"
        elsif user.class == User
            user.show_bought_tickets
        end
    when "/commands"
        list_of_command
    when "/add_bus"
        if user.class == Admin
            admin_add_bus(user)
        elsif user.class == User
            puts "You can't add bus as user"
        end
    when "/remove_bus"
        if user.class == Admin
            admin_remove_bus(user)
        elsif user.class == User
            puts "You can't remove bus as user"
        end       
    when "/update_bus" 
        if user.class == Admin
            admin_update_bus(user)
        elsif user.class == User
            puts "You can't update bus as user"
        end 
    when "/bought_tickets" 
        if user.class == Admin
            user.show_bus_list
            puts "Enter number of bus to see bought tickets"
            number = gets.chomp
            user.show_bought_tickets(number)
        elsif user.class == User
            puts "You can't see this info as user"
        end 
    end
end



is_admin = false

puts "Welcome to LockiStrike bus service!\n"
puts "To make some action use /[command name]\n"
puts "To see list of command use /commands\n"
puts "Be careful all data is case sensivity login, password as well\n"
puts "Also all commands write properly without excessive whitespaces\n"

user = start_working

begin
    puts "Enter the command...\n"
    input = gets.chomp
    if command?(input)
        commands_parser(input, user)
    elsif input == '/log_out'
        start_working
    else
        puts "Incorrect input, try once more"
    end

end while (input != '/exit')





# user = User.new


# admin = Admin.new
# admin.show_bought_tickets('5482')
# login = gets.chomp
# password = gets.chomp
# key = 'secret key to allow'
# admin.log_in(login, password)
# admin.show_bus_list
# number = gets.chomp
# admin.update_bus(number, "16:40", "23:40" )



# active_user = User.new
# active_user.log_in('Vlad', "1234")
# active_user.show_bus_list
# number = gets.chomp
# position = gets.chomp
# active_user.buy_ticket(number, position)
# number = gets.chomp
# position = gets.chomp
# active_user.buy_ticket(number, position)
# active_user.show_bought_tickets

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
