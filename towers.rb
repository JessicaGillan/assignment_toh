class TowersOfHanoi

	def initialize(num_disks = 3)
		@disks = num_disks		
	end

	def full_stack
		return (1..@disks).to_a.reverse
	end

	def play
		loop do
			@stacks = [ full_stack, [], [] ]	

			puts "---------------------------------------------------"
			puts "Welcome to Towers of Hanoi!"
			puts "Rebuild the stack on another rod to win."
			puts "Rules:"
			puts "1. You may only move one disk at a time"
			puts "2. You can only move the top disk of a stack"
			puts "3. No disk can be placed on top of a smaller disk"
			puts "---------------------------------------------------"
			puts

			until victory?
				render
				source, destination = get_input
				update_game(source, destination)
			end

			render
			puts "You WON!!!"

			break unless play_again?
		end 
	end

	def render

		@disks.times do |i|
			@stacks.length.times do |j|

				if @stacks[j][ @disks - i - 1 ].nil?
					print " ".center(11)
				else
					print ('#' * @stacks[j][ @disks - i - 1 ]).center(11)
				end

			end
			puts
		end
 		
 		@stacks.length.times do
 			print ('-' * @disks).center(11)
 		end
 		puts
	end

	def get_input
		loop do 
			puts "Enter stack to move from and to separated by a comma (eg 1,3) or 'q' to quit: "
			print "> "

			input = gets.chomp.strip.split(',')
			exit if input[0] == 'q'

			return input[0].to_i, input[1].to_i if valid?(input[0],input[1]) 
		end		
	end

	def valid?(source, destination)
		source_stack = source.to_i
		dest_stack = destination.to_i

		return true if valid_source?(source_stack) && valid_destination?(dest_stack) && top_disk_smaller?(source_stack, dest_stack) 
			
		puts "Invalid input."
		return false
	end

	def valid_source?(source)
		if (1..3).include? source
			puts "valid_source: #{!@stacks[ source-1 ].empty?}"
			return !@stacks[ source-1 ].empty?
		end

		puts "valid_source: false"
		return false
	end

	def valid_destination?(destination)
		puts "valid_destination: #{(1..3).include? destination}"
		return (1..3).include? destination
	end

	def top_disk_smaller?(source, destination)
		puts "top_disk_smaller: #{@stacks[ destination-1 ].empty? || @stacks[ destination-1 ][-1] > @stacks[ source-1 ][-1] }"
		return @stacks[ destination-1 ].empty? || @stacks[ destination-1 ][-1] > @stacks[ source-1 ][-1] 
	end

	def update_game(source, destination)
		disk = @stacks[ source-1 ].pop
		@stacks[ destination-1 ].push(disk)		
	end

	def victory?
		return true if @stacks[1] == full_stack|| @stacks[2] == full_stack
		return false
	end

	def play_again?
		print "Wanna play again? (y/n): "
		choice = gets.strip.downcase

		case choice
		when 'y' then return true
		when 'n' then exit
		else
			puts "Invalid entry, exiting the game."
			return false
		end
	end
end

game = TowersOfHanoi.new(5)

game.play