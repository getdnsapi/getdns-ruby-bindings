# edns_do_bit_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Edns_do_bit_module
  def self.edns_do_bit(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #value must between 0 to 255. default is 0
      "edns_do_bit" => 0,

      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }

    #creating context
    ctx = Getdns::Context.new(options)

    #calling lookup
    x = ctx.lookup(domain_name)
    "edns_do_bit result = #{ap x}"
  end
end
