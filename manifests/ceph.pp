#
class ccgcloud::ceph {

  $absent_packages = [
  ]

  $packages = [
    'ceph-deploy'
  ]

  package { $absent_packages:
    ensure  => absent
  }

  package { $packages:
    ensure  => present
  }

  file { '/etc/ceph/ceph.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/ceph/ceph.conf.erb'),
    require => Package[$packages],
  }
}
