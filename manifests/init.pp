class pasture {
  include pasture::base

  package {'pasture':
    ensure  => present,
    provider=> 'gem',
    before  => [File['/etc/pasture_config.yaml'],
                File['/etc/systemd/system/pasture.service']],
  }

###require: specify its influenced relationship;  use Array when having multiple parameter within same resource type
###subscribe: specify its influenced relationship + refresh itself
  
  file {'/etc/pasture_config.yaml':
    source  => 'puppet:///modules/pasture/pasture_config.yaml',
  }
  file {'/etc/systemd/system/pasture.service':
    source  => 'puppet:///modules/pasture/pasture.service',
  }

  service {'pasture':
    ensure  => 'running',
    subscribe=> File['/etc/pasture_config.yaml'],
    require => File['/etc/systemd/system/pasture.service'],
  }
###PS.被影响的资源 Service['pasture']，把对两份文件的被影响关系都写到自己这里会显得concise
###同理Package['pasture']，把before的两个关系写在它那 好于 分别在File['/etc/pasture_config.yaml']跟 File['/etc/systemd/system/pasture.service']里写对它的require

}
