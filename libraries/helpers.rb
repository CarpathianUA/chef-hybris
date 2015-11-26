require 'shellwords'
require 'uri'

module HybrisCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def install_required_packages
      pkgs = %w(unzip)

      return unless %w(rhel fedora).include? node['platform_family']
      case node['platform_family']
      when 'rhel'
        # append packages here
        pkgs.each do |pkg|
          yum_package pkg
        end
      end
    end

    # executes ant command from within cwd dir.
    # commands accepts an array of trailing commands. Eg. ['clean', 'all'] or ['build']
    # properties accepts array of properties or the ant -D<property>=<value> option
    # eg. ['input.template=production']
    def run_ant(cwd, commands, properties)

      setup_ant_env
      ant_command_str = commands.join(' ')
      properties = properties.map {|p| "-D#{p}"} # prepend -D to all properties
      prop_command_str = properties.join(' ')
      execute "ant #{ant_command_str} #{prop_command_str}" do
        cwd cwd
        command "#{new_resource.platform_dir}/apache-ant-1.9.1/bin/ant #{ant_command_str} #{prop_command_str}"
      end
    end

    def create_user
      user new_resource.run_user do
        comment 'hybris service account'
        home "/home/#{new_resource.run_user}"
        shell '/bin/bash'
      end

      directory "/home/#{new_resource.run_user}" do
        owner new_resource.run_user
        group new_resource.run_user
        mode '0755'
        recursive true
        action :create
      end
    end

    def deployed?
      return true if ::File.exists?("#{new_resource.root_dir}/config/local.properties")
      return false
    end

    def create_group
      group new_resource.run_group do
        members new_resource.run_user
        append true
      end
    end

    def download_hybris_ecommerce_suite
      temp_download = "#{new_resource.download_temp_dir}/hybris-commerce-suite-#{new_resource.version}"
      remote_file temp_download do
        source new_resource.download_url
        owner new_resource.run_user
        group new_resource.run_group
        mode '0755'
        action :create
      end
    end

    def chown_hybris_root
      execute 'chown hybris root dir' do
        command "chown -R #{new_resource.run_user}:#{new_resource.run_group} #{new_resource.root_dir}"
      end
    end

    def unzip_hybris_ecommerce_suite
      directory new_resource.extract_to do
        owner 'hybris'
        group 'hybris'
        mode '0755'
        recursive true
        action :create
      end

      temp_download = "#{new_resource.download_temp_dir}/hybris-commerce-suite-#{new_resource.version}"
      execute 'unzip hybris ecommerce suite' do
        command "unzip -o #{temp_download} -d #{new_resource.extract_to}"
        not_if {::File.exists?(new_resource.platform_dir)}
      end
    end

    # def move_to_root_dir
    #
    #   execute 'move to root dir' do
    #     command "mv -nT #{new_resource.extract_to}/hybris new_resource.root_dir"
    #     not_if {::File.exists?(new_resource.new_resource.platform_dir)}
    #   end
    # end

    def setup_ant_env
      ant_setup_script_dir = ::File.dirname(new_resource.ant_setup_script)
      ant_setup_script_file = ::File.basename(new_resource.ant_setup_script)
      execute "run ant setup script #{new_resource.ant_setup_script}" do
        cwd ant_setup_script_dir
        command ". ./#{ant_setup_script_file}"
      end
    end

    # requires full path to startup_script
    def stop_hybris(startup_script)
      execute "stop hybris" do
        cwd ::File.dirname(startup_script)
        command "#{startup_script} stop"
      end
    end

    # requires full path to startup_script
    def start_hybris(startup_script)
      execute "start hybris" do
        cwd ::File.dirname(startup_script)
        command "#{startup_script} start"
      end
    end

    # requires full path to startup_script
    def restart_hybris(startup_script)
      stop_hybris(startup_script)
      start_hybris(startup_script)
    end

    def install_mysql_driver(download_url='https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.0.8.tar.gz')
      filename = URI(download_url).path.split('/').last
      remote_file "#{Chef::Config['file_cache_path']}/#{filename}" do
        source download_url
        mode '0755'
      end

      execute "extract #{filename}" do
        cwd Chef::Config['file_cache_path']
        command "tar -xzf #{filename} && cp -v #{File.basename(filename, '.tar.gz')}/*.jar "\
        "#{new_resource.platform_dir}/lib/dbdriver/ && chown -R #{new_resource.run_user}:#{new_resource.run_group} "\
        "#{new_resource.platform_dir}/lib/dbdriver/"
      end
    end

  end
end
