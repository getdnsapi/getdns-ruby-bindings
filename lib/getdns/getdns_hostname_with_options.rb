require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Getdns_hostname_with_options
  def self.basic_hostname_resolution(ip)
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
    x = ctx.hostname(ip)

    #awesome print
    "basic hostname resolution result = #{ ap x}"
  end
end