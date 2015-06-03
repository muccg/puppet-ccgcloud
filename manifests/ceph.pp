#
class ccgcloud::ceph::conf (
  $fsid                     = undef,
  $mon_initial_members      = undef,
  $mon_host                 = undef,
  $public_network           = undef,
  $cluster_network          = undef,
  $osd_recovery_max_active  = undef,
) {

  file { '/etc/ceph/ceph.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/ceph/ceph.conf.erb'),
    require => Package[$packages],
  }

}


class ccgcloud::ceph::node (

  $absent_packages = [ 'network-manager',
                       'resolvconf',
                       'ufw', ]

  $packages = [ 'ethtool',
                'iotop',
                'iptraf',
                'strace',
                'tcpdump',
                'tree', ]

  package { $absent_packages:
    ensure  => absent,
  }

  package { $packages:
    ensure  => present,
  }

  $serial_src="start on stopped rc or RUNLEVEL=[12345]\nstop on runlevel [!12345]\n\nrespawn\nexec /sbin/getty -L 115200 ttyS0 vt102\n"
  file {'/etc/init/ttyS0.conf':
    content => $serial_src,
  }

  file {'/etc/network/interfaces':
    content => template('ccgcloud/ceph/interfaces.erb'),
  }
}


class ccgcloud::ceph::cephdeploy {
  $packages = [
    'ceph-deploy'
  ]

  package { $packages:
    ensure  => present
  }
}
