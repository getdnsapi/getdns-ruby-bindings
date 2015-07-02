# return_dnssec_status_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Return_dnssec_status_module
  def self.return_dnssec_status(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #always return dnssec status
      "return_dnssec_status" => true,

      # option for stub resolver context
      "stub" => true,

      #upstream recursive servers
      "upstreams" => ["8.8.8.8"],
    }
    #create context
    ctx = Getdns::Context.new(options)

    #calling lookup
    x = ctx.lookup(domain_name)

    #awesome print
    "return_dnssec_status result = #{ap x}\n"
  end
end
