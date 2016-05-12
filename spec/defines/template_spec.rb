describe "cobbler::template" do

  context "with invalid template: xyz" do
    let(:title) { 'xyz' }
    let(:params) { { 'source' => 'puppet:///modules/my_cobbler/xyz.template' } }

    it { is_expected.to raise_error(Puppet::Error) }
  end

  context "with both source and content defined" do
    let(:title) { 'dhcp' }
    let(:params) { { 'source'  => 'puppet:///modules/my_cobbler/xyz.template',
                     'content' => 'sometemplatedata' } }

    it { is_expected.to raise_error(Puppet::Error) }
  end

  context "with all valid arguments" do
    let(:title) { 'dhcp' }
    let(:params) { { 'source'  => 'puppet:///modules/my_cobbler/xyz.template' } }

    it { is_expected.to contain_file('/etc/cobbler/dhcp.template').with(
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'source'  => 'puppet:///modules/my_cobbler/xyz.template',
      'content' => nil).that_notifies('Class[cobbler::service]') }
  end

end
