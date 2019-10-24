require 'spec_helper'

describe 'mhn_dionaea' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'hpf_server' => '192.168.190.216',
      'hpf_id'     => 'someid',
      'hpf_secret' => 'the_secret',
      'services'   => ['ftp'],
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:service_path) { '/opt/dionaea/etc/dionaea/services-enabled' }
      it { is_expected.to compile }
      it { is_expected.to contain_file('/opt/dionaea/etc/dionaea/ihandlers-enabled/hpfeeds.yaml') }
      it { is_expected.to contain_supervisor__program('dionaea') }
      it { is_expected.to contain_file("#{service_path}/ftp.yaml").with('ensure' => 'link') }
      it { is_expected.to contain_file("#{service_path}").with('purge' => true) }
    end
  end
end
