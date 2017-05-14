require 'mysql'

require_relative 'db_data'

module BusList
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

	def print_bus(bus)
		printf "%-15s %-20s %-20s %-15s %-15s %-15s %-15s %-15s %s \n" % [bus['number'], bus['from_place'], bus['to_place'], \
													 bus['start_date'], bus['start_time'], bus['end_date'], \
													 bus['end_time'], bus['seats_count'], bus['avaliable_seats_count'] ]
	end
end

def free_login?(user_login)
	logins = @connect.query("SELECT login FROM UserDb where login = '%s'" % user_login)
	if logins.fetch_row != nil
		puts 'Sorry this login is already exist'
		false
	else
		true
	end

end


class User

	include BusList
	def initialize(user_login=nil)
		@connect = Mysql.new(host, user, password, database)
		@login = user_login
	end
	
	
	def registration(user_login, user_password)
		@connect.query("INSERT INTO UserDb(login, password) VALUES('%s', '%s')" % [user_login, user_password])
		puts 'registration successful'
	end
	

end


class Admin
	include BusList

	def initialize
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
