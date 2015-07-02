require 'getdns/getdns' # the c extension
require 'awesome_print'

module Getdns
  class Context
    def self.lookup
      ctx = Getdns::Context.new
      y = ctx.lookup("getdnsapi.net")
      puts "lookup result is #{ap y}"
    end
  end
end






