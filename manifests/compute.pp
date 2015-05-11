#
class ccgcloud::compute {

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
    'nova-network',
  ]

  $packages = [
    'xfsprogs',
    'mysql-client',
    'nova-compute',
    'nova-compute-kvm',
    'openvswitch-common',
    'nova-api-metadata',
    'python-novaclient',
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

  file { '/usr/local/bin/ccgcompute-network.sh':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0755',
      content => template('ccgcloud/compute/ccgcompute-network.sh.erb'),
  }

  # TODO This script references neutron, is it still current?
  exec {'system initial network setup':
    command  => '/usr/local/bin/ccgcompute-network.sh',
    provider => shell,
    require  => File['/usr/local/bin/ccgcompute-network.sh']
  }

  exec { '/usr/sbin/dpkg-statoverride --update --add root root 0644 /boot/vmlinuz-`/bin/uname -r` || exit 0': }

  file { '/etc/nova/api-paste.ini':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/compute/api-paste.ini.erb'),
    require => Package[$packages],
    notify  => Service['nova-compute'],
  }

  file { '/etc/nova/nova.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcompute/nova.conf.erb'),
    require => Package[$packages],
    notify  => Service['nova-compute'],
  }

  service { 'nova-compute':
    ensure    => running,
    enable    => true,
    provider  => upstart,
    require   => Package[$packages],
    subscribe => File['/etc/nova/nova.conf'],
  }

  service { 'nova-network':
    ensure    => running,
    enable    => true,
    provider  => upstart,
    require   => Package[$packages],
    subscribe => File['/etc/nova/nova.conf'],
  }

  service { 'nova-api-metadata':
    ensure    => running,
    enable    => true,
    provider  => upstart,
    require   => Package[$packages],
    subscribe => File['/etc/nova/nova.conf'],
  }
}

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
