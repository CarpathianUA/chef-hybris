Hybris Cookbook
=====================

WARNING:  This cookbook is still in Beta.

The Hybris Cookbook is a library cookbook that provides resource primitives
(HWRPs) for use in recipes.

Scope
-----
This cookbook can build, configure and deploy the "Hyrbis Commerce Suite".  


####Supported Core Features
- Installation of the platform from a bundled template
- Platform Configuration
- Adding extensions
- Single and Mulitnode Cluster.  Multi-tenant is not supported.

####Supported databases:
- MySQL
- HSQLDB

####Supported versions:
- Hybris Commerce 5.7+


Requirements
------------
- Chef 12.4 or higher
- Ruby 1.9 or higher (preferably from the Chef full-stack installer)

Platform Support
----------------

Currently only Centos-6 has been tested with Test Kitchen.


Cookbook Dependencies
------------
- yum

Usage
-----
Place a dependency on the hybris cookbook in your cookbook's metadata.rb
```ruby
depends 'hybris', '~> 0.0.1'
```

Ensure you install java before including the resource. 

Eg:

```ruby
include_recipe 'java'
hybris_service 'default' do
  version '5.7.0.2'
  download_url 'http://my_own_hybris_download_url/hybris-commerce-suite-5.7.0.2.zip'
  download_checksum 'e6e293f9a1b43faec76daab8b70294099a3df3d7661ff9d29a84cdaaf1340f61'
  download_temp_dir '/tmp'
  action [:build, :start]
  rebuild true
  template 'develop'
end
```

Resources Overview
------------------
### hybris_build

The `hybris_service` installs a new node instance.

#### Example
```ruby
hybris_service 'default' do
  version '5.7.0.2'
  download_url 'http://my_own_hybris_download_url/hybris-commerce-suite-5.7.0.2.zip'
  download_checksum 'e6e293f9a1b43faec76daab8b70294099a3df3d7661ff9d29a84cdaaf1340f61'
  download_temp_dir '/tmp'
  action [:build, :start]
  rebuild true
  template 'production'
end
```

#### Parameters

- `:version` Hybris ecommerce version.  Not used in download_url.
- `:download_url` Hybris ecommerce download url.  Must be a zip. You will need to put this somewhere as Hybris downloads require authentication.
- `:download_checksum` checksum for Hybris download.
- `:download_temp_dir` temp directory to download hybris zip to before extraction.
- `:run_user` Hybris service account. Default 'hybris'
- `:run_group` Hybris service group. Default 'hybris'
- `:extract_to` Parent directroy to extract hybris zip into. default: '/hybris' 
- `:root_dir` Root dir of Hybris after extraction. default: '/hybris/hybris'
- `:platform_dir` Hybris platform directory default: <root_dir>/bin/platform
- `:ant_setup_script` Path to ant env setup script default: <root_dir>/bin/platform/setantenv.sh
- `:template` The Hybris build template to use. default: 'develop'
- `:jvm_mem` JVM Memory allocation. default: '3G'
- `:rebuild` Trigger a rebuild when already deployed once. If file hybris/config/local.properties exists, a deploy has already happened. :default => false
- `:db_type` Only used to install db driver for mysql at the moment. default: 'mysql'
- `:ant_initialize` initializes the db after build. Can be triggered manually from UI. :default => false. NOT YET WORKING.
- `:ant_update_system` Performs db update. Can be triggered manually from UI. :default => false. NOT YET WORKING.

#### Actions

- `:build` - Performs an ant clean all build of the Hybris ecommerce suite.
- `:start` - Starts the underlying operating system service
- `:stop`-  Stops the underlying operating system service
- `:restart` - Restarts the underlying operating system service
- `:enable` - Enables the underlying operating system service

#### Providers
Chef selects the appropriate provider based on platform and version,
but you can specify one if your platform support it.

- `Chef::Provider::HybrisServiceSysvinit` -

### hybris_config

The `hybris_config` resource is a wrapper around the core Chef
`template` resource. to generate the hybris/config/local.properties config file.  Use this to set your own db connection details and other config.  Only include in a recipe after the hybris_service resource.  You need to provide your own template file.

**WARNING**: hybris_config will overwrite any config set from the template during build.  Ensure you include any paramaters you want to retain in the hybris_config resource variables.

#### Example

```ruby
hybris_config 'my custom config' do
  restart true
  source 'local.properties.erb'
  cookbook 'hybris_test'
  variables node['hybris_test']['hybris_config']
  action :create
end
```

#### Parameters

- `:config_name`, Not used. name_attribute: true
- `:root_dir`, Hybris root directory. Default: '/hybris/hybris', required: true
- `:restart`, Restart hybris server on new or changed template? Default: false
- `:startup_script`, Path to the hybris startup script file. Default: <hybris_root>/bin/platform/hybrisserver.sh
- `:path` Path to place config file. default: <root_dir>/config/local.properties
- `:cookbook`, Cookbook source for template file. default: nil
- `:group`, config file group. default: 'hybris'
- `:owner`, config file owner default: 'hybris'
- `:source`, template source file. default: 'local.properties.erb'
- `:variables`, variables to pass template (Hash), default: nil

#### Actions
- `:create` - Renders the template to disk at a path calculated using
  the instance parameter.


### hybris_build
The `hybris_build` resource is a wrapper around the ant build command for running the various ant commands bundled with Hybris Commerce .

This is not yet done.

#### Example

```ruby
hybris_build 'clean and build all' do
  commands ['clean', 'all']
  properties ['input.template=production']
  action :build
end
```

#### Parameters

- `:root_dir` Root dir of Hybris after extraction. default: '/hybris/hybris'
- `:platform_dir` Hybris platform directory default: <root_dir>/bin/platform
- `:ant_setup_script` Path to ant env setup script default: <root_dir>/bin/platform/
- `:commands`,  Array of ant commands. default: nil
- `:properties`, Array of ant properties. default: nil

#### Actions
- `:build` - Runs ant command.
- 

### hybris_deploy

The `hybris_deploy` deploys hybrisServer-AllExtensions.zip and hybrisServer-Config.zip files. The .zip files can be pre generated by a seperate build process such as a jenkins server.  

This is not yet done.

#### Example

```ruby
hybris_build 'package for production deployment' do
  commands ['production']
  properties []
  action :build
end
```

```ruby
hybris_deploy 'deploy' do
  extensions_zip '/hybris/hybris/temp/hybris/hybrisServer/hybrisServer-AllExtensions.zip'
  config_zip '/hybris/hybris/temp/hybris/hybrisServer/hybrisServer-Config.zip'
  action :deploy
end
```

#### Parameters

TODO:

#### Actions
TODO:


### hybris_extension

The `hybris_extension` resource manages the extension list to compile in the extensions.xml file.

This is not yet done.

#### Example

TODO:

#### Parameters

TODO:

#### Actions
TODO:

#### More Examples

License & Authors
-----------------
- Author:: Lachlan Munro (<lachlan.munro@rackspace.co.uk>)

```text

```
