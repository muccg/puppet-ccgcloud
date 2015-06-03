#
class ccgcloud::ceph (
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

  file {'/etc/network/interfaces':
    content => template('ccgcloud/ceph/interfaces.erb'),
  }
}
