class pasture {
  
  $port                 = '80'
  $default_character    = 'dragon'
  $default_message      = 'Hellp from variable in init.pp'
  $pasture_config_file  = '/etc/pasture_config.yaml'

  include pasture::base

  package {'pasture':
    ensure  => present,
    provider=> 'gem',
    before  => [File[$pasture_config_file],
                File['/etc/systemd/system/pasture.service']],
  }

###require: specify its influenced relationship;  use Array when having multiple parameter within same resource type
###subscribe: specify its influenced relationship + refresh itself
  
  $pasture_config_params = {
    'port'            => $port,
    'default_animal'  => $default_character,
    'default_message' => $default_message,
  }
  file { $pasture_config_file:
    content => epp('pasture/pasture_config.yaml.epp', $pasture_config_params),
  }

  $pasture_service_params = {
    'pasture_config_file' => $pasture_config_file,
  }
  file {'/etc/systemd/system/pasture.service':
    content => epp('pasture/pasture.service.epp', $pasture_service_params),
  }

  service {'pasture':
    ensure  => 'running',
    subscribe=> File[$pasture_config_file],
    require => File['/etc/systemd/system/pasture.service'],
  }
###PS.被影响的资源 Service['pasture']，把对两份文件的被影响关系都写到自己这里会显得concise
###同理Package['pasture']，把before的两个关系写在它那 好于 分别在pasture_config.yaml跟 pasture.service处写对它的require

}
