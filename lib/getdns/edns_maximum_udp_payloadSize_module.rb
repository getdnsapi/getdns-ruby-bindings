# edns_maximum_udp_payloadSize_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Edns_maximum_udp_payloadSize_module
  def self.edns_maximum_udp_payloadSize(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #default value is 0
      "edns_maximum_udp_payloadSize" => 0,

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
    "edns_maximum_udp_payloadSize result = #{ ap x}"
  end
end
