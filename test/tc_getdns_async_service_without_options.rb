# File: tc_getdns_service_extension.rb

require_relative '../ext/getdns/getdns'

class GetDNSAsyncService_without_options
  def initialize
    @context = Getdns::Context.new()
  end

  def test_getdns_async_service_status(domain_name)
    result= @context.service(domain_name)
    return result['status']
  end

  def test_getdns_async_service_canonical_name(domain_name)
    result= @context.service(domain_name)
    return result['canonical_name']
  end
end

