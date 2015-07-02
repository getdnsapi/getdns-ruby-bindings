# stub_resolvers_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Stub_resolvers_module
  def self.stub_resolvers(domain_name)
    options = {
      #option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => [
      "8.8.8.8"
      ],

      #request timeout time in millis
      "timeout" => 1000,

      #always return dnssec status
      "return_dnssec_status" => true
    }
    #create context
    ctx = Getdns::Context.new(options)

    #calling lookup
    x = ctx.lookup(domain_name)

    #awesome print
    "stub_resolvers result = #{ap x}\n"
  end
end
