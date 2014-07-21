require './lib/cell'

class Grid

	DEFAULT_SIZE = 10

	attr_reader :size
	attr_accessor :cells

	def initialize(options = {})
		@size = options.fetch(:size, DEFAULT_SIZE)
		@cells = create_cells
	end

	#Context: cells in the grid

	def create_cells
		Array.new(size) { Array.new(size) { Cell.new } }
	end

	def cell(grid_reference)
		x, y = grid_reference_to_index(grid_reference)
		cells[x][y]
	end

	def attack_cell(grid_reference)
		x, y = grid_reference_to_index(grid_reference)
		cells[x][y] = cells[x][y].attack!
	end

	def cell_count
		@cells.flatten.count
	end

	#Context: ships in the grid

	def ships
		@ships ||= []
	end

	def add_ship(ship)
		ships << ship
	end

	def count_sunken_ships
		ships.select(&:sunk?).count
	end

end

def grid_reference_to_index(grid_reference)
	y = to_number(grid_reference[0]).to_i
	x = grid_reference[1..2].to_i - 1
	[x, y]
end	

def to_number(letter)
	('a'..'z').to_a.index(letter)
end



