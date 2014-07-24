require './lib/attacked_cell'

class Hit < AttackedCell

	def display(arg=nil)
		"X"
	end

	def display_own
		display
	end

	def display_opponent
		display
	end

end