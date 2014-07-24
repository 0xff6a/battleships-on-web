require 'attacked_cell'

describe AttackedCell do

let(:attacked_cell) {AttackedCell.new}

	it 'is immune to attacks' do 
		expect(attacked_cell.attack!).to be attacked_cell
	end

	it 'can tell the user it has been attacked' do
		expect(attacked_cell.message).to eq 'MISFIRE!'
	end

end