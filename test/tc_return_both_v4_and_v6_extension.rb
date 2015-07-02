# File:  tc_return_both_v4_and_v6_extension.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/return_both_v4_and_v6_extension'

class Return_both_v4_and_v6_extension
  def test_getdns_return_both_v4_and_v6_extension_status(domain_name)
    result = Return_both_v4_and_v6_extension_module.return_both_v4_and_v6_extension(domain_name)
    return result['status']
  end

  def test_getdns_return_both_v4_and_v6_extension_canonical_name(domain_name)
    result = Return_both_v4_and_v6_extension_module.return_both_v4_and_v6_extension(domain_name)
    return result['canonical_name']
  end
end

