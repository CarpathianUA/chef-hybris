
begin
  require 'chef/platform/provider_priority_map'
rescue LoadError
end

require_relative 'provider_hybris_service_sysvinit'
require_relative 'provider_hybris_config'

if defined? Chef::Platform::ProviderPriorityMap
  Chef::Platform::ProviderPriorityMap.instance.priority(
    :hybris_service,
    [Chef::Provider::HybrisServiceSysvinit],
    os: 'linux'
  )
else
  # provider mappings for Chef 11

  # default service
  Chef::Platform.set resource: :hybris_service, provider: Chef::Provider::HybrisServiceSysvinit

  # config
  Chef::Platform.set resource: :hybris_config, provider: Chef::Provider::HybrisConfig

end
