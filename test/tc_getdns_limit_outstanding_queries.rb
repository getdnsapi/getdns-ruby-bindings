# File: tc_getdns_limit_outstanding_queries.rb
require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/limit_outstanding_queries_module'

class Getdns_limit_outstanding_queries
  def test_getdns_limit_outstanding_queries_module_status(domain_name)
    x = Limit_outstanding_queries_module.limit_outstanding_queries(domain_name)
    return x['status']
  end

  def test_getdns_limit_outstanding_queries_canonical_name(domain_name)
    x = Limit_outstanding_queries_module.limit_outstanding_queries(domain_name)
    return x['canonical_name']
  end
end

