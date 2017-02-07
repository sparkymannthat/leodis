#stops the current version if its there
bash "stop httpd if it exists" do
  code <<-EOH
    #{'/opt/apache/bin/apachectl -k stop'}
  EOH
  only_if { File.exists?('/opt/apache/bin/apachectl')}
end

#Installs Apache web server
package "apache2" do
  action :install
end

#installs node
package "node" do
  action :install
end

#installs nodejs
package "nodejs" do
  action :install
end

#adds the proxy module to apache2
execute 'apache config install proxy' do
  command '/usr/sbin/a2enmod proxy'
  only_if { File.exists?('/etc/apache2/mods-available/proxy.conf')}
end

#adds the proxy_http module to apache2
execute 'apache config install proxy_http' do
  command '/usr/sbin/a2enmod proxy_http'
  only_if { File.exists?('/etc/apache2/mods-available/proxy_http.load')}
end

#adds the vhost_alias module to apache2
execute 'apache config install vhost_alias' do
  command '/usr/sbin/a2enmod vhost_alias'
  only_if { File.exists?('/etc/apache2/mods-available/vhost_alias.load')}
end

#adds the authn_file module to apache2
execute 'apache config install authn_file' do
  command '/usr/sbin/a2enmod authn_file'
  only_if { File.exists?('/etc/apache2/mods-available/authn_file.load')}
end

#adds the rewrite module to apache2
execute 'apache config install rewrite' do
  command '/usr/sbin/a2enmod rewrite'
  only_if { File.exists?('/etc/apache2/mods-available/rewrite.load')}
end

#adds the userdir module to apache2
execute 'apache config install userdir' do
  command '/usr/sbin/a2enmod userdir'
  only_if { File.exists?('/etc/apache2/mods-available/userdir.conf')}
end

#adds the config module to apache2
execute 'apache config install actions' do
  command '/usr/sbin/a2enmod actions'
  only_if { File.exists?('/etc/apache2/mods-available/actions.conf')}
end

#adds the dav_lock module to apache2
execute 'apache config install dav_lock' do
  command '/usr/sbin/a2enmod dav_lock'
  only_if { File.exists?('/etc/apache2/mods-available/proxy_connect.load')}
end

#adds the dav_fs module to apache2
execute 'apache config install dav_fs' do
  command '/usr/sbin/a2enmod dav_fs'
  only_if { File.exists?('/etc/apache2/mods-available/dav_lock.load')}
end

#adds the cgi module to apache2
execute 'apache config install cgi' do
  command '/usr/sbin/a2enmod cgi'
  only_if { File.exists?('/etc/apache2/mods-available/cgi.load')}
end

#adds the asis module to apache2
execute 'apache config install asis' do
  command '/usr/sbin/a2enmod asis'
  only_if { File.exists?('/etc/apache2/mods-available/asis.load')}
end

#adds the cache module to apache2
execute 'apache config install cache' do
  command '/usr/sbin/a2enmod cache'
  only_if { File.exists?('/etc/apache2/mods-available/cache.load')}
end

#adds the filter module to apache2
execute 'apache config install filter' do
  command '/usr/sbin/a2enmod filter'
  only_if { File.exists?('/etc/apache2/mods-available/filter.load')}
end

#adds the include module to apache2
execute 'apache config install include' do
  command '/usr/sbin/a2enmod include'
  only_if { File.exists?('/etc/apache2/mods-available/include.load')}
end

#adds the env module to apache2
execute 'apache config install env' do
  command '/usr/sbin/a2enmod env'
  only_if { File.exists?('/etc/apache2/mods-available/env.load')}
end

#adds the expires module to apache2
execute 'apache config install expires' do
  command '/usr/sbin/a2enmod expires'
  only_if { File.exists?('/etc/apache2/mods-available/expires.load')}
end

#adds the headers module to apache2
execute 'apache config install headers' do
  command '/usr/sbin/a2enmod headers'
  only_if { File.exists?('/etc/apache2/mods-available/headers.load')}
end

#adds the proxy_ajp module to apache2
execute 'apache config install proxy_ajp' do
  command '/usr/sbin/a2enmod proxy_ajp'
  only_if { File.exists?('/etc/apache2/mods-available/proxy_ajp.load')}
end

#adds the proxy_connect module to apache2
execute 'apache config install proxy_connect' do
  command '/usr/sbin/a2enmod proxy_connect'
  only_if { File.exists?('/etc/apache2/mods-available/proxy_connect.load')}
end

#adds the proxy_ftp module to apache2
execute 'apache config install proxy_ftp' do
  command '/usr/sbin/a2enmod proxy_ftp'
  only_if { File.exists?('/etc/apache2/mods-available/proxy_ftp.conf')}
end

#adds the proxy_balancer module to apache2
execute 'apache config install proxy_balancer' do
  command '/usr/sbin/a2enmod proxy_balancer'
  only_if { File.exists?('/etc/apache2/mods-available/proxy_balancer.conf')}
end

#adds the cgid module to apache2
execute 'apache config install cgid' do
  command '/usr/sbin/a2enmod cgid'
  only_if { File.exists?('/etc/apache2/mods-available/cgid.conf')}
end

#creates the /var/node directory
directory '/var/node' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#creates the /var/node/leodis directory for the website
directory '/var/node/leodis' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#Copies the latest release of the app to the folder , update this for new releases
cookbook_file '/var/node/leodis.tar' do
  source 'leodis.tar'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#Copies the config file for apache to allow to redirect to the node website
cookbook_file '/etc/apache2/sites-available/httpd-vhosts.conf' do
  source 'httpd-vhosts.txt'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

#This is the service definition for leodis
cookbook_file '/etc/init/leodis.conf' do
  source 'leodis.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

#Unzips the leodis website to the server
bash 'extract node for Leodis' do
  #cwd ::File.dirname{'/var/node'}
  code <<-EOH
    tar -xf #{'/var/node/leodis.tar'} -C #{'/'}
  EOH
end


#removes the current default site , this allows our config file to be used for leodis
bash 'remove symbolic link for 000-default.conf' do
  code <<-EOH
    rm #{'/etc/apache2/sites-enabled/*'}
  EOH
end

#creates the symbolic link for the leodis config file for appache
bash 'setup symbolic link for httpd-vhosts' do
  code <<-EOH
    ln -s #{'/etc/apache2/sites-available/httpd-vhosts.conf'} #{'/etc/apache2/sites-enabled/httpd-vhosts.conf'}
  EOH
  not_if { File.exists?('/etc/apache2/sites-enabled/httpd-vhosts.conf')}
end

#Start the leodis node website
service "leodis" do
  action :start
end

#restart the apache service to read in the new config files
service "apache2" do
  action :restart
end
