require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class HybrisService < Chef::Resource::LWRPBase
      provides :hybris_service

      self.resource_name = :hybris_service
      actions :build, :start, :stop, :restart
      default_action :build

      attribute :version, kind_of: String, default: nil
      attribute :download_url, kind_of: String, default: nil
      attribute :download_checksum, kind_of: String, default: nil
      attribute :download_temp_dir, kind_of: String, default: Chef::Config['file_cache_path']
      attribute :run_user, kind_of: String, default: 'hybris'
      attribute :run_group, kind_of: String, default: 'hybris'
      attribute :extract_to, kind_of: String, default: '/hybris'
      attribute :root_dir, kind_of: String, default: '/hybris/hybris'
      attribute :platform_dir, kind_of: String, default: lazy {|r| "#{r.root_dir}/bin/platform" }
      attribute :ant_setup_script, kind_of: String, default: lazy {|r| "#{r.root_dir}/bin/platform/setantenv.sh" }
      attribute :template, kind_of: String, default: 'develop'
      attribute :jvm_mem, kind_of: String, default: '3G'
      attribute :rebuild, :kind_of => [TrueClass, FalseClass], :default => false
      attribute :db_type, :kind_of => String, default: 'mysql', :regex => /^(mysql|hsqldb|oracle|percona|none)$/
      attribute :ant_initialize, :kind_of => [TrueClass, FalseClass], :default => false
      attribute :ant_update_system, :kind_of => [TrueClass, FalseClass], :default => false
    end
  end
end
