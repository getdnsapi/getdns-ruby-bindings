require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Getdns_lookup_with_options
  def self.basic_resolution_recursing(domain_name)
    #Setting options
    options = {
      #Timeout
      "timeout" => 1000,

      #return_dnssec_status
      "return_dnssec_status" => true,

      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }

    #creating context
    ctx = Getdns::Context.new(options)

    #calling lookup with GETDNS_RESOLUTION_RECURSING
    x = ctx.lookup(domain_name)

    #awesome print
    "basic_resolution_recursing result = #{ap x}"
  end
end