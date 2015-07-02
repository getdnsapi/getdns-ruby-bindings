#async_hostname_module.rb
require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'
require 'awesome_print'
 
module Async_hostname_module
 def self.async_hostname(ip)
	options = { 
	    # option for stub resolver context
	     "stub" => true,
	    # upstream recursive servers
	    "upstreams" => [
			"8.8.8.8"
	    ],
	    #request timeout time in millis
	    "timeout" => 5000,
	}
	extensions = {
		#GETDNS_EXTENSION_TRUE = 1000
		"return_both_v4_and_v6" => GetdnsConstants::GETDNS_EXTENSION_TRUE, 
		"dnssec_return_status" =>GetdnsConstants::GETDNS_EXTENSION_TRUE,
	}

	eventBase = Getdns::create_event_base;
	ctx = Getdns::Context.new(eventBase,options)
	x = ctx.asynchostname(ip,self,:callback,eventBase)
	ctx.dispatch_event_base(eventBase)
end

 def self.callback(result)
 	 "Async hostname result = #{ap (result)}\n"
 end

end
#Async_hostname_module::async_hostname("8.8.8.8")
