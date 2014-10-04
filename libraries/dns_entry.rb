module Kabisa
  # no-doc
  class Transip
    # no-doc
    class DNSEntry
      attr_reader :client, :domain

      def initialize(client, domain)
        @client = client
        @domain = domain
      end

      def create(entry)
        save_entries all.reject { |e| e.name == entry.name }.push(entry)
      end

      def create_if_missing(entry)
        save_entries all.push(entry)
      end

      def delete(record_name)
        save_entries all.reject { |e| e.name == record_name }
      end

      def all
        filter_wildcards(domain_details.dns_entries)
      end

      private

      def domain_details
        client.request(:get_info, domain_name: domain)
      end

      #
      # Due to an unknown bug in either the Ruby client, or the TransIP API, DNS
      # entries with wildcards (*) in them, will fail the request:
      #
      #   Transip::ApiError: Invalid API signature, signature does not match the
      #   request. (timestamp: 0.74032400 1412434601)
      #
      # These domains are therefor filtered out (and thus no longer work). This
      # can be problematic, but until a workaround is possible, this is the only
      # way to work with DNS entries.
      #
      def filter_wildcards(entries)
        wildcards = entries.select { |entry| entry.name == '*' }

        if wildcards.any?
          Chef::Log.warn 'DNS entries with wildcards have been removed from '  \
                         'your API query. The following entries where removed:'\
                         "\n#{wildcards.join("\n")}"
        end

        entries - wildcards
      end

      def save_entries(entries)
        client.request(:set_dns_entries, domain_name: domain,
                                         dns_entries: entries)

        true
      end
    end
  end
end
