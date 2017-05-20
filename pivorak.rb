require 'mysql'

require_relative 'db_data'


# module BusList
# 		def  show_bus_list(start_place=nil, start_date=nil)
# 		query = "SELECT * FROM BusShedule "
# 		if start_place != nil and start_date != nil
# 			query += "WHERE start_place = '%s' AND start_date = '%s'" % [start_place, start_date]
# 		elsif start_place == nil and start_date != nil
# 			query += "WHERE start_date = '%s'" % start_date
# 		elsif start_place != nil and start_date == nil
# 			query += "WHERE start_place = '%s'" % start_place
# 		end
		
# 		bus_list = @connect.query(query)

# 		while bus = bus_list.fetch_hash do
# 			print_bus(bus)
# 		end
		
		
# 	end

# 	def print_bus(bus)
# 		printf "%-15s %-20s %-20s %-15s %-15s %-15s %-15s %-15s %s \n" % [bus['number'], bus['from_place'], bus['to_place'], \
# 													 bus['start_date'], bus['start_time'], bus['end_date'], \
# 													 bus['end_time'], bus['seats_count'], bus['avaliable_seats_count'] ]
# 	end
# end

module Common_func
	def free_login?(user_login)
		query = "SELECT login FROM Accounts WHERE login = '%s'" % user_login
		logins = @connect.query(query)
		if logins.fetch_row != nil
			puts 'Sorry this login is already exist'
			false
		else
			true
		end

	end
end


class User

	include Db_data
	include Common_func
	# include BusList
	def initialize()
		@connect = Mysql.new(host, user, password, database)
	end
	

	def log_in(user_name, user_password)
		query = "SELECT * FROM Accounts WHERE login='%s' AND password='%s'" % [user_name, user_password]
		acc_exist = @connect.query(query)
		if acc_exist.fetch_row != nil
			@login = user_name
			puts "Log in successful"
			true
		else
			puts "login or password is incorrect, try once more"
			false
		end
	end
	
	def registration(user_login, user_password)
		if free_login?(user_login)
			@connect.query("INSERT INTO Accounts(login, password, is_admin) VALUES('%s', '%s', false)" % [user_login, user_password])
			@login = user_login
			puts 'registration successful'
			true
		end
		
		false
	end
	

	def  show_bus_list(start_place=nil, start_date=nil)
		query = "SELECT * FROM BusShedule "
		if start_place != nil and start_date != nil
			query += "WHERE start_place = '%s' AND start_date = '%s'" % [start_place, start_date]
		elsif start_place == nil and start_date != nil
			query += "WHERE start_date = '%s'" % start_date
		elsif start_place != nil and start_date == nil
			query += "WHERE start_place = '%s'" % start_place
		end
		
		bus_list = @connect.query(query)

		while bus = bus_list.fetch_hash do
			print_bus(bus)
		end
			
	end

	def buy_ticket(number, position)
		# query = "SELECT avaliable_seats_count FROM BusShedule WHERE number = '%s'" % number
		# seats_count = @connect.query(query).fetch_hash['avaliable_seats_count']
		# if position.to_i < 1 || position.to_i > seats_count.to_i
		# 	puts "Incorrect seats number, try once more"
		# 	return
		# end

		query = "SELECT * FROM BusShedule WHERE number = '%s'" % number
		bus_result = @connect.query(query)
		bus = bus_result.fetch_hash
		if bus != nil
			if position.to_i > 0 && position.to_i <= bus['seats_count'].to_i
				if (bus['avaliable_seats_count'].to_i > 0)
					if free_position?(number, position)
						query = "INSERT INTO BoughtTickets(number, position, login) VALUES('%s', '%s', '%s')" % [number, position, @login]
						@connect.query(query)

						query = "UPDATE BusShedule SET avaliable_seats_count = '%s' WHERE number = '%s'" % [bus['avaliable_seats_count'].to_i - 1, number]
						@connect.query(query)
						puts "Ticket is successfuly bought"
						return true
					else
						return false
					end
				else
					puts "Sorry, all tickets for this bus already bought"
					return false
				end
			else
				puts "Incorrect seat number, try once more"
				return false
			end
		else
			puts "Sorry, bus with this number doesn't exist, try once more"
			return false
		end
	end

	def show_bought_tickets
		query = "SELECT * FROM BoughtTickets WHERE login = '%s'" % @login
		tickets = @connect.query(query)
		while ticket = tickets.fetch_hash do
			bus_query = "SELECT * FROM BusShedule WHERE number = '%s'" % ticket['number']
			bus = @connect.query(bus_query)
			print_bus(bus.fetch_hash)
			puts "Your seat: %s" % ticket['position']
		end
	end

	def show_seats_map(bus_number)
		query = "SELECT position FROM BoughtTickets WHERE number = '%s' " % bus_number
		seats = @connect.query(query)
		taken_seats = []
		while seat = seats.fetch_row do
			taken_seats = []
		end
	end



private
	def print_bus(bus)
		printf "%-15s %-20s %-20s %-15s %-15s %-15s %-15s %-15s %s \n" % [bus['number'], bus['from_place'], bus['to_place'], \
													 bus['start_date'], bus['start_time'], bus['end_date'], \
													 bus['end_time'], bus['seats_count'], bus['avaliable_seats_count'] ]
	end

	def free_position?(number, position)
		query = "SELECT position FROM BoughtTickets WHERE number = '%s'" % number
		bus_response = @connect.query(query)
		bus = bus_response.fetch_hash
		while bus != nil do
			if position.to_i == bus['position'].to_i
				puts "Sorry, this seat already taken"
				return false 
			end
			bus = bus_response.fetch_hash
		end
		true
	end


end




class Admin

	include Db_data
	# include BusList

	def initialize()
		@connect = Mysql.new(host, user, password, database)
	end

	def add_bus(from_place, 
		    to_place, 
		    start_date, 
		    start_time, 
		    end_date, 
		    end_time,
		    seats_count)
		
		number = random_number
		query = "INSERT INTO BusShedule(number, from_place, to_place, start_date, start_time, end_date, end_time, seats_count, avaliable_seats_count) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')" \
		% [number, from_place, to_place, start_date, start_time, end_date, end_time, seats_count, seats_count]
		@connect.query(query)
		
	end


	def random_number
		bus_numbers = @connect.query("SELECT number FROM BusShedule")
		busses = []
		while bus = bus_numbers.fetch_row do
			busses.push(bus)
		end

		begin
			is_repeat = false
			number = rand(10000)
			busses.each do |bus|
				if number == bus
					is_repeat = true
					break	
				end
			end
		end while(is_repeat)

		number
	end
		
end
