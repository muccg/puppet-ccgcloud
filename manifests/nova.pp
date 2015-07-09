#
class ccgcloud::nova::conf (
  $memcached_servers             = undef,
  $database_connection           = undef,
  $my_ip                         = undef,
  $public_interface              = undef,
  $flat_interface                = undef,
  $ec2_dmz_host                  = undef,
  $s3_host                       = undef,
  $glance_api_servers            = undef,
  $novncproxy_base_url           = undef,
  $vncserver_proxyclient_address = undef,
  $vncserver_listen              = undef,
  $keystone_identity_uri         = 'http://127.0.0.1:35357',
  $keystone_admin_user           = undef,
  $keystone_admin_password       = undef,
  $rabbit_hosts                  = undef,
  $rabbit_userid                 = undef,
  $rabbit_password               = undef,
  $rabbit_virtual_host           = '/',
  $osapi_compute_workers         = '4',
  $metadata_workers              = '4',
  $conductor_workers             = '4',
  $ec2_workers                   = '4',
  $dns_server                    = '8.8.8.8',
  $rbd_user                      = undef,
  $rbd_secret_uuid               = undef,
) {

  file { '/etc/nova/api-paste.ini':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/nova/api-paste.ini.erb'),
  }

  file { '/etc/nova/nova.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/nova/nova.conf.erb'),
  }

  # local patch to the kilo nova-network code to allow us to specify
  # a hardware gateway. review to see if necessary in liberty.
  file { '/usr/lib/python2.7/dist-packages/nova/network/linux_net.py':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/nova/linux_net.py.erb'),
  }

}
