Hybris Cookbook
=====================

The Hybris Cookbook is a library cookbook that provides resource primitives
(LWRPs) for use in recipes.

Scope
-----
This cookbook can install and configure the "Hyrbis Commerce Suite".  


####Supported Core Features
- Installation of the platform from a bundled template
- Platform Configuration
- Adding extensions
- Single and Mulitnode Cluster.  Multi-tenant is not supported.

####Supported databases:
- MySQL
- HSQLDB

####Supported versions:
- 5.7




Requirements
------------
- Chef 12.4 or higher
- Ruby 1.9 or higher (preferably from the Chef full-stack installer)
- Network accessible package repositories
- 'recipe[selinux::disabled]' on RHEL platforms

Platform Support
----------------
The following platforms have been tested with Test Kitchen:

```
|----------------+-----+-----+-----+-----+-----|
|                | 5.0 | 5.1 | 5.5 | 5.6 | 5.7 |
|----------------+-----+-----+-----+-----+-----|
| debian-7       |     |     |     |     |     |
|----------------+-----+-----+-----+-----+-----|
| ubuntu-12.04   |     |     |     |     |     |
|----------------+-----+-----+-----+-----+-----|
| ubuntu-14.04   |     |     |     |     |     |
|----------------+-----+-----+-----+-----+-----|
| ubuntu-15.04   |     |     |     |     |     |
|----------------+-----+-----+-----+-----+-----|
| centos-5       |     |     |     |     |     |
|----------------+-----+-----+-----+-----+-----|
| centos-6       |     |     |     |  X  |     |
|----------------+-----+-----+-----+-----+-----|
| centos-7       |     |     |     |     |     |
|----------------+-----+-----+-----+-----+-----|
| amazon         |     |     |     |     |     |
|----------------+-----+-----+-----+-----+-----|
| fedora-20      |     |     |     |     |     |
|----------------+-----+-----+-----+-----+-----|
```

Cookbook Dependencies
------------
- yum
- mysql

Usage
-----
Place a dependency on the mysql cookbook in your cookbook's metadata.rb
```ruby
depends 'hybris', '~> 0.0.1'
```

Then, in a recipe:

```ruby
hybris_service 'foo' do
  version '5.7'
  cluster_enabled :false
  action [:create, :start]
end
```

Resources Overview
------------------
### hybris_build

The `hybris_service` installs a new node instance.

#### Example
```ruby
hybris_service 'foo' do
  version '5.7.0.2'
  cluster_enabled :true
  download_url 'http://my_custom_download_url.com/hybris-commerce-suite-5.7.0.2.zip'
  action [:create, :start]
end
```

#### Parameters

- `version` - Specifies the version being downloaded in download_url. Required.
- `download_url` - Hybris download links require authentication, so you must provide your own custom download link. Required.
- `user` - The service account for Hybris
- `group` - The group account for Hybris

#### Actions

- `:create` - Configures everything but the underlying operating system service.
- `:start` - Starts the underlying operating system service
- `:stop`-  Stops the underlying operating system service
- `:restart` - Restarts the underlying operating system service
- `:reload` - Reloads the underlying operating system service

#### Providers
Chef selects the appropriate provider based on platform and version,
but you can specify one if your platform support it.

- `Chef::Provider::HybrisBase` -

### hybris_config

The `hybris_config` resource is a wrapper around the core Chef
`template` resource. Instead of a `path` parameter, it uses the
`instance` parameter to calculate the path on the filesystem where
file is rendered.

WARNING: hybris_config will overwrite any config set from the template during build.  ENsure you include any paramaters you want to retain in the hybris_config resource variables.

#### Example

```ruby
hybris_config[default] do
  source 'local.properties.erb'
  action :create
end
```

#### Parameters

- `config_name` - The base name of the configuration file to be
  rendered into the conf.d directory on disk. Defaults to the resource
  name.

- `cookbook` - The name of the cookbook to look for the template
  source. Defaults to nil

- `group` - System group for file ownership. Defaults to 'hybris'.

- `owner` - System user for file ownership. Defaults to 'hybris'.

- `source` - Template in cookbook to be rendered.

- `variables` - Variables to be passed to the underlying `template`
  resource.

- `version` - Version of the `hybris_service` instance the config is
  meant for. Used to calculate path.

#### Actions
- `:create` - Renders the template to disk at a path calculated using
  the instance parameter.

- `:delete` - Deletes the file from the conf.d directory calculated
  using the instance parameter.

### hybris_server

The `hybris_server` resource is used to install and manage the bundled hybris tomcat server. It manages the server.xml config and sets up the Tanuki service wrapper.


#### Example


#### Parameters


### hybris_extension

The `hybris_config` resource is a wrapper around the core Chef
`template` resource. Instead of a `path` parameter, it uses the
`instance` parameter to calculate the path on the filesystem where
file is rendered.

#### Example

```ruby
hybris_extension 'myextension' do
  source 'local.properties.erb'
  action :enable
end
```

#### Parameters

- `name` - The base name of the configuration file to be
  rendered into the conf.d directory on disk. Defaults to the resource
  name.

#### Actions
- `:enable` - Renders the template to disk at a path calculated using
  the instance parameter.

- `:delete` - Deletes the file from the conf.d directory calculated
  using the instance parameter.

#### More Examples

License & Authors
-----------------
- Author:: Lachlan Munro (<lachlan.munro@rackspace.co.uk>)

```text

```
