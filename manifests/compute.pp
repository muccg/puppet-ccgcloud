#
class ccgcloud::compute(
    $dmz_address = undef,
    $dmz_gateway = undef,
    $dmz_netmask = undef,
) {

  require ccgcloud::nova::conf
  require ccgcloud::libvirt::conf
  require ccgcloud::cinder::conf

  include ccgcloud::openstack

  case $::hostname {
    /^compute([\d+])$/: {
      $hostnum = $1
    }
    default: {
      fail("${::hostname} does not match expected hostname pattern")
    }
  }

  $absent_packages = [
    'network-manager',
    'neutron-plugin-openvswitch-agent',
    'neutron-common',
  ]

  $packages = [
    'nova-compute',
    'nova-compute-kvm',
    'cinder-common',
    'openvswitch-common',
    'nova-api-metadata',
    'python-novaclient',
    'nova-network',
  ]

  package { $absent_packages:
    ensure  => absent,
    require => Class['ccgcloud::openstack']
  }

  package { $packages:
    ensure  => present,
    require => Class['ccgcloud::openstack']
  }

  file {'/etc/network/interfaces':
    content => template('ccgcloud/compute/interfaces.erb'),
  }

  service { 'nova-compute':
    ensure    => running,
    enable    => true,
    provider  => upstart,
    require   => Package[$packages],
    subscribe => File['/etc/nova/nova.conf'],
  }

  service { 'cinder-volume':
    ensure    => running,
    enable    => true,
    provider  => upstart,
    require   => Package[$packages],
    subscribe => File['/etc/cinder/cinder.conf'],
  }

  service { 'nova-network':
    ensure    => running,
    enable    => true,
    provider  => upstart,
    require   => Package[$packages],
    subscribe => File['/etc/nova/nova.conf'],
  }

  service { 'libvirt-bin':
    ensure    => running,
    enable    => true,
    provider  => upstart,
    require   => Package[$packages],
    subscribe => File['/etc/libvirt/libvirtd.conf'],
  }

  service { 'nova-api-metadata':
    ensure    => running,
    enable    => true,
    provider  => upstart,
    require   => Package[$packages],
    subscribe => File['/etc/nova/nova.conf'],
  }
}

# Looks like a one-off script that was always being called,
# parked it here as it makes me nervous
class ccgcloud::compute::setup {
  file { '/usr/local/bin/ccgcompute-setup.sh':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('ccgcloud/compute/ccgcompute-setup.sh.erb'),
  }

  exec {'system initial setup':
    command  => '/usr/local/bin/ccgcompute-setup.sh',
    provider => shell,
    require  => File['/usr/local/bin/ccgcompute-setup.sh']
  }
}
