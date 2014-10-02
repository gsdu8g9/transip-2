#
# Default record type for DNS entry
#
default['transip']['type'] = 'A'

#
# Default ttl (Time to live) for DNS entry
#
default['transip']['ttl'] = 60

#
# Default record name for DNS entry
#
default['transip']['record_name'] = nil

#
# Default domain to register/delete DNS entries for
#
default['transip']['domain'] = nil

#
# Default content of DNS entry
#
default['transip']['content'] = nil

#
# Default username of your Transip account
#
default['transip']['username'] = nil

#
# Default private key used to authenticate with your Transip account. This
# private IP needs to be generated on the Transip API page:
# => https://www.transip.nl/cp/mijn-account/#api
#
default['transip']['private_key'] = nil

#
# Transip only accepts connections from whitelisted IPs (as specified in the
# API url provided above). To allow connections from servers without adding them
# individually to the whitelist, you can add a proxy URL to be used for API
# connections.
#
default['transip']['proxy'] = nil

#
# Default IP you are using to connect the Transip API. This should be set to the
# IP of the proxy server, if a proxy URL is specified above.
#
default['transip']['whitelist_ip'] = nil
