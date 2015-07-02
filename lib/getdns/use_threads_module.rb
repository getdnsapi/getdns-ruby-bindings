# use_threads_module.rb
require_relative '../../ext/getdns/getdns'
require 'awesome_print'

module Use_threads_module
  def self.use_threads(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      #use_threads
      "use_threads" => true,

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
    "use_threads result = #{ap x}\n"
  end
end
