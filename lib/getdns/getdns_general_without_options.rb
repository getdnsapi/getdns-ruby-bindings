require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Getdns_general_without_options
  def self.basic_general_resolution_recursing(domain_name)

    #creating context
    ctx = Getdns::Context.new()

    x = ctx.general(domain_name,GetdnsConstants::GETDNS_RRTYPE_A)

    #awesome print
    "basic general resolution result = #{ap x}"
  end
end