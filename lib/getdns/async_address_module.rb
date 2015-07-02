require_relative '../../ext/getdns/getdns'
require_relative 'getdns_constants'

module Async_address_module
 def self.async_address(domain_name)
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
	x = ctx.asyncaddress(domain_name,self,:callback,eventBase)
	ctx.dispatch_event_base(eventBase)
end

 def self.callback(result)
 	 print "Async address result = #{(result)}\n"
 end

end
#Async_address_module::async_address("www.google.com")
