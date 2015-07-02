# File: tc_getdns_use_threads.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/use_threads_module'

class Getdns_use_threads
  def test_getdns_use_threads_status(domain_name)
    result = Use_threads_module.use_threads(domain_name)
    return result['status']
  end

  def test_getdns_use_threads_canonical_name(domain_name)
    result = Use_threads_module.use_threads(domain_name)
    return result['canonical_name']
  end
end

