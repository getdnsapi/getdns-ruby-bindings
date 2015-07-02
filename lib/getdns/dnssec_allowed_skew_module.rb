# dnssec_allowed_skew_module.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Dnssec_allowed_skew_module
  def self.dnssec_allowed_skew(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #setting dnssec_allowed_skew
      "dnssec_allowed_skew" => GetdnsConstants::GETDNS_CONTEXT_CODE_DNSSEC_ALLOWED_SKEW,

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
    "dnssec_allowed_skew result = #{ap x}"
  end
end
