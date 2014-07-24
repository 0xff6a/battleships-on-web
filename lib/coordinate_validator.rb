module CoordinateValidator

	def generate_coordinates(first, last)
		first_letter,first_number = letter(first), number(first)
		last_letter,last_number = letter(last), number(last)
		return fill_column(first_number, last_number, first_letter) if same_letters?(first_letter, last_letter)
		fill_row(first_letter, last_letter, first_number)
	end

	def fill_column(first_number, last_number, first_letter)
		(first_number..last_number).to_a.map{ |number| (first_letter + number.to_s).to_sym}
	end

	def fill_row(first_letter, last_letter, first_number)
		(first_letter..last_letter).to_a.map{ |letter| (letter + first_number.to_s).to_sym }
	end

	def same_letters?(first_letter, last_letter)
		first_letter == last_letter
	end

	def valid_coordinates_for?(ship, grid, coordinates)
		return false unless on_grid?(coordinates)
		return false unless all_coordinates_vacant?(grid, coordinates)
		return false unless have_shared_row_or_column?(coordinates)
		return false unless correct_number_of?(coordinates, ship)
		true
	end

	def on_grid?(coordinates)
		coordinates.all? do |coordinate| 
			valid_coordinate?(coordinate)
		end
	end

	def valid_coordinate?(coordinate)
		number(coordinate).between?(1,10) && letter(coordinate).between?('a', 'j')
	end

	def correct_number_of?(coordinates, ship)
		coordinates.count == ship.shield_level
	end

	def have_shared_row_or_column?(coordinates)
		shared_row?(coordinates) or shared_column?(coordinates)
	end

	def shared_column?(coordinates)
		coordinates.all?{ |coordinate| letter(coordinate) == letter(coordinates.first) }
	end

	def shared_row?(coordinates)
		coordinates.all?{ |coordinate| number(coordinate) == number(coordinates.first) }
	end

	def all_coordinates_vacant?(grid, coordinates)
		coordinates.all?{ |coordinate| vacant?(grid, coordinate) }
	end

	def vacant?(grid, coordinate)
		grid.cell(coordinate).occupied? == false
	end

	def letter(coordinate)
		coordinate[0]
	end

	def number(coordinate)
		coordinate[1..2].to_i
	end

end