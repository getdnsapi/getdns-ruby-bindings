# File: tc_getdns_edns_extended_rcode.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/edns_extended_rcode_module'

class Getdns_edns_extended_rcode
  def test_getdns_edns_extended_rcode_status(domain_name)
    x = Edns_extended_rcode_module.edns_extended_rcode(domain_name)
    return x['status']
  end

  def test_getdns_edns_extended_rcode_canonical_name(domain_name)
    x = Edns_extended_rcode_module.edns_extended_rcode(domain_name)
    return x['canonical_name']
  end
end

