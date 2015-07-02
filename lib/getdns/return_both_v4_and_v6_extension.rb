#return_both_v4_and_v6_extension.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Return_both_v4_and_v6_extension_module
  def self.return_both_v4_and_v6_extension(domain_name)
    options = {
      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }

    extensions = {
      "return_both_v4_and_v6" => GetdnsConstants::GETDNS_EXTENSION_TRUE
    }

    ctx = Getdns::Context.new(options)
    x = ctx.lookup(domain_name,extensions)

    #awesome print
    "return_both_v4_and_v6_extension result = #{ap x}"
  end
end
