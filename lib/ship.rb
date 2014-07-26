class Ship

	DEFAULT_SHIELD_LEVEL = 3

	attr_accessor	:shield_level

	def initialize(shield_level = DEFAULT_SHIELD_LEVEL)
		@shield_level = shield_level
		@sunk = false
	end

	def sunk?
	 	@sunk == true
	end

	def sink!
	 	@sunk = true
	 	self
	end

	def attack!
		@shield_level = [@shield_level - 1, 0].max
		return sink! if @shield_level == 0
		self
	end

	def message
		"Sunk #{self.class}!" if sunk?
	end

end

class AircraftCarrier < Ship
	def initialize
		super(5)
	end
end

class Battleship < Ship
	def initialize
		super(4)
	end
end

class Submarine < Ship
end

class Destroyer < Ship
end

class PatrolBoat < Ship
	def initialize
		super(2)
	end
end