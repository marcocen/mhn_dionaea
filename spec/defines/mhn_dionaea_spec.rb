require 'spec_helper'

describe 'mhn_dionaea' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'hpf_server' => '192.168.190.216',
      'hpf_id'     => 'someid',
      'hpf_secret' => 'the_secret',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_supervisor__program('dionaea') }
    end
  end
end
