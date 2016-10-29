# !/usr/bin/ruby

# Play Tower of Hanoi
# Start with a stack of disks of varying size, stacked largest to smallest
# and move it to another postion (3 possible possitions) by moving one
# disk at a time, always grabbing the top disk, and never stacking a disk 
# on top of a disk smaller than it.

# Option to enter number of disks as script input, default is 3.

class TowersOfHanoi
	QUIT_OPTIONS = ['q', 'quit', 'exit']

	def initialize(num_disks)
		@disks = num_disks	
	end

	# Return full stack of disks
	def full_stack
		return (1..@disks).to_a.reverse
	end

	# Main method
	def play
		loop do
			# Initialize the disks
			@stacks = [ full_stack, [], [] ]	

			print_welcome

			until victory?
				render
				source_input, destination_input = get_input
				make_move( source_input-1, destination_input-1 )
			end

			render
			puts "You WON!!!"

			break unless play_again?
		end 
	end

	def print_welcome
			puts "---------------------------------------------------"
			puts "Welcome to Towers of Hanoi!"
			puts "Rebuild the stack on another rod to win."
			puts "Rules:"
			puts "1. You may only move one disk at a time"
			puts "2. You can only move the top disk of a stack"
			puts "3. No disk can be placed on top of a smaller disk"
			puts "---------------------------------------------------"
			puts		
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
 		
 		# Print markers for each stack location, lengthened according to number of disks in game
 		@stacks.length.times do
 			print ('-' * @disks).center(11)
 		end
 		puts
	end

	# Only get input! Do not also check it. 
	def get_input
		loop do 
			puts "Enter stack to move from and to separated by a comma (eg 1,3) or 'q' to quit: "
			print "> "

			input = gets.strip.split(',')

			if QUIT_OPTIONS.include?(input.first)
				return input.first
			elsif valid?( input.map(&:to_i) ) 
				return input.map(&:to_i) # the '&:to_i' is taking the :to_i method, degrading to a block, and passing it to map
			else
				print_errors( input.map(&:to_i) )
			end
		end		
	end

	def valid?(input)
		return false unless valid_source?( input.first ) 
		return false unless valid_destination?( input.last ) 
		return false unless top_disk_smaller?( input.first, input.last ) 
		return true
	end

	def print_errors(input)
		puts
		puts "Invalid input!"
		puts "Invalid source stack" unless valid_source?( input.first )
		puts "Invalid destination stack" unless valid_destination?( input.last )
		# Don't try to access stack elements unless both are valid!
		puts "Cannot place disk on top of a smaller disk" if valid_source?( input.first ) && valid_destination?( input.last ) && !top_disk_smaller?( input.first, input.last )
		puts
	end

	# Check if source stack is in range, if so, make sure it's not empty
	def valid_source?(source)
		return false unless (1..3).include? source
		return !@stacks[ source-1 ].empty? 
	end

	# Check if destination stack is in range
	def valid_destination?(destination)
		return (1..3).include? destination
	end

	# Make sure destination stack is either empty or has a bigger disk then the disk to put on top of it.
	def top_disk_smaller?(source, destination)
		return true if @stacks[ destination-1 ].empty? 
		return @stacks[ destination-1 ][-1] > @stacks[ source-1 ][-1] 
	end

	def make_move(source_stack, destination_stack)
		@stacks[destination_stack].push( @stacks[source_stack].pop )		
	end

	# Check if second or third stack is a complete stack
	def victory?
		return @stacks[1] == full_stack || @stacks[2] == full_stack
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
ARGV.clear

game = TowersOfHanoi.new( disks ||= 3 )

game.play