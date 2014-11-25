#
class ccgcloud () inherits ccgcloud::params {
  package { $ccgcloud::absent_packages:
    ensure  => absent,
    require => Class['openstack']
  }

  file {'/etc/network/interfaces':
    content => template('ccgcloud/interfaces.erb'),
  }

  package { $ccgcloud::packages:
    ensure  => present
  }

  file {'/etc/default/qemu-kvm':
     require => Package[$ccgcloud::packages],
     content => template('ccgcompute/grub.erb'),
  }

}
