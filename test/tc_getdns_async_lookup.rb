# File: tc_getdns_lookup_extension.rb

require_relative '../ext/getdns/getdns'

class GetDNSAsyncLookup
  def initialize
    options = {
      "stub" => true,
      "upstreams" => [
      "10.88.29.89",
      ["1.2.3.4",9053]
      ],
      "timeout" => 1000,
      "return_dnssec_status" => true
    }
    print options
    @context = Getdns::Context.new(options)
  end

  def test_getdns_async_lookup_status(domain_name)
    result= @context.lookup(domain_name)
    return result['status']
  end

  def test_getdns_async_lookup_canonical_name(domain_name)
    result= @context.lookup(domain_name)
    return result['canonical_name']
  end
end

