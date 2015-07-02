# File: tc_getdns_timeout.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/timeout_module'

class Getdns_timeout
  def test_getdns_timeout_status(domain_name)
    result = Timeout_module.timeout(domain_name)
    return result['status']
  end

  def test_getdns_timeout_canonical_name(domain_name)
    result = Timeout_module.timeout(domain_name)
    return result['canonical_name']
  end
end

