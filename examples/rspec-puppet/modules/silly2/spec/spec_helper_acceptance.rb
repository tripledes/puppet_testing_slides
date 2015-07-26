require 'beaker-rspec'
hosts.each do |host|
  on host, "mkdir -p #{host['distmoduledir']}"
end
RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  # Readable test descriptions
  c.formatter = :documentation
  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(:source => proj_root, :module_name => 'silly2')
    hosts.each do |host|
      # Prerequisites
      on host, puppet('module','install','puppetlabs-stdlib','--version','3.2.0'), {
        :acceptable_exit_codes => [0,1] }
      on host, shell('apt-get update')
    end
  end
end
