require 'spec_helper'

describe 'cobbler' do
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

    it { should contain_class('cobbler') }
    it { should contain_class('cobbler::install') }
    it { should contain_class('cobbler::config').that_requires('Class[cobbler::install]') }
    it { should contain_class('cobbler::service').that_subscribes_to('Class[cobbler::config]') }
  end

  context 'with selinux fact set to true' do
    let(:facts) {
      {
        :fqdn            => 'test.example.com',
        :hostname        => 'test',
        :ipaddress       => '192.168.0.1',
        :operatingsystem => 'CentOS',
        :osfamily        => 'RedHat',
        :selinux         => true,
      }
    }

    it { should contain_class('cobbler::selinux').that_notifies('Class[cobbler::service]') }
  end

  context 'with argument install_dhcp => true' do
    let(:facts) {
      {
        :fqdn            => 'test.example.com',
        :hostname        => 'test',
        :ipaddress       => '192.168.0.1',
        :operatingsystem => 'CentOS',
        :osfamily        => 'RedHat',
        :selinux         => true,
      }
    }

    let(:params) { {
      :install_dhcp => true,
    } }

    it { should contain_class('cobbler::service::dhcpd') }
  end

  context 'with argument install_web => true' do
    let(:facts) {
      {
        :fqdn            => 'test.example.com',
        :hostname        => 'test',
        :ipaddress       => '192.168.0.1',
        :operatingsystem => 'CentOS',
        :osfamily        => 'RedHat',
        :selinux         => true,
      }
    }

    let(:params) { {
      :install_web => true,
    } }

    it { should contain_package('cobbler-web').with('ensure' => 'present') }
  end


end
