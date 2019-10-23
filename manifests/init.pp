# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   mhn_dionaea { 'namevar': }
define mhn_dionaea (
  Stdlib::Host $hpf_server,
  String $hpf_id,
  String $hpf_secret,
  Stdlib::Port $hpf_port = 10000,
  Array[Enum['blackhole','ftp','memcache','mongo','mssql','pptp','smb','upnp','epmap','http','mirror','mqtt','mysql','sip','tftp']] $services = ['ftp','smb','http'],
) {
  include mhn_dionaea::packages
  include mhn_dionaea::compilation


  file {'/opt/dionaea/etc/dionaea/ihandlers-enabled/hpfeeds.yaml':
    ensure  => present,
    content => template('mhn_dionaea/hpfeeds.yaml.erb'),
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
        '/opt/dionaea/var/log/dionaea/bistreams',
        '/opt/dionaea/lib64/dionaea/curl.so',
        '/opt/dionaea/lib64/dionaea/emu.so',
        '/opt/dionaea/lib64/dionaea/nfq.so',
        '/opt/dionaea/lib64/dionaea/pcap.so',
      ]
    ],
    subscribe      => File['/opt/dionaea/etc/dionaea/ihandlers-enabled/hpfeeds.yaml'],
  }

  $services.each |String $service| {
    file {"/opt/dionaea/etc/dionaea/services-enabled/${service}.yaml":
      ensure => present,
      source => "puppet:///modules/mhn_dionaea/${service}.yaml"
    }
  }

  $disabled_services = ['blackhole','ftp','memcache','mongo','mssql','pptp','smb','upnp','epmap','http','mirror','mqtt','mysql','sip','tftp']-$services
  $disabled_services.each |String $service| {
    file {"/opt/dionaea/etc/dionaea/services-enabled/${service}.yaml":
      ensure => absent,
    }
  }
}
