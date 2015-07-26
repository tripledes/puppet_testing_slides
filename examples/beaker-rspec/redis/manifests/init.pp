# == Class: redis
# Class redis manages redis and its configuration.
#
# === Parameters
#
# [*redis_daemonize*]
#  Whether redis will become a daemon or not.
#
# [*redis_bind_address*]
#  Address where redis will bind.
#
# [*redis_port*]
#  Port where redis will listen for requests.
#
# [*redis_databases*]
#  Maximum number of redis databases.
#
class redis (
  $redis_ensure       = $redis::params::ensure,
  $redis_daemonize    = $redis::params::daemonize,
  $redis_bind_address = $redis::params::bind_address,
  $redis_port         = $redis::params::port,
  $redis_databases    = $redis::params::databases
) inherits redis::params {

  case $redis_ensure {
    'present': {
      $pkg_ensure = '2.8.4'
      $file_ensure = file
      $service_ensure = running
      $service_enable = true
      Package['redis-server'] ->
      File['/etc/redis/redis.conf'] ~>
      Service['redis-server']
    }
    'absent': {
      $pkg_ensure = absent
      $file_ensure = absent
      $service_ensure = stopped
      $service_enable = false
      Service['redis-server'] ->
      File['/etc/redis/redis.conf'] ->
      Package['redis-server']
    }
    default: {
      fail('Wrong redis_ensure value')
    }
  }

  package { 'redis-server':
    ensure => $pkg_ensure,
  }

  file { '/etc/redis/redis.conf':
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/redis.conf.erb"),
  }

  service { 'redis-server':
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
