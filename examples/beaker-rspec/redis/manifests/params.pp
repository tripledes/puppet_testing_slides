# == Class: redis::params
# Default parameters for redis class
#
class redis::params {
  case $::operatingsystem {
    'Ubuntu': {
      $ensure = present
      $daemonize = 'yes'
      $bind_address = '127.0.0.1'
      $port = 6379
      $databases = 16
    }
    default: {
      fail("${::operatingsystem} not supported by ${module_name}")
    }
  }
}
