require 'spec_helper'
require 'silly'

RSpec.describe 'Silly', '#sum' do
  it 'sums a and b' do
    silly = Silly.new
    expect(silly.make_sum(3,4)).to eq 7
  end
end
