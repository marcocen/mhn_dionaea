require 'spec_helper'

describe 'mhn_dionaea::compilation' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_file('/root/dionaea').with('ensure' => 'directory') }
      it { is_expected.to contain_vcsrepo('/root/dionaea') }
      it { is_expected.to contain_file('/root/dionaea/build').with('ensure' => 'directory') }
      it { is_expected.to contain_file('/opt/dionaea/var/log/dionaea') }
      it { is_expected.to contain_file('/opt/dionaea/var/log/dionaea/wwwroot') }
      it { is_expected.to contain_file('/opt/dionaea/var/log/dionaea/binaries') }
      it { is_expected.to contain_file('/opt/dionaea/var/log/dionaea/bistreams') }
      it { is_expected.to contain_file('/opt/dionaea/lib64/dionaea/curl.so') }
      it { is_expected.to contain_file('/opt/dionaea/lib64/dionaea/emu.so') }
      it { is_expected.to contain_file('/opt/dionaea/lib64/dionaea/nfq.so') }
      it { is_expected.to contain_file('/opt/dionaea/lib64/dionaea/pcap.so') }
    end
  end
end
