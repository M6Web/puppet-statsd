class statsd(
  $ensure       = $statsd::params::ensure,
  $provider     = $statsd::params::provider,
  $node_manage  = $statsd::params::node_manage,
  $node_version = $statsd::params::node_version,
) inherits statsd::params {
  if $node_manage == true {
    class { '::nodejs': version => $node_version }
  }

  package { 'statsd':
    ensure   => $ensure,
    provider => $provider;
  }

  file {
    '/etc/statsd':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755';
    '/var/log/statsd':
      ensure => directory,
      owner  => 'nobody',
      group  => 'root',
      mode   => '0770';
    '/usr/local/sbin/statsd':
      source  => 'puppet:///modules/statsd/statsd-wrapper',
      owner   => 'root',
      group   => 'root',
      mode    => '0755';
  }
}
