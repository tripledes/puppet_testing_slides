require 'beaker-rspec'

hosts.each do |host|
  on host, "mkdir -p #{host['distmoduledir']}"
end

SUPPORTED_PLATFORMS = ['trusty','precise']

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(:source => proj_root, :module_name => 'redis')
    hosts.each do |host|
      on host, shell('touch /etc/puppet/hiera.yaml')
    end
  end
end
