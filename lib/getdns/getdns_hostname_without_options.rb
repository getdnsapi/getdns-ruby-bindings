require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Getdns_hostname_without_options
  def self.basic_hostname_resolution(ip)

    #creating context
    ctx = Getdns::Context.new()

    x = ctx.hostname(ip)

    #awesome print
    "basic hostname resolution result = #{ap x}"
    return x
  end
end