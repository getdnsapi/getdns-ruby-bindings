require 'mkmf'


##look for the shared libraries. Raise error if not found. This happens before compile.
unless have_library('getdns')
  abort "lgetdns is missing.  please install and configure"
end

unless have_library('unbound')
  abort "lunbound is missing.  please install and configure"
end

unless have_library('idn')
  abort "lidn is missing.  please install and configure"
end

unless have_library('ldns')
  abort "lldns is missing.  please install and configure"
end

unless have_library('getdns_ext_event')
  abort "getdns_ext_event is missing.  please install and configure"
end

create_makefile('getdns/getdns')


