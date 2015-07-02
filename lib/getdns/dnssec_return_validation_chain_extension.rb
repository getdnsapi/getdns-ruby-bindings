# dnssec_return_validation_chain_extension.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Dnssec_return_validation_chain_extension_module
  def self.dnssec_return_validation_chain(domain_name)
    options = {
      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"]
    }

    extensions = {
      "dnssec_return_validation_chain" => GetdnsConstants::GETDNS_EXTENSION_TRUE
    }

    ctx = Getdns::Context.new(options)
    x = ctx.lookup(domain_name,extensions)

    #awesome print
    "dnssec_return_validation_chain_extension result = #{ ap x}"
  end
end
