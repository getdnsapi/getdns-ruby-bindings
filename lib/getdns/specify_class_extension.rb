# specify_class_extension.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Specify_class_extension_module
  def self.specify_class_extension(domain_name)
    options = {
      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }

    extensions = {
      "specify_class" => 1
    }

    ctx = Getdns::Context.new(options)
    x = ctx.lookup(domain_name,extensions)

    #awesome print
    "add_warning_for_bad_dns_extension result = #{ap x}"
  end
end
