# File: tc_getdns_transport_option.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/stub_resolvers_module'

class Getdns_stub_resolvers
  def test_getdns_stub_resolvers_status(domain_name)
    result = Stub_resolvers_module.stub_resolvers(domain_name)
    return result['status']
  end

  def test_getdns_stub_resolvers_canonical_name(domain_name)
    result = Stub_resolvers_module.stub_resolvers(domain_name)
    return result['canonical_name']
  end
end

