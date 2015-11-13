require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class HybrisService < Chef::Resource::LWRPBase
      provides :hybris_service

      self.resource_name = :hybris_service
      actions :create, :delete, :start, :stop, :restart, :reload
      default_action :create

      attribute :version, kind_of: String, default: nil
      attribute :download_url, kind_of: String, default: nil
      attribute :download_checksum, kind_of: String, default: nil
      attribute :download_temp_dir, kind_of: String, default: Chef::Config['file_cache_path']
      attribute :user, kind_of: String, default: 'hybris'
      attribute :group, kind_of: String, default: 'hybris'
      attribute :root_dir, kind_of: String, default: '/hybris'

    end
  end
end
