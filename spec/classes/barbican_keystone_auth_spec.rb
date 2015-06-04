#
# Unit tests for barbican::keystone::auth
#

require 'spec_helper'

describe 'barbican::keystone::auth' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'barbican_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('barbican').with(
      :ensure   => 'present',
      :password => 'barbican_password',
      :tenant   => 'foobar'
    ) }

    it { is_expected.to contain_keystone_user_role('barbican@foobar').with(
      :ensure  => 'present',
      :roles   => ['admin']
    )}

    it { is_expected.to contain_keystone_service('barbican').with(
      :ensure      => 'present',
      :type        => 'FIXME',
      :description => 'barbican FIXME Service'
    ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/barbican').with(
      :ensure       => 'present',
      :public_url   => "http://127.0.0.1:FIXME/",
      :admin_url    => "http://127.0.0.1:FIXME/",
      :internal_url => "http://127.0.0.1:FIXME/"
    ) }
  end

  describe 'when overriding public_protocol, public_port and public address' do
    let :params do
      { :password         => 'barbican_password',
        :public_protocol  => 'https',
        :public_port      => '80',
        :public_address   => '10.10.10.10',
        :port             => '81',
        :internal_address => '10.10.10.11',
        :admin_address    => '10.10.10.12' }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/barbican').with(
      :ensure       => 'present',
      :public_url   => "https://10.10.10.10:80/",
      :internal_url => "http://10.10.10.11:81/",
      :admin_url    => "http://10.10.10.12:81/"
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'barbicany' }
    end

    it { is_expected.to contain_keystone_user('barbicany') }
    it { is_expected.to contain_keystone_user_role('barbicany@services') }
    it { is_expected.to contain_keystone_service('barbicany') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/barbicany') }
  end

  describe 'when overriding service name' do
    let :params do
      { :service_name => 'barbican_service',
        :auth_name    => 'barbican',
        :password     => 'barbican_password' }
    end

    it { is_expected.to contain_keystone_user('barbican') }
    it { is_expected.to contain_keystone_user_role('barbican@services') }
    it { is_expected.to contain_keystone_service('barbican_service') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/barbican_service') }
  end

  describe 'when disabling user configuration' do

    let :params do
      {
        :password       => 'barbican_password',
        :configure_user => false
      }
    end

    it { is_expected.not_to contain_keystone_user('barbican') }
    it { is_expected.to contain_keystone_user_role('barbican@services') }
    it { is_expected.to contain_keystone_service('barbican').with(
      :ensure      => 'present',
      :type        => 'FIXME',
      :description => 'barbican FIXME Service'
    ) }

  end

  describe 'when disabling user and user role configuration' do

    let :params do
      {
        :password            => 'barbican_password',
        :configure_user      => false,
        :configure_user_role => false
      }
    end

    it { is_expected.not_to contain_keystone_user('barbican') }
    it { is_expected.not_to contain_keystone_user_role('barbican@services') }
    it { is_expected.to contain_keystone_service('barbican').with(
      :ensure      => 'present',
      :type        => 'FIXME',
      :description => 'barbican FIXME Service'
    ) }

  end

end
