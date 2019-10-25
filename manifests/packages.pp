# @summary Installs all required packages/python modules
#
# @example
#   include mhn_dionaea::packages
class mhn_dionaea::packages {
  $packages = [
    'cmake3',
    'check',
    'libev-devel',
    'loudmouth-devel',
    'libtool',
    'gcc',
    'gcc-c++',
    'make',
    'openssl-devel',
    # 'epel-release-7',
    'libemu-devel',
    'libnetfilter_queue-devel',
    'libnl3-devel',
    'libpcap-devel',
    'udns-devel',
    'python36',
    'python36-devel',
    'python36-Cython',
    'centos-release-scl',
    'rh-python36-python-bson',
    'python36-PyYAML',
    'libcurl-devel',
  ]

  $pip_modules = [
    'boto3',
    'bson',
  ]

  ensure_packages(
    $packages,
    {ensure => present},
  )

  Package {$pip_modules:
    ensure   => present,
    provider => pip3,
  }
}
