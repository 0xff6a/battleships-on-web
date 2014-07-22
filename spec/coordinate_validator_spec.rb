require 'coordinate_validator'

describe 'CoordinateValidator' do 

	class CoordinateHelper; include CoordinateValidator; end

	let(:helper)  	{ CoordinateHelper.new							}	
	let(:ship)			{ double :ship, :shield_level => 2	}
	let(:cell)			{ double :cell, :occupied? => false	}
	let(:grid) 			{ double :grid, :cell => cell				}

	it 'can generate a coordinate set from a start and end coordinate' do
		expect(helper.generate_coordinates("a1", "a3")).to eq [:a1, :a2, :a3]
		expect(helper.generate_coordinates("a1", "c1")).to eq [:a1, :b1, :c1]
	end

	it 'can check if coordinates are valid for a ship - number of coords' do
		expect(helper.valid_coordinates?(ship, grid, [:a1, :a2, :a3] )).to be false
	end

	it 'can check if coordinates are valid for a ship - same row or column' do
		expect(helper.valid_coordinates?(ship, grid,[:a1, :b2,] )).to be false
		expect(helper.valid_coordinates?(ship, grid,[:a1, :a2,] )).to be true
	end

	it 'can check if coordinates are valid for a ship - all cells vacant' do
		expect(helper).to receive(:all_coordinates_vacant?).and_return(false)
		expect(helper.valid_coordinates?(ship, grid, [:a1, :a2,] )).to be false
	end

	it 'should check if coordinates are valid - belong to grid' do
		expect(helper.on_grid?([:j11, :j12])).to be false
		expect(helper.on_grid?([:j8, :j9])).to be true
	end

end