# add_opt_parameters_extension.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Add_opt_parameters_extension_module
  def self.add_opt_parameters_extension(domain_name)
    options = {
      # option for stub resolver context
      "stub" => true,
      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }

    extensions = {
      "add_opt_parameters" => { "do_bit" => 1}
    }

    ctx = Getdns::Context.new(options)
    x = ctx.lookup(domain_name,extensions)

    #awesome print
    "add_opt_parameters result = #{ap x}"
  end
end
