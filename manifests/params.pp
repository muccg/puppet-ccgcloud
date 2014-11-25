#
class ccgcloud::params {

    case $::hostname {
      /^ccgcloud([\d+])$/: {
        $hostnum = $1
      }
      default: {
        fail("${::hostname} does not match expected hostname pattern")
      }
    }

    $absent_packages = [
    ]

    $packages = [
      'bridge-utils',
      'vlan',
      'xfsprogs',
      'mysql-client',
      'gdisk',
      'sysfsutils',
      'virt-manager',
      'qemu-kvm',
      'tmux'
    ]
}
