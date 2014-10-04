p  = `ohai platform | awk "NR==2"`.strip.delete('"')
pv = `ohai platform_version | awk "NR==2"`.strip.delete('"')

def expanded_gems
  p       = `ohai platform | awk "NR==2"`.strip.delete('"')
  pv      = `ohai platform_version | awk "NR==2"`.strip.delete('"')
  cbpath  = Chef::Config[:cookbook_path]
  paths   = ['default', "#{p}-#{pv}", p].map! do |type|
    File.join(cbpath, 'transip', 'files', type, 'vendor', 'gems', '**', 'lib')
  end

  @expanded_gems ||= Dir[*paths]
end

if expanded_gems.any? { |s| s.include?('gems/transip') }
  $LOAD_PATH.unshift(*expanded_gems)
  require 'transip'
else
  File.directory?('/tmp/kitchen') || Chef::Application.fatal!(
    'The `transip` cookbook does not support your current platform: '     \
    "#{p}-#{pv}. Searched for the `transip` gem in these directories:\n " \
    "#{expanded_gems.join("\n")}\n You can add a request at "             \
    'http://github.com/kabisa-cookbooks/transip/issues.', 1)
end

module Kabisa
  # no-doc
  class Transip
    attr_reader :config, :defaults

    def initialize(config, defaults = {})
      @config   = config
      @defaults = defaults
    end

    def client
      ::Transip::DomainClient.new(client_options)
    end

    def dns_entry(dns_config)
      DNSEntry.new(client, dns_config)
    end

    private

    def client_options
      {
        mode:     :readwrite,
        username: config.username || defaults.username,
        key:      config.private_key || defaults.private_key,
        ip:       config.whitelist_ip || defaults.whitelist_ip,
        proxy:    config.proxy || defaults.proxy
      }.reject { |_, v| v.nil? }
    end
  end
end
