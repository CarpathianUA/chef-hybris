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

      action :deploy do

        # Stop running tomcat
        # Delete all extensions ({hybris}/bin directory)
        # Unzip hybrisServer-AllExtensions.zip into hybris installation
        # Run "ant" in the platform directory. This will precompile jsp's
        # copy the Tomcat configuration
        # Start the hybrisServer
        # Running a System Update (if necessary) Creates new tables
        # Adds new attributes
        # Does not remove tables
        # Does not modify table columns of existing attributes

      end
    end
  end
end
