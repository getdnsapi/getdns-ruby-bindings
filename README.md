
# getdns-ruby-bindings  #

This document explains how to make Getdns extension for Ruby


## Installation and requirements

 * An installation of getdns 0.1.1 or later is required. Please see the https://github.com/getdnsapi/getdns GitHub.
 * Install Ruby
 * Then install bundler gem using command "gem install bundler". Bundler manages application dependencies and install into the gem library in your environment.

 Note: Please checkout Ruby Version Manager (RVM) https://rvm.io/


## Basic Knowledge 

In C, variables have types and data do not have types. Ruby is exactly opposite,
Ruby variables do not have a static type but data themselves have types, so data will need to converted between languages.

Data in Ruby are represented by the C type `VALUE'.  Each VALUE data
has its data-type.

To retrieve C data from a VALUE, you need to:
   *    Identify the VALUE's data type
   *    Convert the VALUE into C data

Encapsulate a C struct as a Ruby object. There are two macros to do this wrapping, and one to retrieve your structure back out again.
 *   Data_Wrap_Struct: Take a C level pointer and shoves into a VALUE. Data_Wrap_Struct() returns a created DATA object.
 *   Data_Get_Struct:  To retrieve the C pointer from the Data object, use the macro Data_Get_Struct(). Unwrap the ruby object as a data_type, and set data* to point to it.

#####Argument Checking
 *   rb_scan_args : It takes argc, argv, the number of required and optional arguments and pointers to the VALUE objects.

    It will raise a Ruby exception when argument count is not as expected.
    -   VALUE foo;
    -    VALUE optional;
    -    rb_scan_args(argc, argv, "11", &foo, &optional);
    -    "11" tell rb_scan_args expect one required, one optional

   *rb_scan_args(argc, argv, "01", &optional);*
    - "10" tell rb_scan_args expect one optional

## getdns ruby binding project structure 

```
getdns-ruby-bindings/  
    getdns.gemspec  
    Rakefile  
    ext/ 
        getdns/ 
            extconf.rb 
            *.cpp 
    lib/  
        getdns/  
            *.rb  
    test/
        tc_*.rb
```

##Ruby binding for getdns
####getdns configuration

 * Install all of the required gems using command - "bundle install"

```
$ rake build_ext
    /usr/bin/ruby extconf.rb
    checking for main() in -lgetdns... yes
    checking for main() in -lunbound... yes
    checking for main() in -lidn... yes
    checking for main() in -lldns... yes
    creating Makefile
    make
    linking shared-object getdns/getdns.so
    cp ext/getdns/getdns.bundle lib/
```
  * You can also execute "bundle install" after "rake build_ext"


#####From here on we can call getdns methods two ways
 1.
  - After command 'rake build_ext'. cd /ext/getdns. To run all sync functions, async functions, options and extensions implementations:

    ```
    ruby getdns.rb

    ```

  - Run all sync functions, options and extensions tests:

    ```
    rake test
    or
    ruby ts_getdns.rb

    ```

 - Run particular sync functions, async function, options/extensions implementations:(Require library before executing the script)

   ```
   ruby -r "./dns_transport_module.rb" -e "Dns_transport_module.dns_transport 'verisign.com'"

   ```

 - Run particular option/extensions Test:

    ```
    ruby -r "./tc_getdns_transport.rb" -e "Getdns_transport_option.new.test_getdns_transport_status 'verisign.com'"

    ```

 steps to add this extension as gem.

```
$ gem build getdns.gemspec
    Successfully built RubyGem
    Name: getdns-ruby
    Version: 0.0.1
    File: getdns-ruby-0.0.1.gem
```

```
$ sudo gem install ./getdns-ruby-0.0.1.gem
    Successfully installed getdns-ruby-0.0.1
    Parsing documentation for getdns-ruby-0.0.1
    Installing ri documentation for getdns-ruby-0.0.1
    Done installing documentation for getdns-ruby after 0 seconds
    1 gem installed
```
####Test gem and use:
Check if getdns_ruby gem is installed properly

```
$ irb 
    >> require 'getdns_ruby' 
    => true 
    >> ctx = Getdns::Context.new() 
    => #<Getdns::Context:0x00000001a9d700> 
    >> ctx.lookup("verisign.com") 
```

OR load gem directly using following command

```
irb -Ilib -rgetdns_ruby
```


#### Test some sample code
Note: Load the ruby shell(irb) from directory lib/getdns for running sample code.
There are couple of ways to play around with getdns-ruby gem.

1.
 - After gem installation testing  load any file for test. For example load 'dns_transport_module.rb'
 - Then invoke a method on a Ruby module

```
$ irb
    >> load './dns_transport_module.rb'
    => true
    >>  Dns_transport_module.dns_transport('any domain name')
```

2.
- Test code from .rb file

```
$ irb
    >> require_relative '../../ext/getdns/getdns'
    => true
    >> require_relative 'getdns_constants'
    => true
    >> options = {
             "timeout" => 10000,
             "return_dnssec_status" => true,
             "dns_transport" => GetdnsConstants::TRANSPORT_TCP_ONLY,
             "stub" => true,
             "upstreams" => ["8.8.8.8"],
           }
    => {"timeout"=>10000, "return_dnssec_status"=>true, "dns_transport"=>542, "stub"=>true, "upstreams"=>["8.8.8.8"]}
    >> ctx = Getdns::Context.new(options)
    => #<Getdns::Context:0x007ff4a9080e30>
    >>  x = ctx.lookup('verisign.com')
    => {"answer_type"=>800, "canonical_name"=>"verisign.com.", "just_address_answers"=>["69.58.181.89"], "replies_full"=>[[140688806169888], [140688806169968]],
       "replies_tree"=>[{"additional"=>[], "answer"=>[{"class"=>1, "name"=>"verisign.com.", "rdata"=>{"ipv4_address"=>"E:\xB5Y", "rdata_raw"=>"E:\xB5Y"}, "ttl"=>17,
        "type"=>1}], "answer_type"=>800, "authority"=>[], "canonical_name"=>"verisign.com.", "dnssec_status"=>403, "header"=>{"aa"=>0, "ad"=>0, "ancount"=>1,
         "arcount"=>0, "cd"=>0, "id"=>27467, "nscount"=>0, "opcode"=>0, "qdcount"=>1, "qr"=>1, "ra"=>1, "rcode"=>0, "rd"=>1, "tc"=>0, "z"=>0},
         "question"=>{"qclass"=>1, "qname"=>"verisign.com.", "qtype"=>1}}, {"additional"=>[], "answer"=>[],
         "answer_type"=>800, "authority"=>[{"class"=>1, "name"=>"verisign.com.", "rdata"=>{"expire"=>3600, "mname"=>"a2.nstld.com.",
         "rdata_raw"=>[140688806166784], "refresh"=>3600, "retry"=>1209600, "rname"=>"vshostmaster.verisign.com.", "serial"=>2011041162}, "ttl"=>738, "type"=>6}],
         "canonical_name"=>"verisign.com.", "dnssec_status"=>403, "header"=>{"aa"=>0, "ad"=>0, "ancount"=>0, "arcount"=>0, "cd"=>0, "id"=>26773, "nscount"=>1,
         "opcode"=>0, "qdcount"=>1, "qr"=>1, "ra"=>1, "rcode"=>0, "rd"=>1, "tc"=>0, "z"=>0}, "question"=>{"qclass"=>1, "qname"=>"verisign.com.", "qtype"=>28}}],
          "status"=>900}
```
