class cobbler::service::dhcpd {
  Class['cobbler'] ->
  Class['cobbler::service::dhcpd']
  
  package { 'dhcp':
    ensure => 'present',
  } ~>
  Class['cobbler::service'] ~>
  service { 'dhcpd':
    ensure => 'running',
    enable => true,
  }

}
