#
class ccgcloud::controller {

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

  file {'/etc/network/interfaces':
    content => template('ccgcloud/interfaces.erb'),
  }

}
