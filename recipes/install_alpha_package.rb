#
# Cookbook Name:: filebeat
# Recipe:: install_alpha_package
#

require 'digest'

arch = node['kernel']['machine']

case node['platform_family']
when 'debian'
  arch = 'amd64' if node['kernel']['machine'] == 'x86_64'
  pkg_ext = 'deb'
when 'rhel'
  arch = 'i686' if node['kernel']['machine'] == 'i386'
  pkg_ext = 'rpm'
end

pkg_name = format('filebeat-%{version}-%{arch}.%{pkg_ext}',
                  version: node['filebeat']['version'],
                  arch: arch,
                  pkg_ext: pkg_ext)

# https://download.elastic.co/beats/filebeat/filebeat-5.0.0-alpha3-amd64.deb
pkg_url = node['filebeat']['download_url'] + pkg_name
checksum_val = node['filebeat']['package']['checksum'][node['platform_family']][node['kernel']['machine']]

remote_file "#{Chef::Config[:file_cache_path]}/#{pkg_name}" do
  source pkg_url
  checksum checksum_val
  mode 0644
  owner 'root'
end

package 'filebeat' do
  source "#{Chef::Config[:file_cache_path]}/#{pkg_name}"
  provider value_for_platform_family(
    %w(debian) => Chef::Provider::Package::Dpkg,
    %w(rhel fedora) => Chef::Provider::Package::Rpm)
  only_if do
    ::File.exist?("#{Chef::Config[:file_cache_path]}/#{pkg_name}") &&
      Digest::SHA256.file("#{Chef::Config[:file_cache_path]}/#{pkg_name}").hexdigest == checksum_val
  end
end
