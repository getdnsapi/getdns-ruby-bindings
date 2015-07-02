# edns_version_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Edns_version_module
  def self.edns_version(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #setting GETDNS_RESOLUTION_RECURSING
      "edns_version" => 0,

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
    "edns_version result = #{ap x}"
  end
end
