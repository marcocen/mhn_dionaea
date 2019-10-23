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

  file {'/opt/dionaea/lib64/dionaea/curl.so':
    ensure => present,
    source => '/opt/dionaea/lib/dionaea/curl.so',
    require => Exec['Make'],
  }

  file {'/opt/dionaea/lib64/dionaea/emu.so':
    ensure => present,
    source => '/opt/dionaea/lib/dionaea/emu.so',
    require => Exec['Make'],
  }

  file {'/opt/dionaea/lib64/dionaea/nfq.so':
    ensure => present,
    source => '/opt/dionaea/lib/dionaea/nfq.so',
    require => Exec['Make'],
  }

  file {'/opt/dionaea/lib64/dionaea/pcap.so':
    ensure => present,
    source => '/opt/dionaea/lib/dionaea/pcap.so',
    require => Exec['Make'],
  }

  supervisor::program {'dionaea':
    ensure         => present,
    enable         => true,
    command        => '/opt/dionaea/bin/dionaea -c /opt/dionaea/etc/dionaea/dionaea.cfg',
    directory      => '/opt/dionaea',
    stdout_logfile => '/opt/dionaea/var/log/dionaea.out',
    stderr_logfile => '/opt/dionaea/var/log/dionaea.err',
    autorestart    => true,
    # TODO: Add the rest of the required files, just to be sure:
    # - All log dirs
    # - All copied libs
    # - Hpfeeds config
    require        => [
      Exec['Make'],
      File[
        '/opt/dionaea/var/log/dionaea',
        '/opt/dionaea/var/log/dionaea/wwwroot',
        '/opt/dionaea/var/log/dionaea/binaries',
        '/opt/dionaea/var/log/dionaea/bistreams'
        '/opt/dionaea/lib64/dionaea/curl.so',
        '/opt/dionaea/lib64/dionaea/emu.so',
        '/opt/dionaea/lib64/dionaea/nfq.so',
        '/opt/dionaea/lib64/dionaea/pcap.so',
      ]
    ],
    subscribe => File['/opt/dionaea/etc/dionaea/ihandlers-enabled/hpfeeds.yaml'],
  }
}
