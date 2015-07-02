# add_warning_for_bad_dns_extension.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Add_warning_for_bad_dns_extension_module
  def self.add_warning_for_bad_dns_extension(domain_name)
    options = {
      # option for stub resolver context
      "stub" => true,
      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }

    extensions = {
      "add_warning_for_bad_dns" => GetdnsConstants::GETDNS_EXTENSION_TRUE
    }

    ctx = Getdns::Context.new(options)
    x = ctx.lookup(domain_name,extensions)

    #awesome print
    "add_warning_for_bad_dns_extension result = #{ap x}"
    return x
  end
end
