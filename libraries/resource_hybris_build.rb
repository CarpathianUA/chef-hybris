class Chef
  class Resource
    class HybrisBuild < Chef::Resource::LWRPBase
      provides :hybris_build

      self.resource_name = :hybris_build
      actions :build
      default_action :build

      attribute :platform_dir, kind_of: String, default: '/hybris/hybris/bin/platform'
      attribute :ant_setup_script, kind_of: String, default: '/hybris/hybris/bin/platform/setantenv.sh'
      attribute :commands, kind_of: Array, default: nil
      attribute :properties, kind_of: Array, default: nil
    end
  end
end
