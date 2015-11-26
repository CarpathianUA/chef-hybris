require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class HybrisServiceBase < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      # Mix in helpers from libraries/helpers.rb
      include HybrisCookbook::Helpers

      action :build do

        # TODO: is it better to set hybris env variables based on resource values instead of setantenv.sh?

        create_user unless new_resource.run_user == 'root'
        create_group unless new_resource.run_group == 'root'
        install_required_packages
        download_hybris_ecommerce_suite
        unzip_hybris_ecommerce_suite
        chown_hybris_root
        # TODO: move_unzipped_hybris_folder_to_root_dir
        setup_ant_env
        ant_cmds = ['clean', 'all']
        ant_properties = ["input.template=#{new_resource.template}", "JAVAMEM=#{new_resource.jvm_mem}"]

        # clean and build hybris
        if deployed?
          run_ant(new_resource.platform_dir, ant_cmds, ant_properties) if new_resource.rebuild
        else
          run_ant(new_resource.platform_dir, ant_cmds, ant_properties)
        end

        # database config setup
        case new_resource.db_type
        when 'mysql'
          install_mysql_driver
        end

        # ant initialize
        run_ant(new_resource.platform_dir, ['initialize'], []) if new_resource.ant_initialize
        # ant update system
        run_ant(new_resource.platform_dir, ['update system'], []) if new_resource.ant_update_system

      end
    end
  end
end
