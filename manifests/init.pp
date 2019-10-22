# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mhn_dionaea { 'namevar': }
define mhn_dionaea (
  String $user,
  Stdlib::Host $hpf_server,
  String $hpf_id,
  String $hpf_secret,
  Stdlib::Port $hpf_port = 10000,
) {
  include mhn_dionaea::packages

  $compile_dir = '/root/dionaea'

  file {$compile_dir:
    ensure => directory,
  }

  vcsrepo {$compile_dir:
    ensure => present,
    provider => git,
    source => 'https://github.com/DinoTools/dionaea.git',
    revision => 'baf25d6',
    require => File[$compile_dir],
  }

  file { "${compile_dir}/build":
    ensure => directory,
    require => Vcsrepo[$compile_dir],
  }

  exec {'Cmake':
    command => 'cmake3 -DCMAKE_INSTALL_PREFIX:PATH=/opt/dionaea ..',
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd => "${compile_dir}/build",
    unless => "test -f ${compile_dir}/build/Makefile",
    require => File["${compile_dir}/build"],
  }

  exec {'Make':
    command => 'make && make install',
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd => "${compile_dir}/build",
    unless => 'test -d /opt/dionaea',
    require => Exec['Cmake'],
  }

  file {'/opt/dionaea/etc/dionaea/ihandlers-enabled/hpfeeds.yaml':
    ensure => present,
    content => template('mhn_dionaea/hpfeeds.yaml.erb'),
    require => Exec['Make'],
  }

  file {
    default:
      ensure => directory,
      owner => nobody,
      group => nobody,
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

  supervisor::program {'dionaea':
    ensure         => present,
    enable         => true,
    command        => '/opt/dionaea/bin/dionaea -c /opt/dionaea/etc/dionaea/dionaea.cfg',
    directory      => '/opt/dionaea',
    stdout_logfile => '/opt/dionaea/var/log/dionaea.out',
    stderr_logfile => '/opt/dionaea/var/log/dionaea.err',
    autorestart    => true,
    user           => $user,
    require        => Exec['Make'],
  }
}
