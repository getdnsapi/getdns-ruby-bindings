# File:  get_dns_extension.rb

require_relative '../ext/getdns/getdns'

class GetdnsHostName
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

  def test_hostname_status(ip)
    result = @context.hostname(ip)
    return result['status']
  end

  def test_hostname_canonical_name(ip)
    result= @context.general(ip)
    return result['canonical_name']
  end
end

