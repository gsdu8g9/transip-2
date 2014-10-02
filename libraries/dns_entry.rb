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
        client.request(:get_info, domain_name: domain).dns_entries
      end

      private

      def save_entries(entries)
        client.request(:set_dns_entries, domain_name: domain,
                                         dns_entries: entries)

        true
      end
    end
  end
end
