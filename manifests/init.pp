# @summary Adds a dionaea honeypot
#
# Downloads, compiles and configures the dionaea honeypot
#
# See the README.md for usage instructions for the mhn_dionaea type
#
# @example
# mhn_dionaea{'dionaea':
#     hpf_server => 'mhn.local',
# 	hpf_id     => '91ded218-eaec-11e9-954a-000c299b8253',
#     hpf_secret => 'LId9U19VHuQOUnTU',
# }
define mhn_dionaea (
  Stdlib::Host $hpf_server,
  String $hpf_id,
  String $hpf_secret,
  Stdlib::Port $hpf_port = 10000,
  Stdlib::HTTPSUrl $git_repo = 'https://github.com/DinoTools/dionaea.git',
  Array[Enum['blackhole','ftp','memcache','mongo','mssql','pptp','smb','upnp','epmap',
              'http','mirror','mqtt','mysql','sip','tftp']] $services = ['ftp','smb','http'],
) {
  include mhn_dionaea::packages
  include mhn_dionaea::firewall_services
  class {'mhn_dionaea::compilation':
    git_repo => $git_repo,
  }


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

  file {'/opt/dionaea/etc/dionaea/services-enabled':
    ensure  => directory,
    recurse => true,
    purge   => true,
    require => Exec['Make'],
  }
  
  $services.each |String $service| {
    file {"/opt/dionaea/etc/dionaea/services-enabled/${service}.yaml":
      ensure => link,
      target => "/opt/dionaea/etc/dionaea/services-available/${service}.yaml",
    }

    firewalld_service{"Allow ${service} connections to dionaea":
      ensure  => present,
      service => $service,
      zone    => 'public',
    }
  }

}
