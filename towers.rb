# !/usr/bin/ruby

# Play Tower of Hanoi
# Start with a stack of disks of varying size, stacked largest to smallest
# and move it to another postion (3 possible possitions) by moving one
# disk at a time, always grabbing the top disk, and never stacking a disk 
# on top of a disk smaller than it.

# Option to enter number of disks as script input, default is 3.

class TowersOfHanoi

	def initialize(num_disks)
		@disks = num_disks	
	end

	# Create the starting stack

	def full_stack
		return (1..@disks).to_a.reverse
	end

	# Main method

	def play
		loop do
			# Initialize the disks

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

	# Display the current state of disks

	def render

		# Display the disks from top to bottom, row by row
		@disks.times do |i|
			@stacks.length.times do |j|

				if @stacks[j][ @disks - i - 1 ].nil? # Empty position
					print " ".center(11)
				else
					print ('#' * @stacks[j][ @disks - i - 1 ]).center(11) # Print the disk, sized with a number of '#'s
				end

			end
			puts # Go to the next line for next row
		end
 		
 		# Print markers for each stack location
 		@stacks.length.times do
 			print ('-' * @disks).center(11)
 		end
 		puts

	end

	def get_input
		loop do 
			puts "Enter stack to move from and to separated by a comma (eg 1,3) or 'q' to quit: "
			print "> "

			input = gets.strip.split(',')
			exit if input[0] == 'q'

			return input[0].to_i, input[1].to_i if valid?(input[0],input[1]) 
		end		
	end

	def valid?(source, destination)
		source_stack = source.to_i
		dest_stack = destination.to_i		

		@errors = [] # Clear previous errors

		return true if valid_source?(source_stack) && valid_destination?(dest_stack) && top_disk_smaller?(source_stack, dest_stack) 

		print_errors

		return false
	end

	def print_errors
		puts
		puts "Invalid input!"

		@errors.each do |error|
			puts error
		end
		puts
	end

	def valid_source?(source)
		# Check if source stack is in range, if so, make sure it's not empty
		if (1..3).include? source
			return true if !@stacks[ source-1 ].empty? 
		end
		
		@errors << "Invalid source stack"
		return false
	end

	def valid_destination?(destination)
		return true if (1..3).include? destination

		@errors << "Invalid destination stack"
		return false
	end

	def top_disk_smaller?(source, destination)
		# Make sure destination stack is either empty or has a bigger disk then the disk to put on top of it.
		return true if @stacks[ destination-1 ].empty? || @stacks[ destination-1 ][-1] > @stacks[ source-1 ][-1] 

		@errors << "Cannot place disk on top of a smaller disk"
		return false
	end

	def update_game(source, destination)
		disk = @stacks[ source-1 ].pop
		@stacks[ destination-1 ].push(disk)		
	end

	def victory?
		return true if @stacks[1] == full_stack || @stacks[2] == full_stack
		return false
	end

	def play_again?
		print "Want to play again? (y/n): "
		choice = gets.strip.downcase

		case choice
		when 'y' then return true
		when 'n' then return false
		else
			puts "Invalid entry, exiting the game."
			return false
		end
	end
end

input = ARGV
disks = ARGV[0].to_i unless ARGV.empty?

game = TowersOfHanoi.new( disks ||= 3 )

game.play