#
class ccgcloud::keystone::conf (
  $admin_token            = undef,
  $bind_host              = '0.0.0.0',
  $cache_backend_argument = 'url:127.0.0.1:11211',
  $database_connection    = undef,
) {

  file { '/etc/keystone/keystone.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/keystone/keystone.conf.erb'),
  }

}
