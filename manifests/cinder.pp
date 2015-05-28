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
  $keystone_auth_uri             = undef,
  $keystone_identity_uri         = undef,
  $keystone_auth_host            = undef,
  $keystone_admin_user           = undef,
  $keystone_admin_password       = undef,
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
