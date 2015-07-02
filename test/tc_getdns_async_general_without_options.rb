# File: tc_getdns_general_extension.rb

require_relative '../ext/getdns/getdns'
require_relative 'tc_getdns_constants'

class GetDNSAsyncGeneral_without_options
  def initialize
    @context = Getdns::Context.new()
  end

  def test_getdns_async_general_status(domain_name)
    result= @context.general(domain_name,TestGetdnsConstants::GETDNS_RRTYPE_A)
    return result['status']
  end

  def test_getdns_async_general_canonical_name(domain_name)
    result= @context.general(domain_name,TestGetdnsConstants::GETDNS_RRTYPE_A)
    return result['canonical_name']
  end
end

