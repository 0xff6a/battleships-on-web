require 'player'

	describe Player do 

	let(:player)  	{Player.new("Nelson")									}	
	let(:cell)			{ double :cell  											}
	let(:ship)			{ double :ship, :shield_level => 2		}
	
	context 'At start of game' do

		it "should have a grid when created" do 
			expect(player.grid.is_a?(Grid)).to be true
		end

		it 'has a name' do
			expect(player.name).to eq "Nelson"
		end

		it 'should have 5 ships' do
			expect(player.ships[0]).to be_an_instance_of AircraftCarrier
			expect(player.ships[1]).to be_an_instance_of Battleship
			expect(player.ships[2]).to be_an_instance_of Destroyer
			expect(player.ships[3]).to be_an_instance_of Submarine
			expect(player.ships[4]).to be_an_instance_of PatrolBoat
		end

		it 'should deploy a ship to a given set of grid coordinates' do
			expect(player.grid).to receive(:cell).and_return(cell).exactly(3).times
			expect(cell).to receive(:occupy_with).with(ship).exactly(3).times
			player.deploy_ship_to([:a1, :a2, :a3], ship) 
		end

	end

	context 'During the game' do

		it "should be able to shoot at opponent\'s board" do 
			other_grid  = Player.new("Zumwalt").grid
			expect(other_grid).to receive(:attack_cell).with('A1')
			player.shoot_at(other_grid, 'A1')
		end

		it 'should know how many sunken ships it has' do
			expect(player.count_sunken_ships).to eq 0
			player.ships[1].sink!
			expect(player.count_sunken_ships).to eq 1
		end

	end

end