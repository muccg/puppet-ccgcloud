#
class ccgcloud::galeraarbitrator (
  $galera_nodes = undef,
  $galera_group = undef,
  $galera_options = undef,
  $galera_log_file = undef,
) {

  $packages = [
    'galera-arbitrator-3'
  ]

  package { $packages:
    ensure => installed
  }

  file { '/var/log/garb':
    ensure => directory,
    owner  => nobody,
  }

  file { '/etc/default/garb':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/garb.erb'),
    notify  => Service['garb'],
    require => Package[$packages],
  }

  service { 'garb':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$packages],
  }
}
