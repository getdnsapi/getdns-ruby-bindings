# File: tc_getdns_edns_maximum_udp_payloadSize.rb
require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/edns_maximum_udp_payloadSize_module'

class Getdns_edns_maximum_udp_payloadSize
  def test_getdns_edns_extended_rcode_status(domain_name)
    x = Edns_maximum_udp_payloadSize_module.edns_maximum_udp_payloadSize(domain_name)
    return x['status']
  end

  def test_getdns_edns_maximum_udp_payloadSize_canonical_name(domain_name)
    x = Edns_maximum_udp_payloadSize_module.edns_maximum_udp_payloadSize(domain_name)
    return x['canonical_name']
  end
end

