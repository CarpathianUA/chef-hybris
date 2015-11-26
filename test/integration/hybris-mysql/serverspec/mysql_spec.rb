# Encoding: utf-8
require 'serverspec'

set :backend, :exec

set :path, '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:$PATH'

describe user('hybris') do
  it { should exist }
end

describe service('hybris_server') do
  it { should be_enabled }
  it { should be_running }
end

ports = %w(9001 8009 9003 9004)
ports.each do | pt |
  describe port(pt) do
    it { should be_listening }
  end
end

describe file('/hybris/hybris/config/local.properties') do
  its(:content) { should match /tomcat.maxthreads=200/ }
  its(:content) { should match /java.mem=3G/ }
  it { should be_writable.by_user('hybris') }
end

date = DateTime.now.strftime("%Y%m%d")
describe file("/hybris/hybris/log/tomcat/console-#{date}.log") do
  its(:content) { should_not match /java.sql.SQLException/ }
  its(:content) { should_not match /SEVERE: Error listenerStart/ }
end
