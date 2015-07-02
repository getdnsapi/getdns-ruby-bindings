# dns_transport_module.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Dns_transport_module
  def self.dns_transport(canonical_name)
    options = {
      #request timeout time in millis
      "timeout" => 10000,
      #always return dnssec status
      "return_dnssec_status" => true,

      #setting dns transport
      "dns_transport" => GetdnsConstants::TRANSPORT_TCP_ONLY,

      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }
    #create context
    ctx = Getdns::Context.new(options)

    #calling lookup
    x = ctx.lookup(canonical_name)

    #awesome print
    "dns_transport result = #{ap x}\n"
  end
end
