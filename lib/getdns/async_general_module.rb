#async_general_module.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'

module Async_general_module
 def self.async_general(domain_name)
	options = {
	    # option for stub resolver context
	     "stub" => true,
	    # upstream recursive servers
	    "upstreams" => [
			"8.8.8.8"
	    ],
	    #request timeout time in millis
	    "timeout" => 1000,
	}
	extensions = {
		#GETDNS_EXTENSION_TRUE = 1000
		"return_both_v4_and_v6" => GetdnsConstants::GETDNS_EXTENSION_TRUE, 
		"dnssec_return_status" =>GetdnsConstants::GETDNS_EXTENSION_TRUE,
	}

	eventBase = Getdns::create_event_base;
	ctx = Getdns::Context.new(eventBase,options)
	x = ctx.asyncgeneral(domain_name,GetdnsConstants::GETDNS_RRTYPE_A,self,:callback,eventBase)
	ctx.dispatch_event_base(eventBase)
end

 def self.callback(result)
	  "Async general result = #{ap (result)}\n"
 end

end
#Async_general_module::async_general("www.google.com")
