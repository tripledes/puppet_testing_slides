describe 'silly', :type => :class do
  it 'installs package redis-server' do
    should contain_package('redis-server')
  end
end
