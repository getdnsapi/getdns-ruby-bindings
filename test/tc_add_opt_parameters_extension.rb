# File:  tc_dnssec_return_only_secure_extension.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/add_opt_parameters_extension'

class Add_opt_parameters_extension
  def test_getdns_add_opt_parameters_extension_status(domain_name)
    result = Add_opt_parameters_extension_module.add_opt_parameters_extension(domain_name)
    return result['status']
  end

  def test_getdns_add_opt_parameters_extension_canonical_name(domain_name)
    result = Add_opt_parameters_extension_module.add_opt_parameters_extension(domain_name)
    return result['canonical_name']
  end
end

