# == Class cobbler:selinux
#
# Installs and configures Cobbler SeLinux rulesets. Automatically
# instantiated from the main cobbler class if the $::selinux fact is
# true.
#
# == Example
#
# include cobbler::selinux
#
# == Authors
#
# Evan Sarmiento <esarmien@g.harvard.edu>

class cobbler::selinux {

  Class['cobbler::selinux'] ->
  Class['cobbler::service']

  selinux::boolean { [
    'httpd_use_nfs',
    'httpd_enable_homedirs',
    'httpd_can_network_connect_cobbler',
    'httpd_serve_cobbler_files',
    'cobbler_can_network_connect',
    'allow_ypbind',
    'git_system_use_nfs',
    'cobbler_use_nfs',
  ]:
    ensure => 'on',
  }

  selinux::fcontext { 'cobbler-var-lib-fcontext':
    context  => 'cobbler_var_lib_t',
    pathname => '/var/lib/tftpboot/boot(/.*)?',
  }

  selinux::module { 'HMDC-cobbler':
    ensure => 'present',
    source => 'puppet:///modules/cobbler/cobbler.te',
  }

}
