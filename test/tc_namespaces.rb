# File:  tc_namespaces.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/namespaces_module'

class Getdns_namespaces
  def test_getdns_namespaces_status(domain_name)
    result = Namespaces_module.namespaces(domain_name)
    return result['status']
  end

  def test_getdns_namespaces_canonical_name(domain_name)
    result = Namespaces_module.namespaces(domain_name)
    return result['canonical_name']
  end
end

