# mhn_dionaea

#### Table of Contents

1. [Description](#description)
2. [Beginning with mhn_dionaea](#beginning-with-mhn_dionaea)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

A module to add a dionaea honeypot

### Beginning with mhn_dionaea

```
mhn_dionaea{'dionaea':
    hpf_server => 'mhn.local',
	hpf_id     => '91ded218-eaec-11e9-954a-000c299b8253',
    hpf_secret => 'LId9U19VHuQOUnTU',
}
```

## Usage

In addition to the `hpf_server`, `hpf_id` and `hpf_secret`, you can
also set the `hpf_port`:

```
mhn_dionaea{'dionaea':
    hpf_server => 'mhn.local',
	hpf_id     => '91ded218-eaec-11e9-954a-000c299b8253',
    hpf_secret => 'LId9U19VHuQOUnTU',
	hpf_port   => 2187,
}
```

By default, the mhn_dionaea resource only enables the `ftp`, `smb` and
`http` services. You can enable any of the available services simply
by passing an array of those you want enabled. Note that any service
not declared will be disabled.

```
mhn_dionaea{'dionaea':
    hpf_server => 'mhn.local',
	hpf_id     => '91ded218-eaec-11e9-954a-000c299b8253',
    hpf_secret => 'LId9U19VHuQOUnTU',
	services   => ['memcache','mongo','mssql'],
}
```

## Reference

### `mhn_dionaea`

#### Parameters

##### `hpf_server`

The HPFeeds server, in the intended use-case this will be the MHN
server.

##### `hpf_port` 

The port where your HPF server accepts reports.

Defaults to 10000

##### `hpf_id`

The UUID that this honeypot will report as to the HPF server.

##### `hpf_secret`

The secret that this honeypot will use to communicate with the HPF
server.

#### `services`

An array containing all the services that will be enabled. Its type is
`Array[Enum['blackhole','ftp','memcache','mongo','mssql','pptp','smb','upnp','epmap','http','mirror','mqtt','mysql','sip','tftp']]`

## Limitations

`mhn_dionaea` can't manage the firewall to enable ports for either the
`blackhole` or `mirror` services. If you want to use those, you have
to enable the required ports elsewhere.

This module is only tested con CentOS7. It might work on other RHEL7
based distros but there are no warranties.


## Development

Any contributions are welcome in the form of Pull Requests on the main
github repo.
