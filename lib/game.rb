require_relative 'player'
require_relative 'coordinate_validator'

class Game

	attr_accessor :players, :status

	include CoordinateValidator

	def initialize
			@players = []
			@status = nil
	end

	def current_player
		players.first
	end

	def other_player
		players.last
	end

	def add(player)
		players << player
	end

	def player_count
		players.count
	end

	def start?
		player_count == 2
	end

	def end?
		other_player.grid.count_sunken_ships == 5 or current_player.grid.count_sunken_ships == 5 
	end

	def start_game
		@status = :started
	end

	def start_message
		"----START----"
	end

	def player1_prompt
		"Player 1 Start"
	end

	def player2_prompt
		"Player 2 Start"
	end

	def end_game_message
		"----GAME OVER----"
	end

	def change_turn
		@players[0], @players[1] = @players[1], @players[0]
	end

end
