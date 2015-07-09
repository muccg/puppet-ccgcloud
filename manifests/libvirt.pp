#
class ccgcloud::libvirt::conf {
  file { '/etc/libvirt/libvirtd.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/libvirt/libvirtd.conf.erb'),
  }

  file { '/etc/default/libvirt-bin':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('ccgcloud/libvirt/libvirt-bin.erb'),
  }
}
