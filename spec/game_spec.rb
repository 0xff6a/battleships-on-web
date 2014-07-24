require 'game'

describe Game do

	let(:game) 		{ Game.new																																					}
	let(:player1) { double :player1, :name => "other", :grid => grid1, :count_sunken_ships => 5, 
									:deploy_ships => nil, :display_grid => nil																				}
	let(:player2)	{ double :player2, :name => "jeremy", :grid => grid2, :count_sunken_ships => 0			}
	let(:grid1)		{ double :grid1, :occupied_cell_count => 17																					}
	let(:grid2)		{ double :grid2, :occupied_cell_count => 17																					}

	it_should_behave_like 'a coordinate validator'

	context 'At the start of the game' do
	
		it 'should start with no players' do
			expect(game.players).to eq []
		end

		it 'can add players' do
			game.add(player1)
			game.add(player2)
			expect(game.players).to eq [player1, player2]
		end

		it 'can count the players' do
			expect(game.player_count).to eq 0
			game.add(player1)
			expect(game.player_count).to eq 1
		end

		it 'should know when it can start' do
			expect(game.start?).to be false
			game.add(player1)
			game.add(player2)
			expect(game.start?).to be true
		end

		it 'should know which is the current player' do
			expect(game.current_player).to be game.players[0]
		end

		it 'should know which is the other player' do
			expect(game.other_player).to be game.players[1]
		end
		
		it 'should have a status of nil initially' do
			expect(game.status).to be nil
		end

		it 'can start the game' do
			game.start_game
			expect(game.status).to be :started
		end

		it 'should return player by name' do
			game.add(player2)
			expect(game.player("jeremy")).to eq player2
		end

		it 'shoudl return an opponent name' do
			game.add(player1)
			game.add(player2)
			expect(game.opponent("jeremy")).to eq player1
		end

		it 'knows when all ships have been deployed' do
			game.add(player1)
			game.add(player2)
			expect(game.ships_deployed?).to be true
		end

	end

	context 'In round n' do 

		it 'can change turns' do
			player1 = game.current_player
			game.change_turn
			expect(game.other_player).to be player1
		end

		it 'knows when it can end' do
			game.add(player2)
			expect(game.end?).to be false
			game.add(player1)
			expect(game.end?).to be true
		end

	end

end
