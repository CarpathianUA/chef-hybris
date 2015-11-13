require 'shellwords'

module HybrisCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def install_required_packages

      pkgs = %w(unzip)

      return unless %w(rhel fedora).include? node['platform_family']
      case node['platform_family']
      when 'rhel'
        # append packages here
      end
      
    end

  end
end
