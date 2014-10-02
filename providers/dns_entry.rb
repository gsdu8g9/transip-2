def whyrun_supported?
  true
end

use_inline_resources

action :create do
  unless dns_entry.all.any? { |entry| entry == new_entry }
    converge_by('create DNS record') do
      new_resource.updated_by_last_action dns_entry.create(new_entry)
    end
  end
end

action :create_if_missing do
  unless dns_entry.all.any? { |entry| entry.name == record_name }
    converge_by('create DNS record') do
      new_resource.updated_by_last_action dns_entry.create_if_missing(new_entry)
    end
  end
end

action :delete do
  if dns_entry.all.any? { |entry| entry.name == record_name }
    converge_by('delete DNS record') do
      new_resource.updated_by_last_action dns_entry.delete(record_name)
    end
  end
end

private

def transip
  Kabisa::Transip.new(new_resource, node['transip'])
end

def new_entry
  ::Transip::DnsEntry.new(*options)
end

def dns_entry
  transip.dns_entry(domain)
end

def options
  [record_name, ttl, type, content]
end

def domain
  new_resource.domain || node['transip']['domain']
end

def content
  new_resource.content || node['transip']['content']
end

def record_name
  new_resource.record_name || node['transip']['record_name']
end

def ttl
  (new_resource.ttl || node['transip']['ttl']).to_s
end

def type
  new_resource.type || node['transip']['type']
end
