require 'silly'

describe 'Silly', '#sum' do
  it 'sums a and b' do
    expect(Silly.new.make_sum(3,4)).to eq 7
  end
end
