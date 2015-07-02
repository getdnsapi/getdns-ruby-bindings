require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Getdns_service_without_options
  def self.basic_service_resolution(domain_name)

    #creating context
    ctx = Getdns::Context.new()

    x = ctx.service(domain_name)

    #awesome print
    "basic service resolution result = #{ ap x}"
  end
end