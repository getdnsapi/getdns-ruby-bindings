# File:  tc_dnssec_return_validation_chain_extension.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/dnssec_return_validation_chain_extension'

class Dnssec_return_validation_chain_extension
  def test_getdns_dnssec_return_validation_chain_extension_status(domain_name)
    result = Dnssec_return_validation_chain_extension_module.dnssec_return_validation_chain(domain_name)
    return result['status']
  end

  def test_getdns_dnssec_return_validation_chain_extension_canonical_name(domain_name)
    result = Dnssec_return_validation_chain_extension_module.dnssec_return_validation_chain(domain_name)
    return result['canonical_name']
  end
end

