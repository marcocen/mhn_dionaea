require 'spec_helper'

describe 'mhn_dionaea::packages' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_package('cmake3') }
      it { is_expected.to contain_package('check') }
      it { is_expected.to contain_package('libev-devel') }
      it { is_expected.to contain_package('loudmouth-devel') }
      it { is_expected.to contain_package('libtool') }
      it { is_expected.to contain_package('gcc') }
      it { is_expected.to contain_package('gcc-c++') }
      it { is_expected.to contain_package('make') }
      it { is_expected.to contain_package('openssl-devel') }
      it { is_expected.to contain_package('libemu-devel') }
      it { is_expected.to contain_package('libnetfilter_queue-devel') }
      it { is_expected.to contain_package('libnl3-devel') }
      it { is_expected.to contain_package('libpcap-devel') }
      it { is_expected.to contain_package('udns-devel') }
      it { is_expected.to contain_package('python36') }
      it { is_expected.to contain_package('python36-devel') }
      it { is_expected.to contain_package('python36-Cython') }
      it { is_expected.to contain_package('centos-release-scl') }
      it { is_expected.to contain_package('rh-python36-python-bson') }
      it { is_expected.to contain_package('python36-PyYAML') }
      it { is_expected.to contain_package('libcurl-devel') }
      it { is_expected.to contain_package('boto3').with('provider' => 'pip3') }
      it { is_expected.to contain_package('bson').with('provider' => 'pip3') }

    end
  end
end
