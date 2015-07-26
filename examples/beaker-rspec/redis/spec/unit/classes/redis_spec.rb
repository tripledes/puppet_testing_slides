describe 'redis', :type => :class do
  shared_examples 'common examples for installation' do
    it 'will define package redis-server' do
      should contain_package('redis-server').with_ensure('2.8.4')
    end

    it 'will define service redis-server, enabled and running' do
      should contain_service('redis-server').with({
        :ensure => 'running',
        :enable => true,
      })
    end
  end

  context 'default parameters' do
    let(:facts) do
      {
        :operatingsystem => 'Ubuntu'
      }
    end

    it_behaves_like 'common examples for installation'

    it 'will define file /etc/redis/redis.conf' do
      should contain_file('/etc/redis/redis.conf').with({
        :ensure  => 'file',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0640',
        :content => /daemonize yes.*port 6379.*bind 127\.0\.0\.1.*databases 16/m,
      }).that_requires('Package[redis-server]').that_notifies('Service[redis-server]')
    end
  end

  context 'modified parameters' do
    let(:facts) do
      {
        :operatingsystem => 'Ubuntu'
      }
    end

    let(:params) do
      {
        :redis_daemonize    => 'no',
        :redis_bind_address => '192.168.1.100',
        :redis_port         => 6378,
        :redis_databases    => 10,
      }
    end

    it_behaves_like 'common examples for installation'

    it 'will define file /etc/redis/redis.conf' do
      should contain_file('/etc/redis/redis.conf').with({
        :ensure  => 'file',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0640',
        :content => /daemonize no.*port 6378.*bind 192\.168\.1\.100.*databases 10/m,
      }).that_requires('Package[redis-server]')
    end
  end

  context 'not supported operating system' do
    let(:facts) do
      {
        :operatingsystem => 'Solaris'
      }
    end

    it 'will raise an error' do
      should_not compile.and_raise_error(/Solaris is not supported by redis/)
    end
  end

  context 'redis_ensure set to absent' do
    let(:facts) do
      {
        :operatingsystem => 'Ubuntu'
      }
    end

    let(:params) do
      {
        :redis_ensure => 'absent',
      }
    end

    it 'will define package redis-server with ensure absent' do
      should contain_package('redis-server').with_ensure('absent').that_requires('File[/etc/redis/redis.conf]')
    end

    it 'will define file /etc/redis/redis.conf with ensure absent' do
      should contain_file('/etc/redis/redis.conf').with_ensure('absent').that_requires('Service[redis-server]')
    end

    it 'will define service redis-server, stopped and disabled' do
      should contain_service('redis-server').with_ensure('stopped')
    end
  end
end
