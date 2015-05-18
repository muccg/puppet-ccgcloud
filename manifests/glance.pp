#
class ccgcloud::glance::conf (
  $database_connection           = undef,
  $registry_host                 = undef,
  $swift_store_auth_address      = undef,
  $swift_store_user              = undef,
  $swift_store_key               = undef,
  $keystone_auth_host            = undef,
  $keystone_admin_user           = undef,
  $keystone_admin_password       = undef,
  $rabbit_host                   = undef,
  $rabbit_userid                 = undef,
  $rabbit_password               = undef,
  $rabbit_virtual_host           = '/',
) {

  file { '/etc/glance/glance-api.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/glance/glance-api.conf.erb'),
  }

  file { '/etc/glance/glance-registry.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/glance/glance-registry.conf.erb'),
  }

  file { '/etc/glance/glance-cache.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/glance/glance-cache.conf.erb'),
  }

}
