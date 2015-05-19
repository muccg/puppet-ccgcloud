#
class ccgcloud::horizon::conf (
  $allowed_hosts     = "['localhost', ]",
  $debug             = 'False',
  $caches_location   = "['localhost:11211',]",
  $openstack_host    = "127.0.0.1",
) {

  file { '/etc/openstack-dashboard/local_settings.py':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/horizon/local_settings.py.erb'),
  }

}
