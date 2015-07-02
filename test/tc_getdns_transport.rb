# File: tc_getdns_transport_option.rb
require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/dns_transport_module'

class Getdns_transport_option
  def test_getdns_transport_status(canonical_name)
    x = Dns_transport_module.dns_transport(canonical_name)
    return x['status']
  end

  def test_getdns_transport_canonical_name(canonical_name)
    x = Dns_transport_module.dns_transport(canonical_name)
    return x['canonical_name']
  end
end

