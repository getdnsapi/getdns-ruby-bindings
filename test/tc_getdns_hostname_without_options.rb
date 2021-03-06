# File:  get_dns_extension.rb

require_relative '../ext/getdns/getdns'

class GetdnsHostName_without_options

def initialize
    @context = Getdns::Context.new()
end

def test_hostname_status(ip)
    result = @context.hostname(ip)
    return result['status']
end 

def test_hostname_canonical_name(ip)
    result= @context.hostname(ip)
    return result['canonical_name']
end

end

