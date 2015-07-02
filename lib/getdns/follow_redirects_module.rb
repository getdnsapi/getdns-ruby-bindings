# follow_redirects_module.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Follow_redirects_module
  def self.follow_redirects(domain_name)
    options = {
      #request timeout time in millis
      "timeout" => 1000,

      "stub" => true,
      "upstreams" =>["8.8.8.8"],

      #setting follow_redirect (GETDNS_REDIRECTS_FOLLOW)
      "follow_redirects" => GetdnsConstants::GETDNS_REDIRECTS_FOLLOW,
    }

    #creating context
    ctx = Getdns::Context.new(options)

    #calling lookup
    x = ctx.lookup(domain_name)

    #awesome print
    "follow_redirects result = #{ap x}"
  end
end
