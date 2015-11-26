require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class HybrisService < Chef::Resource::LWRPBase
      provides :hybris_deploy

      self.resource_name = :hybris_deploy
      actions :deploy
      default_action :deploy

      attribute :run_user, kind_of: String, default: 'hybris'
      attribute :run_group, kind_of: String, default: 'hybris'
      attribute :root_dir, kind_of: String, default: '/hybris/hybris'
      attribute :platform_dir, kind_of: String, default: '/hybris/hybris/bin/platform'
      attribute :ant_setup_script, kind_of: String, default: '/hybris/hybris/bin/platform/setantenv.sh'
      attribute :platform_zip, kind_of: String, default: nil # Eg. '/hybris/hybris/temp/hybris/hybrisServer/hybrisServer-Platform.zip'
      attribute :extensions_zip, kind_of: String, default: nil # Eg. '/hybris/hybris/temp/hybris/hybrisServer/hybrisServer-AllExtensions'
      attribute :run_system_update, :kind_of => [TrueClass, FalseClass], :default => false
    end
  end
end
