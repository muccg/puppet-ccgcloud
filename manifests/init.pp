#
class ccgcloud {

  $absent_packages = [
    'resolvconf',
    'ufw',
  ]

  $packages = [
    'bridge-utils',
    'ethtool',
    'gdisk',
    'iotop',
    'htop',
    'iptraf',
    'mysql-client',
    'qemu-kvm',
    'strace',
    'sysfsutils',
    'tcpdump',
    'tmux',
    'tree',
    'virt-manager',
    'vlan',
    'xfsprogs',
  ]

  package { $ccgcloud::absent_packages:
    ensure  => absent,
  }

  package { $ccgcloud::packages:
    ensure  => present
  }

}
