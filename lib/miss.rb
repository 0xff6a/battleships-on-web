require './lib/attacked_cell'

class Miss < AttackedCell

	def display(arg = nil)
		"O"
	end

	def display_own
		display
	end

	def display_opponent
		display
	end

end