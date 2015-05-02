#
class ccgcloud::params {

    case $::hostname {
      /^ccgcloud([\d+])$/: {
        $hostnum = $1
      }
      # docker based test env support
      /^puppetmaster$/: {
        $hostnum = $1
      }
      default: {
        fail("${::hostname} does not match expected hostname pattern")
      }
    }

    $absent_packages = [
      'ufw',
    ]

    $packages = [
      'bridge-utils',
      'ethtool',
      'gdisk',
      'iotop',
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
}
