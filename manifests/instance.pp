define statsd::instance (
  $graphite_server   = $statsd::params::graphite_server,
  $graphite_port     = $statsd::params::graphite_port,
  $backends          = $statsd::params::backends,
  $address           = $statsd::params::address,
  $port              = $statsd::params::port,
  $mgmt_address      = $statsd::params::mgmt_address,
  $mgmt_port         = $statsd::params::mgmt_port,
  $flush_interval    = $statsd::params::flush_interval,
  $percent_threshold = $statsd::params::percent_threshold,
  $config            = $statsd::params::config,
  $statsjs           = $statsd::params::statsjs,
  $init_script       = $statsd::params::init_script,
) {
  $service_name = "statsd-${name}"
  $config_file  = "/etc/statsd/config-${name}.js"
  $log_file     = "/var/log/statsd/statsd-${name}.log"

  file {
    $config_file:
      content => template('statsd/config.js.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      notify  => Service[$service_name],
      require => File['/etc/statsd'];
    "/etc/init.d/${service_name}":
      content => template($init_script),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      notify  => Service[$service_name];
    "/etc/default/${service_name}":
      content => template('statsd/statsd-defaults.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service[$service_name];
  }

  service { $service_name:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [
      File['/usr/local/sbin/statsd'],
      Package['statsd']
    ],
    require   => File['/var/log/statsd'];
  }
}
