require 'spec_helper'

describe 'cobbler::service::dhcpd' do
  context 'with defaults for all parameters' do
    let(:facts) {
      {
        :fqdn            => 'test.example.com',
        :hostname        => 'test',
        :ipaddress       => '192.168.0.1',
        :operatingsystem => 'CentOS',
        :osfamily        => 'RedHat'
      }
    }

    let :pre_condition do
      <<-PUPPET
      class { "cobbler::service":
        service        => "cobblerd",
        service_ensure => "running",
        service_enable => true,
      }
      PUPPET
    end

    it { should contain_class('cobbler::service::dhcpd') }
    it { should contain_package('dhcpd').with('ensure' => 'present').that_notifies('Class[cobbler::service]') }
    it { should contain_service('dhcpd').with('ensure' => 'running',
                                              'enable' => true).that_subscribes_to('Class[cobbler::service]') }
  end
end
