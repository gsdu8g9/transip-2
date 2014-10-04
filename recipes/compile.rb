#
# DO NOT USE THIS RECIPE IN YOUR PRODUCTION ENVIRONMENT
#
# This recipe is only used for cookbook development. It compiples the latest
# version of the vendored gems to be included in the cookbook. You SHOULD NOT
# use this recipe in any production environment.
#
gems_with_extensions = %w(nokogiri)

gem_path     = File.join(Chef::Config[:file_cache_path], 'transip')
gem_file     = File.join(gem_path, "transip-#{node['gem_version']}.gem")
default_path = '/home/vagrant/files/default/vendor'
vendor_path  = "/home/vagrant/files/#{node[:platform]}-" \
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
  package 'git'

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
  action   :nothing
  notifies :run, 'ruby_block[transfer_gems_without_extensions]'
  cwd      vendor_path
  code     <<-EOF
    rm -rf doc cache gems/*/spec gems/*/test
  EOF
end

ruby_block 'transfer_gems_without_extensions' do
  action :nothing
  block do
    Dir[File.join(vendor_path, '*')].each do |dir|
      next unless File.directory?(dir)
      next unless gems_with_extensions.any? do |ext|
        dir.include?(File.join(vendor_path, "#{ext}*"))
      end

      FileUtils.mkdir(default_path)
      FileUtils.mv(dir, default_path)
    end
  end
end
