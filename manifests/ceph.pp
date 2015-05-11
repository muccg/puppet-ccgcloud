#
# TODO
#  - A lot of code to install one package??
class ccgcloud::ceph {

    $absent_packages = [
    ]

    $packages = [
        'ceph-deploy'
    ]

    package { $absent_packages:
        ensure  => absent
    }

    package { $packages:
        ensure  => present
    }
}
