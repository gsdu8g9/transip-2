if defined?(ChefSpec)
  def transip_dns_entry(opts)
    ChefSpec::Matchers::ResourceMatcher.new(:transip_dns_entry, *opts)
  end

  def create_transip_dns_entry(entry)
    transip_dns_entry(:create, entry)
  end

  def create_if_missing_transip_dns_entry(entry)
    transip_dns_entry(:create_if_missing, entry)
  end

  def delete_transip_dns_entry(entry)
    transip_dns_entry(:delete, entry)
  end
end
