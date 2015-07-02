require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Getdns_general_with_options
  def self.basic_general_resolution_recursing(domain_name)
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

    x = ctx.general(domain_name, GetdnsConstants::GETDNS_RRTYPE_A)

    #awesome print
    "basic general resolution result = #{ap x}"
    return x
  end
end