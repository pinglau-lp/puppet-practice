class pasture {
  include pasture::base

  package {'pasture':
    ensure  => present,
    provider=> 'gem',
    before  => [File['/etc/pasture_config.yaml'],
                File['/etc/systemd/system/pasture.service']],
  }

###before: specify its influencing relationship;  use Array when having multiple parameter within same resource type
###notify: specify its influencing relationship + refresh its influenced resource
  
  file {'/etc/pasture_config.yaml':
    source  => 'puppet:///modules/pasture/pasture_config.yaml',
    notify  => Service['pasture'],
  }
  file {'/etc/systemd/system/pasture.service':
    source  => 'puppet:///modules/pasture/pasture.service',
    before  => Service['pasture'],
  }

  service {'pasture':
    ensure  => 'running',
  }
}
