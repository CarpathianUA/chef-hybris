require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class HybrisBuild < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      # Mix in helpers from libraries/helpers.rb
      include HybrisCookbook::Helpers

      action :build do

        platform_dir = "#{new_resource.root_dir}/bin/platform"
        setup_ant_env
        run_ant(platform_dir, new_resource.commands, new_resource.properties)

      end

    end
  end
end
