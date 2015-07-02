# upstream_recursive_servers_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Upstream_recursive_servers_module
  def self.upstream_recursive_servers(domain_name)
    options = {
      #option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstream_recursive_servers" => [
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
    "upstream_recursive_servers result = #{ap x}\n"
  end
end
