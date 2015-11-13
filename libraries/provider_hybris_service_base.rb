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


      # Service related methods referred to in the :create and :delete
      # other actions need to be implemented in the init system subclasses.
      #
      # create_stop_system_service
      # delete_stop_service

      # All other methods are found in libraries/helpers.rb
      #
      # etc_dir, run_dir, log_dir, etc

      action :create do

        temp_download = "#{new_resource.download_temp_dir}/hybris-commerce-suite-#{new_resource.version}"

        #create_user
        #create_group
        download_hybris_ecommerce_suite
        unzip_hybris_ecommerce_suite

      end

      def create_user
        directory "/home/#{new_resource.user}" do
          owner new_resource.user
          group new_resource.user
          mode '0755'
          recursive true
          action :create
        end

        user new_resource.user do
          comment 'hybris service account'
          home "/home/#{new_resource.user}"
          shell '/sbin/nologin'
        end
      end

      def create_group
        group new_resource.group do
          members new_resource.user
          append true
        end
      end

      def download_hybris_ecommerce_suite
        remote_file temp_download do
          source new_resource.download_url
          owner new_resource.user
          group new_resource.group
          mode '0755'
          action :create
        end
      end

      def unzip_hybris_ecommerce_suite
        execute 'unzip hybris ecommerce suite' do
          command "unzip -o #{temp_download} -d #{new_resource.root_dir}"
        end
      end

    end
  end
end
