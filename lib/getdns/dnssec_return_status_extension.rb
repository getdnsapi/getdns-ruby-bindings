# dnssec_return_status_extension.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Dnssec_return_status_extension_module
  def self.dnssec_return_status_extension(domain_name)
    options = {
      # option for stub resolver context
      "stub" => true,
      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }
    extensions = {
      "dnssec_return_status" => GetdnsConstants::GETDNS_EXTENSION_TRUE
    }
    ctx = Getdns::Context.new(options)
    x = ctx.lookup(domain_name,extensions)
    "dnssec_return_status_extension result = #{ap x}"
  end
end
