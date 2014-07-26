require 'cell'

describe 'cell' do

	let(:cell) 							{ Cell.new                				}
	let(:ship)							{ double :ship, :attack! => nil		}
	let(:occupied_cell)     { cell.occupy_with(ship)			    }

	it 'should not be occupied when created' do
		expect(cell).not_to be_occupied
	end

	it 'can be occupied by a ship' do
		cell.occupy_with(:ship)
		expect(cell).to be_occupied 
		expect(cell.occupier).to eq(:ship)
	end

	it 'hits the occupier when the cell is hit' do 
		expect(cell.occupier).to receive(:attack!)
		cell.attack!
	end 

	it 'can register miss' do
		expect(cell.attack!).to be_an_instance_of Miss
	end

	it 'can register hit' do
		expect(occupied_cell.attack!).to be_an_instance_of Hit
	end

	it 'returns a HIT message' do
		expect(occupied_cell.message).to eq "HIT"
	end

	it 'return a MISS message' do
		expect(cell.message).to eq "MISS"
	end

	it 'should display ~ if occupied by water' do
		expect(cell.display(false)).to eq('~')
	end

	it 'should display @ if occupied by a ship' do
		expect(occupied_cell.display(false)).to eq('@') 
	end

	it 'should be able to display own ships' do
		expect(occupied_cell.display_own).to eq('@')
	end

	it 'should not be able to display opponent ships' do
		expect(occupied_cell.display_opponent).to eq('-') 
	end

	it 'should only display - on cells if option to hide ships is selected' do
		expect(cell.display(true)).to eq('-')
		expect(occupied_cell.display(true)).to eq('-')
	end

end