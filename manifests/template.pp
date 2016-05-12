# == Define cobbler::template
#
# Installs user defined service templates to /etc/cobbler
#
# === Parameters
#
# [*title*]
#   Name of template, must be part of $accepted_templates
#  
#   Type: String
# [*source*]
#   Path to template
#
#   Type: String
#   Default: nil
# 
# [*content*]
#   Content of template
#   
#   Type: String
#   Default: nil
#
# === Example
#
# cobbler::template { 'dhcp':
#   source => 'puppet:///modules/my_cobbler/dhcp.template',
# }
#
# === Authors
#
# Evan Sarmiento <esarmien@g.harvard.edu>
define cobbler::template(
  $source = undef,
  $content = undef,
) {

  include cobbler

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $accepted_templates = [
    'bind',
    'dhcp',
    'dnsmasq',
    'named',
    'rsync',
    'secondary',
    'tftpd',
    'zone',
  ]

  if !($title in $accepted_templates) {
    $_accepted_templates = join($accepted_templates, ', ')
    fail("${title} is not a valid cobbler template. Use one of the\
 following ${_accepted_templates}")
  }

  if ($source and $content) {
    fail('source and content cannot be defined simultaneously.')
  }

  file { "${cobbler::config_path}/${title}.template":
    source  => $source,
    content => $content,
  } ~>
  Class['cobbler::service']

}
