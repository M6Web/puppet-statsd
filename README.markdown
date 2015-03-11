puppet-statsd
=============

Manage StatsD with Puppet

Synopsis
--------

    class { 'statsd':
      provider => npm,
    }

    statsd::instance { '1':
      graphite_server   => 'my.graphite.server',
      flush_interval    => 1000, # flush every second
      percent_threshold => [75, 90, 99],
      address           => '10.20.1.2',
      port              => 2158,
      mgmt_port         => 2159
    }

    statsd::proxy { '1':
      address           => '10.20.1.4',
      port              => 2158,
      nodes             => [
        { host => '10.20.1.2', port => 2158, adminport => 2159 },
        { host => '10.20.1.3', port => 2158, adminport => 2159 }
      ]
    }

Notes
-----

To ensure that you have a fairly recent version of statsd, it's recommended
that you install statds via npm. The most recent version of statds in Debian
Sid is 0.0.2, which is so old that the current documentation doesn't even
remotely apply.

Contributors
------------

  * Thanks to Ben Hughes (ben@puppetlabs.com) for initial implementation
