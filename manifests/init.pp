#
class ccgcloud () inherits ccgcloud::params {
  package { $ccgcloud::absent_packages:
    ensure  => absent,
  }

  file {'/etc/network/interfaces':
    content => template('ccgcloud/interfaces.erb'),
  }

  package { $ccgcloud::packages:
    ensure  => present
  }

}
