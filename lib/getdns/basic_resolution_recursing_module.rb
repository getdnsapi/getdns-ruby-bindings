# basic_resolution_recursing.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Basic_resolution_recursing_module
  def self.basic_resolution_recursing(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #always return dnssec status
      "return_dnssec_status" => true,

      #setting resolution_type
      "resolution_type" => GetdnsConstants::GETDNS_RESOLUTION_RECURSING,

      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }

    #creating context
    ctx = Getdns::Context.new(options)

    #calling lookup
    x = ctx.lookup(domain_name)
    puts "#{x}"
    "basic_resolution_recursing result = #{ ap x}"
  end
end
