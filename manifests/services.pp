# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mhn_dionaea::services
class mhn_dionaea::services {
  
  firewalld::custom_service{ 'memcache':
    short       => 'memcache',
    description => 'Memcached',
    port        => [
      {
        'port'     => 1121,
        'protocol' => 'tcp',
      },
    ],
  }

  firewalld::custom_service{ 'mongo':
    short       => 'mongo',
    description => 'MongoDB',
    port        => [
      {
        'port'     => 27017,
        'protocol' => 'tcp',
      },
      {
        'port'     => 27018,
        'protocol' => 'tcp',
      },
      {
        'port'     => 27019,
        'protocol' => 'tcp',
      },
    ],
  }
  firewalld::custom_service{ 'pptp':
    short       => 'pptp',
    description => 'PPTP',
    port        => [
      {
        'port'     => 1723,
        'protocol' => 'tcp',
      },
    ],
  }
  firewalld::custom_service{ 'smb':
    short       => 'smb',
    description => 'SMB',
    port        => [
      {
        'port'     => 137,
        'protocol' => 'udp',
      },
      {
        'port'     => 138,
        'protocol' => 'udp',
      },
      {
        'port'     => 139,
        'protocol' => 'tcp',
      },
      {
        'port'     => 445,
        'protocol' => 'tcp',
      }
    ],
  }
  firewalld::custom_service{ 'upnp':
    short       => 'upnp',
    description => 'UPNP',
    port        => [
      {
        'port'     => 1900,
        'protocol' => 'udp',
      },
    ],
  }
  firewalld::custom_service{ 'epmap':
    short       => 'epmap',
    description => 'epmap',
    port        => [
      {
        'port'     => 135,
        'protocol' => 'tcp',
      },
    ],
  }
  
}
