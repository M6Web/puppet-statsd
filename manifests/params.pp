class statsd::params {
  $graphite_server      = 'localhost'
  $graphite_port        = '2003'
  $backends             = [ './backends/graphite' ]
  $address              = '0.0.0.0'
  $port                 = '8125'
  $mgmt_address         = '0.0.0.0'
  $mgmt_port            = '8126'
  $flush_interval       = '10000'
  $percent_threshold    = ['90']
  $ensure               = 'present'
  $provider             = 'npm'
  $config               = { }
  $node_module_dir      = ''
  $node_manage          = false
  $node_version         = 'present'

  case $::osfamily {
    'RedHat': {
      $init_script = 'statsd/statsd-init-rhel.erb'
      if ! $node_module_dir {
        $statsjs = '/usr/lib/node_modules/statsd/stats.js'
      }
      else {
        $statsjs = "${node_module_dir}/statsd/stats.js"
      }
    }
    'Debian': {
      $init_script = 'statsd/statsd-init.erb'
      if ! $node_module_dir {
        case $provider {
          'apt': {
            $statsjs = '/usr/share/statsd/stats.js'
          }
          'npm': {
            $statsjs = '/usr/lib/node_modules/statsd/stats.js'
          }
          default: {
            fail('Unsupported provider')
          }
        }
      } 
      else {
        $statsjs = "${node_module_dir}/statsd/stats.js"
      }
    }
    default: {
      fail('Unsupported OS Family')
    }
  }
}
