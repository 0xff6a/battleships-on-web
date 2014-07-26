require_relative 'water'
require_relative 'attacked_cell'
require_relative 'hit'
require_relative 'miss'

class Cell 

	DEFAULT_REFERENCE = nil

	attr_accessor :occupier

	def initialize
		@occupier = Water.new 
	end

	def occupied?
		!@occupier.is_a?(Water)
	end

	def occupy_with(ship)
		@occupier = ship
		self
	end

	def message
		return "HIT" if occupied?
		"MISS"
	end

	def attack!
		@occupier.attack!
		return score_hit if occupied?
		score_miss
	end

	def score_hit
		Hit.new
	end

	def score_miss
		Miss.new
	end
	
	def display(hide_ships = true)
		return "-" if hide_ships
		return '@' if occupied? 
		'~'
	end

	def display_own
		display(false)
	end

	def display_opponent
		display(true)
	end	

end