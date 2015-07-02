# limit_outstanding_queries_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Limit_outstanding_queries_module
  def self.limit_outstanding_queries(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #default value is 0
      "limit_outstanding_queries" => 0,

      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],

    }
    #creating context
    ctx = Getdns::Context.new(options)

    #calling lookup
    x = ctx.lookup(domain_name)

    #awesome print
    "limit_outstanding_queries result = #{ap x}"
  end
end
