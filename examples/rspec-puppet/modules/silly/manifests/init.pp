#
class silly {
  package { 'redis-server':
    ensure => latest,
  }
}
