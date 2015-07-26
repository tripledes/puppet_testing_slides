// START BLOCK1 OMIT
require 'spec_helper_acceptance'

describe 'silly2' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        # Write here all puppet code needed
        # for silly2 module to work
        class { '::silly2': }
      EOS
    end
    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true)
    expect(apply_manifest(pp, :catch_changes => true).exit_code).to be_zero
  end
  ...
  // END BLOCK1 OMIT
  // START BLOCK2 OMIT
  ...
  describe package('silly2') do
    it do
      should be_installed
    end
  end
  describe file('/etc/silly2.conf') do
    it do
      should be_file
      should be_owned_by 'silly2'
    end
    its(:content) do
      should match /bind_address=127\.0\.0\.1\nport=666\n/
    end
  end
  describe service('silly2') do
    it do
      should be_enabled
      should be_running
    end
  end
end
// END BLOCK2 OMIT
