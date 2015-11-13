require 'spec_helper'

describe 'mysql_service_test::single on centos-6.5' do
  cached(:centos_65_service_57_single) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '6.5',
      step_into: 'hybris_service'
    ) do |node|
      node.set['hybris']['version'] = '5.6'
    end.converge('hybris_service_test::single')
  end

  before do
    allow(Chef::Platform::ServiceHelpers).to receive(:service_resource_providers).and_return([:redhat])
    # stub_command('/usr/bin/test -f /var/lib/mysql-default/mysql/user.frm').and_return(true)
  end


end
