#
class ccgcloud::cephdeploy (
  $deploy_ssh_public_key  = undef,
) {
  $packages = [
    'ceph-deploy'
  ]

  package { $packages:
    ensure  => present
  }

  class { 'sudo':
    purge               => false,
    config_file_replace => false,
  } ->

  user { "ceph":
    ensure     => present,
    managehome => true,
    shell      => '/bin/bash',
    comment    => "Ceph",
  } ->

  sudo::conf { 'ceph':
    priority => 10,
    content  => 'ceph ALL = (root) NOPASSWD:ALL',
  } ->

  file {'/home/ceph/.ssh/':
    ensure => "directory"
  } ->

  file {'/home/ceph/.ssh/authorized_keys':
    content => template('ccgcloud/ceph/authorized_keys.erb'),
  }
}
