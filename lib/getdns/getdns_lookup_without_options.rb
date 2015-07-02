require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Getdns_lookup_without_options
  def self.basic_resolution_recursing(domain_name)

    #creating context
    ctx = Getdns::Context.new()

    #calling lookup with GETDNS_RESOLUTION_RECURSING
    x = ctx.lookup(domain_name)

    #awesome print
    "basic_resolution_recursing result = #{ap x}"
  end
end