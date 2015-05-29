#
class ccgcloud::cephdeploy (
) {
  $packages = [
    'ceph-deploy'
  ]

  package { $packages:
    ensure  => present
  }
}
