#
class ccgcloud::novanetwork {

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
