define statsd::proxy (
  $address        = $statsd::params::address,
  $port           = $statsd::params::port,
  $nodes          = $statsd::params::proxy_nodes,
  $udp_version    = $statsd::params::proxy_udp_version,
  $fork_count     = $statsd::params::proxy_fork_count,
  $check_interval = $statsd::params::proxy_check_interval,
  $cache_size     = $statsd::params::proxy_cache_size,
  $proxyjs        = $statsd::params::proxyjs,
  $init_script    = $statsd::params::init_script,
) {
  $service_name = "statsd-proxy-${name}"
  $config_file  = "/etc/statsd/proxy-config-${name}.js"
  $log_file     = "/var/log/statsd/statsd-proxy-${name}.log"
  $statsjs      = $proxyjs

  file {
    $config_file:
      content => template('statsd/proxy-config.js.erb'),
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
