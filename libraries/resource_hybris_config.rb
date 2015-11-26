require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class HybrisConfig < Chef::Resource::LWRPBase
      provides :hybris_config

      self.resource_name = :hybris_config
      actions :create, :delete
      default_action :create

      attribute :config_name, kind_of: String, name_attribute: true
      attribute :root_dir, kind_of: String, default: '/hybris/hybris', required: true
      attribute :restart, :kind_of => [TrueClass, FalseClass], :default => false
      attribute :startup_script, kind_of: String, default: lazy {|r| "#{r.root_dir}/bin/platform/hybrisserver.sh" }
      attribute :path, kind_of: String, default: lazy {|r| "#{r.root_dir}/config/local.properties" }
      attribute :cookbook, kind_of: String, default: nil
      attribute :group, kind_of: String, default: 'hybris'
      attribute :owner, kind_of: String, default: 'hybris'
      attribute :source, kind_of: String, default: 'local.properties.erb'
      attribute :variables, kind_of: [Hash], default: nil
    end
  end
end
