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
  $keystone_auth_uri             = 'http://127.0.0.1:5000/v2.0',
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
  $cachemodes                    = 'writeback',
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


}
