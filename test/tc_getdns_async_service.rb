# File: tc_getdns_service_extension.rb

require_relative '../ext/getdns/getdns'

class GetDNSAsyncService
  def initialize
    options = {
      # option for stub resolver context
      "stub" => true,

      # upstream recursive servers
      "upstreams" => [
      #"192.168.0.1",
      #["127.0.0.1", 9053],
      "8.8.8.8"
      ],
      #request timeout time in millis
      "timeout" => 1000,

      #always return dnssec status
      "return_dnssec_status" => true,

      #setting dns transport
      "dns_transport" => 542
    }

    @context = Getdns::Context.new(options)
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

