# File: tc_getdns_edns_do_bit.rb
require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/edns_do_bit_module'

class Getdns_edns_do_bit
  def test_getdns_edns_do_bit_module_status(domain_name)
    x = Edns_do_bit_module.edns_do_bit(domain_name)
    return x['status']
  end

  def test_getdns_edns_do_bit_canonical_name(domain_name)
    x = Edns_do_bit_module.edns_do_bit(domain_name)
    return x['canonical_name']
  end
end

