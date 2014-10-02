#
# DO NOT USE THIS RECIPE IN YOUR PRODUCTION ENVIRONMENT
#
# This recipe is only used for cookbook development. It compiples the latest
# version of the vendored gems to be included in the cookbook. You SHOULD NOT
# use this recipe in any production environment.
#
git_pkg     = 'git'
git_pkg     << '-core' if node[:platform_version] == '10.04'
gem_path    = File.join(Chef::Config[:file_cache_path], 'transip')
gem_file    = File.join(gem_path, "transip-#{node['gem_version']}.gem")
vendor_path = "/home/vagrant/files/#{node[:platform]}-" \
              "#{node[:platform_version]}/vendor"

execute 'apt-get update' do
  action :nothing
end.run_action(:run)

chef_gem 'mini_portile'

directory 'delete_compiled_gems' do
  action    :delete
  path      vendor_path
  recursive true
end

if node['build_gem']
  package git_pkg

  git 'transip' do
    action :sync
    destination gem_path
    repository  node['gem_repo']
    reference   node['gem_ref']
  end

  execute 'build_transip_gem' do
    action   :run
    not_if   { File.exist? gem_file }
    command  [File.join(Gem.bindir, 'gem'), 'build transip.gemspec'].join(' ')
    cwd      File.join(Chef::Config[:file_cache_path], 'transip')
  end
end

gem_package 'transip' do
  action     :install
  notifies   :run, 'bash[reduce_gem_size]'
  gem_binary File.join(Gem.bindir, 'gem')
  options    "--install-dir #{vendor_path}"

  if node['build_gem']
    source   gem_file
  else
    version  node['gem_version']
  end
end

bash 'reduce_gem_size' do
  action :nothing
  cwd    vendor_path
  code   <<-EOF
    rm -rf doc cache
  EOF
end
