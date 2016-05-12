describe "cobbler::kickstart_config" do
  let(:title) { 'rhel6-kickstart-template.ks' }

  context "with all default parameters" do
    let(:params) {  { :type => 'kickstart' } }
    # Both source and content will be undef
    it { is_expected.to raise_error(Puppet::Error) }
  end

  context "with invalid type set" do
    let(:params) { { :type => 'invalid' } }
    it { is_expected.to raise_error(Puppet::Error) }
  end

  context "with correct type, but, source and content defined simultaneously" do
    let(:params) { {
      :type    => 'snippet',
      :source  => 'puppet:///modules/my_module/cobbler-kickstart-snippet',
      :content => 'ks meta xyz',
    } }

    it { is_expected.to raise_error(Puppet::Error) }
  end

  context "with correct values, snippet, using source" do
    let(:params) { {
      :type    => 'snippet',
      :source  => 'puppet:///modules/my_module/cobbler-kickstart-snippet',
    } }

    it { is_expected.to contain_file('/var/lib/cobbler/snippets/rhel6-kickstart-template.ks').with(
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'source'  => 'puppet:///modules/my_module/cobbler-kickstart-snippet',
      'content' => nil).that_notifies(
        'Class[cobbler::service]')
    }
  end

  context "with correct values, snippet, using content" do
    let(:params) { {
      :type    => 'snippet',
      :content => 'ks meta xyz',
    } }

    it { is_expected.to contain_file('/var/lib/cobbler/snippets/rhel6-kickstart-template.ks').with(
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'source'  => nil,
      'content' => 'ks meta xyz').that_notifies(
        'Class[cobbler::service]')
    }
  end

  context "with correct values, snippet, using content" do
    let(:params) { {
      :type    => 'kickstart',
      :content => 'ks meta xyz',
    } }

    it { is_expected.to contain_file('/var/lib/cobbler/kickstarts/rhel6-kickstart-template.ks').with(
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'source'  => nil,
      'content' => 'ks meta xyz').that_notifies(
        'Class[cobbler::service]')
    }
  end


end
