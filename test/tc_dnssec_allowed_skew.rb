# File:  tc_dnssec_allowed_skew.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/dnssec_allowed_skew_module'

class Getdns_dnssec_allowed_skew
  def test_getdns_dnssec_allowed_skew_status(domain_name)
    result = Dnssec_allowed_skew_module.dnssec_allowed_skew(domain_name)
    return result['status']
  end

  def test_getdns_dnssec_allowed_skew_canonical_name(domain_name)
    result = Dnssec_allowed_skew_module.dnssec_allowed_skew(domain_name)
    return result['canonical_name']
  end
end

