# @summary Compiles and installs dionaea
#
# Clones the dionaea git repo, checks out the preferred commit
# and compiles/installs it
#
# @example
#   include mhn_dionaea::compilation
class mhn_dionaea::compilation (
    Stdlib::HTTPSUrl $git_repo,
) {
  include ::git

  $compile_dir = '/root/dionaea'

  file {$compile_dir:
    ensure => directory,
  }

  vcsrepo {$compile_dir:
    ensure   => latest,
    provider => git,
    source   => $git_repo,
    require  => File[$compile_dir],
  }

  file { "${compile_dir}/build":
    ensure  => directory,
    require => Vcsrepo[$compile_dir],
  }

  exec {'Cmake':
    command => 'cmake3 -DCMAKE_INSTALL_PREFIX:PATH=/opt/dionaea ..',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd     => "${compile_dir}/build",
    unless  => "test -f ${compile_dir}/build/Makefile",
    require => File["${compile_dir}/build"],
  }

  exec {'Make':
    command => 'make && make install',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd     => "${compile_dir}/build",
    unless  => 'test -d /opt/dionaea',
    require => Exec['Cmake'],
  }

  file {
    default:
      ensure  => directory,
      owner   => nobody,
      group   => nobody,
      require => Exec['Make'],
      ;
    '/opt/dionaea/var/log/dionaea':
      ;
    '/opt/dionaea/var/log/dionaea/wwwroot':
      ;
    '/opt/dionaea/var/log/dionaea/binaries':
      ;
    '/opt/dionaea/var/log/dionaea/bistreams':
      ;
  }

  file {'/opt/dionaea/lib64/dionaea/curl.so':
    ensure  => present,
    source  => '/opt/dionaea/lib/dionaea/curl.so',
    require => Exec['Make'],
  }

  file {'/opt/dionaea/lib64/dionaea/emu.so':
    ensure  => present,
    source  => '/opt/dionaea/lib/dionaea/emu.so',
    require => Exec['Make'],
  }

  file {'/opt/dionaea/lib64/dionaea/nfq.so':
    ensure  => present,
    source  => '/opt/dionaea/lib/dionaea/nfq.so',
    require => Exec['Make'],
  }

  file {'/opt/dionaea/lib64/dionaea/pcap.so':
    ensure  => present,
    source  => '/opt/dionaea/lib/dionaea/pcap.so',
    require => Exec['Make'],
  }
}
