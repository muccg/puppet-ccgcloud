#
class ccgcloud::cinder::conf (
  $memcached_servers             = undef,
  $auth_strategy                 = undef,
  $rbd_user                      = undef,
  $rbd_secret_uuid               = undef,
  $database_connection           = undef,
  $rabbit_hosts                  = undef,
  $rabbit_userid                 = undef,
  $rabbit_password               = undef,
  $rabbit_virtual_host           = '/',
  $keystone_auth_uri             = 'http://127.0.0.1:5000/v2.0',
  $keystone_identity_uri         = 'http://127.0.0.1:35357',
  $keystone_admin_user           = undef,
  $keystone_admin_password       = undef,
  $osapi_volume_workers          = '4',
) {

  file { '/etc/cinder/api-paste.ini':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/cinder/api-paste.ini.erb'),
  }

  file { '/etc/cinder/cinder.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/cinder/cinder.conf.erb'),
  }

}
