default['filebeat']['version'] = '1.2.3'
default['filebeat']['disable_service'] = false
default['filebeat']['package_url'] = 'auto'

default['filebeat']['alpha_package'] = false
default['filebeat']['download_url'] = 'https://download.elastic.co/beats/filebeat/'

# Checksums for 5.0.0-alpha3 package
default['filebeat']['package']['checksum'].tap do |checksum|
  checksum['debian']['x86_64'] = '436bdc7663589f35b8837d751f7c9016e40ec3bb36ad89ba6f0f699e203240ea'
  checksum['debian']['i386'] = '4a8513b74796a915b6a672dfd6c23a0ce3577f899cc5281da611e75151f8bc8b'
  checksum['rhel']['x86_64'] = '8441e124df2a5764eeb962402fb39f67f4beb862a8e83258a2a365a452abb2bd'
  checksum['rhel']['i386'] = 'c6a1caa762212e933458503cc8b8a235f1dd039334915c120910bca7c6c85f9f'
end

default['filebeat']['notify_restart'] = true
default['filebeat']['windows'] = { 'base_dir' => 'C:/opt/filebeat' }
default['filebeat']['conf_dir'] = if node['platform'] == 'windows'
                                    "#{node['filebeat']['windows']['base_dir']}/filebeat-#{node['filebeat']['version']}-windows"
                                  else
                                    '/etc/filebeat'
                                  end
default['filebeat']['conf_file'] = if node['platform'] == 'windows'
                                     "#{node['filebeat']['conf_dir']}/filebeat.yml"
                                   else
                                     ::File.join(node['filebeat']['conf_dir'], 'filebeat.yml')
                                   end
default['filebeat']['prospectors_dir'] = if node['platform'] == 'windows'
                                           "#{node['filebeat']['conf_dir']}/conf.d"
                                         else
                                           ::File.join(node['filebeat']['conf_dir'], 'conf.d')
                                         end
default['filebeat']['yum']['baseurl'] = 'https://packages.elastic.co/beats/yum/el/$basearch'
default['filebeat']['yum']['description'] = 'Elastic Beats Repository'
default['filebeat']['yum']['gpgcheck'] = true
default['filebeat']['yum']['enabled'] = true
default['filebeat']['yum']['gpgkey'] = 'https://packages.elasticsearch.org/GPG-KEY-elasticsearch'
default['filebeat']['yum']['metadata_expire'] = '3h'
default['filebeat']['yum']['action'] = :create

default['filebeat']['apt']['uri'] = 'https://packages.elastic.co/beats/apt'
default['filebeat']['apt']['description'] = 'Elastic Beats Repository'
default['filebeat']['apt']['components'] = %w(stable main)
default['filebeat']['apt']['distribution'] = ''
# apt package install options
default['filebeat']['apt']['options'] = "-o Dpkg::Options::='--force-confnew'"
default['filebeat']['apt']['action'] = :add
default['filebeat']['apt']['key'] = 'https://packages.elasticsearch.org/GPG-KEY-elasticsearch'
