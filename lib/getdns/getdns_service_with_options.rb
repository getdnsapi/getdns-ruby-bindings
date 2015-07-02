require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Getdns_service_with_options
  def self.basic_service_resolution(domain_name)
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
    x = ctx.service(domain_name)

    #awesome print
    "basic service resolution result = #{ap x}"
  end
end