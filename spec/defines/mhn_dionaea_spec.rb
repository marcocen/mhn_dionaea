require 'spec_helper'

describe 'mhn_dionaea' do
  let(:title) { 'namevar' }
  

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:params) do
        {
          'hpf_server' => '192.168.190.216',
          'hpf_id'     => 'someid',
          'hpf_secret' => 'the_secret',
        }
      end
      let(:facts) { os_facts }
      let(:service_path) { '/opt/dionaea/etc/dionaea/services-enabled' }
      it { is_expected.to compile }
      it { is_expected.to contain_file('/opt/dionaea/etc/dionaea/ihandlers-enabled/hpfeeds.yaml') }
      it { is_expected.to contain_supervisor__program('dionaea') }
      it { is_expected.to contain_file("#{service_path}/ftp.yaml").with('ensure' => 'link') }
      it { is_expected.to contain_file("#{service_path}/smb.yaml").with('ensure' => 'link') }
      it { is_expected.to contain_file("#{service_path}/http.yaml").with('ensure' => 'link') }
      it { is_expected.to contain_file("#{service_path}").with('purge' => true) }
      it { is_expected.to contain_firewalld_service('Allow ftp connections to dionaea') }
      it { is_expected.to contain_firewalld_service('Allow smb connections to dionaea') }
      it { is_expected.to contain_firewalld_service('Allow http connections to dionaea') }
    end
    context "on #{os} only ftp" do
      let(:params) do
        {
          'hpf_server' => '192.168.190.216',
          'hpf_id'     => 'someid',
          'hpf_secret' => 'the_secret',
          'services'   => ['ftp'],
        }
      end
      let(:facts) { os_facts }
      let(:service_path) { '/opt/dionaea/etc/dionaea/services-enabled' }
      it { is_expected.to compile }
      it { is_expected.to contain_file('/opt/dionaea/etc/dionaea/ihandlers-enabled/hpfeeds.yaml') }
      it { is_expected.to contain_supervisor__program('dionaea') }
      it { is_expected.to contain_file("#{service_path}/ftp.yaml").with('ensure' => 'link') }
      it { is_expected.to contain_file("#{service_path}").with('purge' => true) }
      it { is_expected.to contain_firewalld_service('Allow ftp connections to dionaea') }
    end
  end
end
