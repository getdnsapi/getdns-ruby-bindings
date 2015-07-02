# File: tc_basic_resolution_stub_module.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/basic_resolution_stub_module'

class Getdns_basic_resolution_stub
  def test_getdns_basic_resolution_stub_status(domain_name)
    result = Basic_resolution_stub_module.basic_resolution_stub(domain_name)
    return result['status']
  end

  def test_getdns_basic_resolution_stub_canonical_name(domain_name)
    result = Basic_resolution_stub_module.basic_resolution_stub(domain_name)
    return result['canonical_name']
  end
end

