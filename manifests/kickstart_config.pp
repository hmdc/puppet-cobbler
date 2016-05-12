# == Define cobbler::kickstart_config
#
# Installs user defined kickstart template or snippet
#
# === Parameters
#
# [*title*]
#   Kickstart or snippet name
#  
#   Type: String
# [*type*]
#   Only 'kickstart' or 'snippet' are accepted values
#  
#   Type: String
#   Default: nil
# [*source*]
#   Path to kickstart or snippet
#
#   Type: String
#   Default: nil
# 
# [*content*]
#   Content of kickstart or snippet
#   
#   Type: String
#   Default: nil
#
# === Example
#
# cobbler::kickstart_config { 'my-kickstart-template':
#   type   => 'kickstart',
#   source => 'puppet:///modules/my_cobbler/my-kickstart.template',
# }
#
# === Authors
#
# Evan Sarmiento <esarmien@g.harvard.edu>
define cobbler::kickstart_config(
  $type,
  $source = undef,
  $content = undef,
) {

  include cobbler

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  if ($type !~ /^kickstart$|^snippet$/) {
    fail('Valid values for type must be either kickstart or snippet.')
  }

  if ($source == undef and $content == undef) {
    fail('Either source or content must be defined.')
  }

  if ($source and $content) {
    fail('Source and content cannot be defined simultaneously.')
  }

  $basepath = $type ? {
    'kickstart' => dirname($::cobbler::_cobbler_config['default_kickstart']),
    'snippet'   => $::cobbler::_cobbler_config['snippetsdir'],
  }

  file { "${basepath}/${title}":
    source  => $source,
    content => $content,
  } ~>
  Class['::cobbler::service']


}
