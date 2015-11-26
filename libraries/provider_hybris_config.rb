require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class HybrisConfig < Chef::Provider::LWRPBase
      include HybrisCookbook::Helpers
      provides :hybris_config if defined?(provides)

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do

        config_dir = ::File.dirname(new_resource.path)

        directory config_dir do
          owner new_resource.owner
          group new_resource.group
          mode '0750'
          recursive true
          action :create
        end

        template "#{new_resource.path} :create " do
          path new_resource.path
          owner new_resource.owner
          group new_resource.group
          mode '0750'
          variables new_resource.variables
          source new_resource.source
          cookbook new_resource.cookbook
          action :create
          notifies :run, 'execute[Stoping hybris for config reload]', :immediately
        end

        # requires full path to startup_script
        execute "Stoping hybris for config reload" do
          cwd ::File.dirname(new_resource.startup_script)
          command "#{new_resource.startup_script} stop"
          only_if { new_resource.restart }
          action :nothing
          notifies :run, 'execute[Starting hybris for config reload]', :immediately
        end

        # requires full path to startup_script
        execute "Starting hybris for config reload" do
          cwd ::File.dirname(new_resource.startup_script)
          command "#{new_resource.startup_script} start"
          only_if { new_resource.restart }
          action :nothing
        end

      end
    end
  end
end
