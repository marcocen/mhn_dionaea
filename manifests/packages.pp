# @summary This class installs all packages required by dionaea
#
# @example
#   include mhn_dionaea::packages
class mhn_dionaea::packages {
  $packages = [
    'git',
    'supervisor',
    'cmake',
    'check',
    'libev-dev',
    'libloudmouth1-dev',
    'libtool',
    'python3-boto3',
    'gcc',
    'gcc-c++',
    'make',
    'openssl-devel',
    'epel-release-7',
    'libemy-devel',
    'libnetfilter_queue-devel',
    'libnl3-devel',
    'libpcap-devel',
    'udns-devel',
    'python36',
    'python36-devel',
    'centos-release-scl',
    'rh-python36-python-bson',
    'python36-PyYAML',
    'libcurl-devel',
  ]

  $pip_modules = [
    'boto3',
    'bson3',
  ]

  ensure_packages(
    $packages,
    {ensure => present},
  )
}