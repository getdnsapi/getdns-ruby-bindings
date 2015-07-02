# File:  tc_follow_redirect.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/follow_redirects_module'

class Getdns_follow_redirects
  def test_getdns_follow_redirects_status(domain_name)
    result = Follow_redirects_module.follow_redirects(domain_name)
    return result['status']
  end

  def test_getdns_follow_redirects_canonical_name(domain_name)
    result = Follow_redirects_module.follow_redirects(domain_name)
    return result['canonical_name']
  end
end

