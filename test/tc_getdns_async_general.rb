# File: tc_getdns_general_extension.rb

require_relative '../ext/getdns/getdns'
require_relative 'tc_getdns_constants'

class GetDNSAsyncGeneral
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
    @context = Getdns::Context.new(options)
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

