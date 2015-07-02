# File:  tc_basic_resolution_recursing.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/basic_resolution_recursing_module'

class Getdns_basic_resolution_recursing
  def test_getdns_basic_resolution_recursing_status(domain_name)
    result = Basic_resolution_recursing_module.basic_resolution_recursing(domain_name)
    return result['status']
  end

  def test_getdns_basic_resolution_recursing_canonical_name(domain_name)
    result = Basic_resolution_recursing_module.basic_resolution_recursing(domain_name)
    return result['canonical_name']
  end
end

