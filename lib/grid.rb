require_relative 'cell'

class Grid

	DEFAULT_SIZE = 10

	attr_reader :size
	attr_accessor :cells

	def initialize()
		@size = DEFAULT_SIZE
		@cells = create_cells
	end

	def create_cells
		Array.new(size) { Array.new(size) { Cell.new } }
	end

	def cell(grid_reference)
		x, y = grid_reference_to_index(grid_reference)
		cells[x][y]
	end

	def attack_cell(grid_reference)
		x, y = grid_reference_to_index(grid_reference)
		result = cells[x][y].message
		cells[x][y] = cells[x][y].attack!
		result
	end

	def cell_count
		@cells.flatten.count
	end

	def occupied_cell_count
		@cells.flatten.select(&:occupied?).count
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



