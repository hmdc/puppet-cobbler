require 'spec_helper'

describe 'cobbler::selinux' do
  let :pre_condition do
    <<-PUPPET
    class { "cobbler::service":
      service          => "cobblerd",
      service_ensure   => "running",
      service_enable   => true,
    }
    PUPPET
  end

  let(:facts) {
    {
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat'
    }
  }
  context 'with defaults for all parameters' do
    it { should contain_class('cobbler::selinux') }

    selinux_booleans = [
      'httpd_use_nfs',
      'httpd_enable_homedirs',
      'httpd_can_network_connect_cobbler',
      'httpd_serve_cobbler_files',
      'cobbler_can_network_connect',
      'allow_ypbind',
      'git_system_use_nfs',
      'cobbler_use_nfs',
    ]

    selinux_booleans.each do |bool|
      it { should contain_selinux__boolean(bool).with(
        'ensure' => 'on'
      ) }
    end

    it { should contain_selinux__fcontext('cobbler-var-lib-fcontext').with(
      'context'  => 'cobbler_var_lib_t',
      'pathname' =>  '/var/lib/tftpboot/boot(/.*)?'
    ) }

    it { should contain_selinux__module('HMDC-cobbler') }

  end

end
