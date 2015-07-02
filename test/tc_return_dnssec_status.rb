# File:  tc_return_dnssec_status.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/return_dnssec_status_module'

class Getdns_return_dnssec_status
  def test_getdns_return_dnssec_status(domain_name)
    result = Return_dnssec_status_module.return_dnssec_status(domain_name)
    return result['status']
  end

  def test_getdns_return_dnssec_status_canonical_name(domain_name)
    result = Return_dnssec_status_module.return_dnssec_status(domain_name)
    return result['canonical_name']
  end
end

