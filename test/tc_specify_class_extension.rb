# File:  tc_specify_class_extension.rb

require_relative '../ext/getdns/getdns'
require_relative '../lib/getdns/specify_class_extension'

class Specify_class_extension
  def test_getdns_specify_class_extension_status(domain_name)
    result = Specify_class_extension_module.specify_class_extension(domain_name)
    return result['status']
  end

  def test_getdns_specify_class_extension_canonical_name(domain_name)
    result = Specify_class_extension_module.specify_class_extension(domain_name)
    return result['canonical_name']
  end
end

