require 'spec_helper'

describe 'mhn_dionaea::firewall_services' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_firewalld__custom_service('memcache') }
      it { is_expected.to contain_firewalld__custom_service('mongo') }
      it { is_expected.to contain_firewalld__custom_service('pptp') }
      it { is_expected.to contain_firewalld__custom_service('smb') }
      it { is_expected.to contain_firewalld__custom_service('upnp') }
      it { is_expected.to contain_firewalld__custom_service('epmap') }
    end
  end
end
