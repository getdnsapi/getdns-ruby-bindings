# File: tc_getdns_edns_version.rb
require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/edns_version_module'

class Getdns_edns_version
  def test_getdns_edns_version_status(domain_name)
    x = Edns_version_module.edns_version(domain_name)
    return x['status']
  end

  def test_getdns_edns_version_canonical_name(domain_name)
    x = Edns_version_module.edns_version(domain_name)
    return x['canonical_name']
  end
end

