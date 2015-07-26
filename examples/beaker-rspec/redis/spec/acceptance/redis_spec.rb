require 'spec_helper_acceptance'

describe 'redis' do
  describe 'running puppet code' do
    it 'should work without errors' do
      pp = <<-EOS
      class { 'redis':
        redis_bind_address => $::ipaddress_eth0,
      }
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_changes => true).exit_code).to be_zero
    end
  end

  describe package('redis') do
    it do
      should be_installed.with_version('2.8.4')
    end
  end

  describe file('/etc/redis/redis.conf') do
    it do
      should be_file
    end
    its(:content) do
      should match /bind #{:ipaddress}/
    end
  end

  describe service('redis-server') do
    it do
      should be_enabled
      should be_running
    end
  end
end
