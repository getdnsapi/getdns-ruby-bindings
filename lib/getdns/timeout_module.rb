# timeout_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Timeout_module
  def self.timeout(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

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
    "Timeout result = #{ap x}"
  end
end
