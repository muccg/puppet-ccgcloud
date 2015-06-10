#
class ccgcloud::compute(
    $dmz_address = undef,
    $dmz_netmask = undef,
    $dmz_gateway = undef,
    $keystone_auth_host = undef,
    $keystone_admin_user = undef,
    $keystone_admin_password = undef,
    $memcached_servers = undef,
    $sql_connection = undef,
    $my_ip = undef,
    $public_interface = undef,
    $ec2_dmz_host = undef,
    $s3_host = undef,
    $rabbit_hosts = undef,
    $rabbit_userid = undef,
    $rabbit_password = undef,
    $rabbit_virtual_host = undef,
    $glance_api_servers = undef,
    $novncproxy_base_url = undef,
    $vncserver_proxyclient_address = undef,
    $vncserver_listen = undef,
    $auth_strategy = undef,
    $rbd_user = undef,
    $rbd_secret_uuid = undef,
    $database_connection = undef,
) {

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
    'nova-compute',
    'nova-compute-kvm',
    'cinder-common',
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

  file { '/etc/nova/api-paste.ini':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/compute/nova/api-paste.ini.erb'),
    require => Package[$packages],
    notify  => Service['nova-compute'],
  }

  file { '/etc/nova/nova.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/compute/nova/nova.conf.erb'),
    require => Package[$packages],
    notify  => Service['nova-compute'],
  }

  file { '/etc/cinder/api-paste.ini':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/compute/cinder/api-paste.ini.erb'),
    require => Package[$packages],
    notify  => Service['cinder-volume'],
  }

  file { '/etc/cinder/cinder.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/compute/cinder/cinder.conf.erb'),
    require => Package[$packages],
    notify  => Service['cinder-volume'],
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
