# File:  ts_getdns.rb

require_relative "tc_getdns_transport"
require_relative "tc_stub_resolvers"
require_relative "tc_basic_resolution_stub"
require_relative "tc_timeout"
require_relative "tc_use_threads"
require_relative "tc_return_dnssec_status"
require_relative "tc_basic_resolution_recursing"
require_relative "tc_getdns_edns_extended_rcode"
require_relative "tc_getdns_edns_do_bit"
require_relative "tc_getdns_edns_version"
require_relative "tc_getdns_limit_outstanding_queries"
require_relative "tc_getdns_edns_maximum_udp_payloadSize"
require_relative "tc_namespaces"
require_relative "tc_follow_redirects"
require_relative "tc_dnssec_allowed_skew"
require_relative "tc_getdns_hostname"
require_relative "tc_getdns_lookup"
require_relative "tc_getdns_service"
require_relative "tc_getdns_general"
require_relative "tc_getdns_hostname_without_options"
require_relative "tc_getdns_lookup_without_options"
require_relative "tc_getdns_service_without_options"
require_relative "tc_getdns_general_without_options"
require_relative "tc_getdns_async_hostname"
require_relative "tc_getdns_async_lookup"
require_relative "tc_getdns_async_service"
require_relative "tc_getdns_async_general"
require_relative "tc_getdns_async_hostname_without_options"
require_relative "tc_getdns_async_lookup_without_options"
require_relative "tc_getdns_async_service_without_options"
require_relative "tc_getdns_async_general_without_options"
require_relative "tc_dnssec_return_status_extension"
require_relative "tc_dnssec_return_only_secure_extension"
require_relative "tc_dnssec_return_validation_chain_extension"
require_relative "tc_return_both_v4_and_v6_extension"
require_relative "tc_add_warning_for_bad_dns_extension"
require_relative "tc_specify_class_extension"
require_relative "tc_add_opt_parameters_extension"
require_relative "tc_getdns_constants"

require "test/unit"

class TestGetdns < Test::Unit::TestCase
 
  def test_getdns_transport_option
    assert_equal(TestGetdnsConstants::TRANSPORT_STATUS,Getdns_transport_option.new().test_getdns_transport_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_transport_option.new().test_getdns_transport_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_stub_resolvers
    assert_equal(TestGetdnsConstants::STUB_RESOLVERS_STATUS,Getdns_stub_resolvers.new().test_getdns_stub_resolvers_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_stub_resolvers.new().test_getdns_stub_resolvers_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_basic_resolution_stub
    assert_equal(TestGetdnsConstants::BASIC_RESOLUTION_STUB_STATUS,Getdns_basic_resolution_stub.new().test_getdns_basic_resolution_stub_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_basic_resolution_stub.new().test_getdns_basic_resolution_stub_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_timeout
    assert_equal(TestGetdnsConstants::TIMEOUT_STATUS,Getdns_timeout.new().test_getdns_timeout_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_timeout.new().test_getdns_timeout_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_use_threads
    assert_equal(TestGetdnsConstants::USE_THREADS_STATUS,Getdns_use_threads.new().test_getdns_use_threads_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_use_threads.new().test_getdns_use_threads_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_return_dnssec_status
    assert_equal(TestGetdnsConstants::RETERN_DNSSEC_STATUS,Getdns_return_dnssec_status.new().test_getdns_return_dnssec_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_return_dnssec_status.new().test_getdns_return_dnssec_status_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_basic_resolution_recursing
    assert_equal(TestGetdnsConstants::RESOLUTION_TYPE_STATUS,Getdns_basic_resolution_recursing.new().test_getdns_basic_resolution_recursing_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_basic_resolution_recursing.new().test_getdns_basic_resolution_recursing_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_edns_extended_rcode_option
    assert_equal(TestGetdnsConstants::STATUS,Getdns_edns_extended_rcode.new().test_getdns_edns_extended_rcode_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_edns_extended_rcode.new().test_getdns_edns_extended_rcode_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_edns_version_option
    assert_equal(TestGetdnsConstants::STATUS,Getdns_edns_version.new().test_getdns_edns_version_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_edns_version.new().test_getdns_edns_version_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_edns_do_bit_option
    assert_equal(TestGetdnsConstants::STATUS,Getdns_edns_do_bit.new().test_getdns_edns_do_bit_module_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_edns_do_bit.new().test_getdns_edns_do_bit_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_limit_outstanding_queries_option
    assert_equal(TestGetdnsConstants::STATUS,Getdns_limit_outstanding_queries.new().test_getdns_limit_outstanding_queries_module_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_limit_outstanding_queries.new().test_getdns_limit_outstanding_queries_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_edns_maximum_udp_payloadSize_option
    assert_equal(TestGetdnsConstants::STATUS,Getdns_edns_maximum_udp_payloadSize.new().test_getdns_edns_extended_rcode_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_edns_maximum_udp_payloadSize.new().test_getdns_edns_maximum_udp_payloadSize_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_namespaces_option
    assert_equal(TestGetdnsConstants::NAMESPACES_STATUS,Getdns_namespaces.new().test_getdns_namespaces_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_namespaces.new().test_getdns_namespaces_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_follow_redirect_option
    assert_equal(TestGetdnsConstants::FOLLOW_REDIRECT_STATUS,Getdns_follow_redirects.new().test_getdns_follow_redirects_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_follow_redirects.new().test_getdns_follow_redirects_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_dnssec_allowed_skew_option
    assert_equal(TestGetdnsConstants::DNSSEC_ALLOWED_STATUS,Getdns_dnssec_allowed_skew.new().test_getdns_dnssec_allowed_skew_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Getdns_dnssec_allowed_skew.new().test_getdns_dnssec_allowed_skew_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_lookup
    assert_equal(TestGetdnsConstants::LOOKUP_STATUS, GetDNSLookup.new().test_getdns_lookup_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSLookup.new().test_getdns_lookup_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_hostname
    assert_equal(TestGetdnsConstants::HOSTNAME_STATUS,GetdnsHostName.new().test_hostname_status(TestGetdnsConstants::IP))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetdnsHostName.new().test_hostname_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_service
    assert_equal(TestGetdnsConstants::SERVICE_STATUS,GetDNSService.new().test_getdns_service_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,GetDNSService.new().test_getdns_service_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_general
    assert_equal(TestGetdnsConstants::GENERAL_STATUS,GetDNSGeneral.new().test_getdns_general_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSGeneral.new().test_getdns_general_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_lookup_without_options
    assert_equal(TestGetdnsConstants::LOOKUP_STATUS, GetDNSLookup_without_options.new().test_getdns_lookup_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSLookup_without_options.new().test_getdns_lookup_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_hostname_without_options
    assert_equal(TestGetdnsConstants::HOSTNAME_STATUS,GetdnsHostName_without_options.new().test_hostname_status(TestGetdnsConstants::IP))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetdnsHostName_without_options.new().test_hostname_canonical_name(TestGetdnsConstants::IP))
  end

  def test_getdns_service_without_options
    assert_equal(TestGetdnsConstants::SERVICE_STATUS,GetDNSService_without_options.new().test_getdns_service_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSService_without_options.new().test_getdns_service_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_general_without_options
    assert_equal(TestGetdnsConstants::GENERAL_STATUS,GetDNSGeneral_without_options.new().test_getdns_general_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSGeneral_without_options.new().test_getdns_general_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_async_lookup
    assert_equal(TestGetdnsConstants::LOOKUP_STATUS, GetDNSAsyncLookup.new().test_getdns_async_lookup_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSAsyncLookup.new().test_getdns_async_lookup_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_async_hostname
    assert_equal(TestGetdnsConstants::HOSTNAME_STATUS,GetDNSAsyncHostName.new().test_getdns_async_hostname_status(TestGetdnsConstants::IP))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSAsyncHostName.new().test_getdns_async_hostname_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_async_service
    assert_equal(TestGetdnsConstants::SERVICE_STATUS,GetDNSAsyncService.new().test_getdns_async_service_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,GetDNSAsyncService.new().test_getdns_async_service_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end
  
  def test_getdns_async_general    
    assert_equal(TestGetdnsConstants::GENERAL_STATUS,GetDNSAsyncGeneral.new().test_getdns_async_general_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSAsyncGeneral.new().test_getdns_async_general_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_async_lookup_without_options
    assert_equal(TestGetdnsConstants::LOOKUP_STATUS, GetDNSAsyncLookup_without_options.new().test_getdns_async_lookup_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSAsyncLookup_without_options.new().test_getdns_async_lookup_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_async_hostname_without_options
    assert_equal(TestGetdnsConstants::HOSTNAME_STATUS,GetDNSAsyncHostName_without_options.new().test_getdns_async_hostname_status(TestGetdnsConstants::IP))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSAsyncHostName_without_options.new().test_getdns_async_hostname_canonical_name(TestGetdnsConstants::IP))
  end

  def test_getdns_async_service_without_options
    assert_equal(TestGetdnsConstants::SERVICE_STATUS,GetDNSAsyncService_without_options.new().test_getdns_async_service_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSAsyncService_without_options.new().test_getdns_async_service_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_async_general_without_options
    assert_equal(TestGetdnsConstants::GENERAL_STATUS,GetDNSAsyncGeneral_without_options.new().test_getdns_async_general_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME, GetDNSAsyncGeneral_without_options.new().test_getdns_async_general_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_dnssec_return_status_extension
    assert_equal(TestGetdnsConstants::DNSSEC_RETURN_STATUS_EXTENSION,Dnssec_return_status_extension.new().test_getdns_dnssec_return_status_extension_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Dnssec_return_status_extension.new().test_getdns_dnssec_return_status_extension_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_dnssec_return_only_secure_extension
    assert_equal(TestGetdnsConstants::DNSSEC_RETURN_ONLY_STATUS_EXTENSION,Dnssec_return_only_secure_extension.new().test_getdns_dnssec_return_only_secure_extension_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Dnssec_return_only_secure_extension.new().test_getdns_dnssec_return_only_secure_extension_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_dnssec_return_validation_chain_extension
    assert_equal(TestGetdnsConstants::DNSSEC_RETURN_VALIDATION_CHAIN_STATUS,Dnssec_return_validation_chain_extension.new().test_getdns_dnssec_return_validation_chain_extension_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Dnssec_return_validation_chain_extension.new().test_getdns_dnssec_return_validation_chain_extension_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_return_both_v4_and_v6_extension
    assert_equal(TestGetdnsConstants::RETURN_BOTH_V4_AND_V6_STATUS,Return_both_v4_and_v6_extension.new().test_getdns_return_both_v4_and_v6_extension_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Return_both_v4_and_v6_extension.new().test_getdns_return_both_v4_and_v6_extension_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_add_warning_for_bad_dns_extension
    assert_equal(TestGetdnsConstants::ADD_WARNING_FOR_BAD_DNS_STATUS,Add_warning_for_bad_dns_extension.new().test_getdns_dnssec_return_only_secure_extension_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Add_warning_for_bad_dns_extension.new().test_getdns_dnssec_return_only_secure_extension_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_specify_class_extension
    assert_equal(TestGetdnsConstants::SPECIFY_CLASS_STATUS,Specify_class_extension.new().test_getdns_specify_class_extension_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Specify_class_extension.new().test_getdns_specify_class_extension_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end

  def test_getdns_add_opt_parameters_extension
    assert_equal(TestGetdnsConstants::ADD_OPT_PARAMETERS_STATUS,Add_opt_parameters_extension.new().test_getdns_add_opt_parameters_extension_status(TestGetdnsConstants::DOMAIN_NAME))
    assert_equal(TestGetdnsConstants::CANONICAL_NAME,Add_opt_parameters_extension.new().test_getdns_add_opt_parameters_extension_canonical_name(TestGetdnsConstants::DOMAIN_NAME))
  end
end
