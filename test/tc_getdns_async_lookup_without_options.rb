# File: tc_getdns_lookup_extension.rb

require_relative '../ext/getdns/getdns'

class GetDNSAsyncLookup_without_options
  def initialize
    @context = Getdns::Context.new()
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

