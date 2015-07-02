# namespaces_module.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Namespaces_module
  def self.namespaces(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #setting namespaces(GETDNS_NAMESPACE_DNS)
      "namespaces" => GetdnsConstants::GETDNS_NAMESPACE_DNS,

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
    "namespaces result = #{ap x}"
  end
end
