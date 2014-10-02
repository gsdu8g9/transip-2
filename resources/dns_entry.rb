actions :create, :delete, :create_if_missing
default_action :create

attribute :record_name,  kind_of: String, name_attribute: true
attribute :domain,       kind_of: String
attribute :content,      kind_of: String
attribute :type,         kind_of: String, equal_to: %w(A CNAME)
attribute :ttl,          kind_of: Integer, equal_to: [60, 300, 3600, 86400]
attribute :username,     kind_of: String
attribute :private_key,  kind_of: String
attribute :proxy,        kind_of: String
attribute :whitelist_ip, kind_of: String
