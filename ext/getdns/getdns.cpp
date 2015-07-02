/*
 * Copyright (c) 2014, Verisign, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * * Neither the names of the copyright holders nor the
 *   names of its contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Verisign, Inc. BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

extern "C" {
#include <ruby.h>
#include <ctype.h>
#include <ruby/st.h>
#include <ruby/intern.h>
#include <GNUtil.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <getdns/getdns_extra.h>
#include <getdns/getdns.h>
#include <event.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <getdns/getdns_ext_libevent.h>
#include <event.h>

#define UNUSED_PARAM(x) ((void)(x))

static VALUE mGetdns;
static VALUE cContext;

static VALUE
convertTorubyHash(struct getdns_dict* dict);

// Taken from getdns source to do label checking
static int
priv_getdns_bindata_is_dname(struct getdns_bindata *bindata) {
	size_t i = 0, n_labels = 0;
	while (i < bindata->size) {
		i += ((size_t)bindata->data[i]) + 1;
		n_labels++;
	}
	return i == bindata->size && n_labels > 1 &&
	bindata->data[bindata->size - 1] == 0;
}

//Convert bindata into a good representational string
//and an ip address if it is under a known key
static VALUE
convertBinData(getdns_bindata* data, const char* key) {
	VALUE printable = Qtrue;
	size_t i = 0;
	for (i = 0; i < data->size; ++i) {
		if (!isprint(data->data[i])) {
			if (data->data[i] == 0 &&
					i == data->size - 1) {
				break;
			}
			printable = Qfalse;
			break;
		}
	}
	// basic string?
	if(printable) {
		return rb_str_new2((char*) data->data);
	} else if (data->size == 1 && data->data[0] == 0) {
		return rb_str_new2(".");
	} else if (priv_getdns_bindata_is_dname(data)) {
		char* dname = NULL;
		if (getdns_convert_dns_name_to_fqdn(data, &dname)== GETDNS_RETURN_GOOD) {
				VALUE result = rb_str_new2(dname);
				free(dname);
				return result;
			}
			// ip address
		} else if (key != NULL && (strcmp(key, "ipv4_address") == 0 ||
						strcmp(key, "ipv6_address") == 0)) {
			char* ipStr = getdns_display_ip_address(data);
			if (ipStr) {
				VALUE result = rb_str_new2(ipStr);
				free(ipStr);
				return result;
			}
		} else {
			// getting here implies we don't know how to convert it to a string.
			VALUE array = rb_ary_new2(data->size);
			rb_ary_push(array, INT2FIX(data->data));
			return array;
		}
	}

	static VALUE
	convertToJSArray(struct getdns_list* list) {
		if (!list) {
			return NULL;
		}
		size_t len;
		size_t i = 0;
		getdns_list_get_length(list, &len);
		VALUE array = rb_ary_new2(len);
		for (i = 0; i < len; ++i) {
			getdns_data_type type;
			getdns_list_get_data_type(list, i, &type);
			switch (type) {
				case t_bindata: {
					getdns_bindata* data = NULL;
					getdns_list_get_bindata(list, i, &data);
					rb_ary_store(array, i, convertBinData(data, NULL));
					break;
				}
				case t_int: {
					uint32_t res = 0;
					getdns_list_get_int(list, i, &res);
					rb_ary_store(array,i, UINT2NUM(res));
					break;
				}
				case t_dict: {
					getdns_dict* dict = NULL;
					getdns_list_get_dict(list, i, &dict);
					rb_ary_store(array, i, convertTorubyHash(dict));
					break;
				}
				case t_list: {
					getdns_list* sublist = NULL;
					getdns_list_get_list(list, i, &sublist);
					rb_ary_store(array, i, convertToJSArray(sublist));
					break;
				}
				default:
				break;
			}
		}
		return array;
	}

// potential helper to get the ip string of a dict
	char* getdns_dict_to_ip_string(getdns_dict* dict) {
		if (!dict) {
			return NULL;
		}
		getdns_bindata* data;
		getdns_return_t r;
		r = getdns_dict_get_bindata(dict, "address_type", &data);
		if (r != GETDNS_RETURN_GOOD) {
			return NULL;
		}
		if (data->size == 5 && (strcmp("IPv4", (char*) data->data) == 0 ||
						strcmp("IPv6", (char*) data->data) == 0)) {
			r = getdns_dict_get_bindata(dict, "address_data", &data);
			if (r != GETDNS_RETURN_GOOD) {
				return NULL;
			}
			return getdns_display_ip_address(data);
		}
		return NULL;
	}

	static VALUE
	convertTorubyHash(struct getdns_dict* dict) {
		if (!dict) {
			return NULL;
		}
		// try it as an IP
		char* ipStr = getdns_dict_to_ip_string(dict);
		if (ipStr) {
			VALUE result = rb_str_new2(ipStr);
			free(ipStr);
			return result;
		}
		getdns_list* names;
		getdns_dict_get_names(dict, &names);
		size_t len = 0;
		size_t i = 0;
		VALUE result = rb_hash_new();
		getdns_list_get_length(names, &len);
		for (i = 0; i < len; ++i) {
			getdns_bindata* nameBin;
			getdns_list_get_bindata(names, i, &nameBin);
			VALUE name = rb_str_new2((char*)nameBin->data);
			getdns_data_type type;
			getdns_dict_get_data_type(dict, (char*)nameBin->data, &type);
			switch (type) {
				//this bindata is breaking.
				case t_bindata: {
					getdns_bindata* data = NULL;
					getdns_dict_get_bindata(dict, (char*)nameBin->data, &data);
					rb_hash_aset(result, name, convertBinData(data, (char*) nameBin->data));
					break;
				}
				case t_int: {
					uint32_t res = 0;
					getdns_dict_get_int(dict, (char*)nameBin->data, &res);
					rb_hash_aset(result, name, UINT2NUM(res));
					break;
				}
				case t_dict: {
					getdns_dict* subdict = NULL;
					getdns_dict_get_dict(dict, (char*)nameBin->data, &subdict);
					rb_hash_aset(result, name, convertTorubyHash(subdict));
					break;
				}
				case t_list: {
					getdns_list* list = NULL;
					getdns_dict_get_list(dict, (char*)nameBin->data, &list);
					rb_hash_aset(result, name, convertToJSArray(list));
					break;
				}
			}
		}
		getdns_list_destroy(names);
		return result;
	}

	static getdns_dict* getdns_util_create_ip(const char* ip) {
		getdns_return_t r;
		const char* ipType;
		getdns_bindata ipData;
		uint8_t addrBuff[16];
		size_t addrSize = 0;
		getdns_dict* result = NULL;
		if(!ip) {
			return NULL;
		}
		// convert to bytes
		if(inet_pton(AF_INET, ip, &addrBuff) == 1) {
			addrSize = 4;
		} else if (inet_pton(AF_INET6, ip, &addrBuff) == 1) {
			addrSize = 16;
		}
		if(addrSize == 0) {
			return NULL;
		}
		// create the dict
		result = getdns_dict_create();
		if (!result) {
			return NULL;
		}
		// set fields
		ipType = addrSize == 4 ? "IPv4" : "IPv6";
		r = getdns_dict_util_set_string(result, (char*) "address_type", ipType);
		if (r != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(result);
			return NULL;
		}
		ipData.data = addrBuff;
		ipData.size = addrSize;
		r = getdns_dict_set_bindata(result, "address_data", &ipData);
		if (r != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(result);
			return NULL;
		}
		return result;
	}

	struct GetdnsContextWrap {
		getdns_context* ctx;
	};

	static void
	getdns_context_wrap_free(GetdnsContextWrap* p) {
		struct GetdnsContextWrap *ptr = p;
		if (ptr->ctx) {
			getdns_context_destroy(ptr->ctx);
			ptr->ctx = NULL;
		}
		free(ptr);
	}

	static VALUE
	getdnsruby_context_alloc(VALUE klass) {
		VALUE obj;
		struct GetdnsContextWrap* ptr = (struct GetdnsContextWrap*)malloc(sizeof(struct GetdnsContextWrap));
		ptr->ctx = NULL;
		obj = Data_Wrap_Struct(klass, 0, getdns_context_wrap_free, ptr);
		return obj;
	}

// Setter functions
	typedef getdns_return_t (*getdns_context_uint8_t_setter)(getdns_context*, uint8_t);
	typedef getdns_return_t (*getdns_context_uint16_t_setter)(getdns_context*, uint16_t);

	static void setTransport(getdns_context* context, VALUE opt) {
		if((TYPE(opt) == T_FIXNUM)) {
			uint32_t num = NUM2UINT(opt);
			getdns_context_set_dns_transport(context, (getdns_transport_t) num);
		}
	}

	static void setResolutionType(getdns_context *context, VALUE opt) {
		if(TYPE(opt) == T_FIXNUM) {
			uint32_t num = NUM2UINT(opt);
			getdns_context_set_resolution_type(context,(getdns_resolution_t)num);
		}
	}

	static void setStub(getdns_context* context, VALUE opt) {
		if(TYPE(opt) == T_TRUE) {
			getdns_context_set_resolution_type(context, GETDNS_RESOLUTION_STUB);
		} else {
			getdns_context_set_resolution_type(context, GETDNS_RESOLUTION_RECURSING);
		}
	}

	static void setUpstreams(getdns_context* context, VALUE opt) {
		if(TYPE(opt) == T_ARRAY) {
			getdns_list* upstreams = getdns_list_create();
			VALUE arr = rb_ary_new();
			rb_ary_push(arr, opt);
			for (uint32_t i = 0; i < RARRAY_LEN(arr); ++i) {
				VALUE ipOrTuple = rb_ary_entry(arr, i);
				getdns_dict* ipDict = NULL;
				if (TYPE(ipOrTuple) == T_ARRAY) {
					VALUE tuple = rb_ary_new();
					rb_ary_push(tuple, ipOrTuple);
					if (RARRAY_LEN(tuple) > 0) {
						VALUE str = rb_ary_entry(tuple, 0);
						VALUE sec_arr = rb_ary_entry(str, 0);
						char *asciiStr = StringValueCStr(sec_arr);
						ipDict = getdns_util_create_ip(asciiStr);
						if (ipDict && RARRAY_LEN(tuple) > 1 ) {						
							// port
							VALUE v = rb_ary_entry(tuple, 1);
							//uint32_t port = UINT2NUM(v);
							uint32_t port = FIX2UINT(v);						
							//uint32_t port = UINT2NUM(tuple[1]);
							getdns_dict_set_int(ipDict, "port", port);
						}
					}
				} else {
					//VALUE asciiStr = StringValue(ipOrTuple);
					char *asciiStr = StringValueCStr(ipOrTuple);
					ipDict = getdns_util_create_ip(asciiStr);
				}
				if (ipDict) {
					size_t len = 0;
					getdns_list_get_length(upstreams, &len);
					getdns_list_set_dict(upstreams, len, ipDict);
					getdns_dict_destroy(ipDict);
				}
			}
			getdns_return_t r = getdns_context_set_upstream_recursive_servers(context, upstreams);
			getdns_list_destroy(upstreams);
			if (r != GETDNS_RETURN_GOOD) {
				rb_raise(rb_eNoMemError, "Failed to create context.");
			}
		}
	}

	static void setTimeout(getdns_context* context, VALUE opt) {
		if (TYPE(opt) == T_FIXNUM) {
			uint32_t num = NUM2UINT(opt);
			getdns_context_set_timeout(context, num);
		}
	}

	static void setUseThreads(getdns_context* context, VALUE opt) {
		int val = (TYPE(opt) == T_TRUE) ? 1 : 0;
		getdns_context_set_use_threads(context, val);
	}

	static void setReturnDnssecStatus(getdns_context* context, VALUE opt) {
		int val = (TYPE(opt) == T_TRUE) ? GETDNS_EXTENSION_TRUE : GETDNS_EXTENSION_FALSE;
		getdns_context_set_return_dnssec_status(context, val);
	}

	static void context_set_namespaces(getdns_context* context, VALUE opt) {
		size_t count;
		getdns_namespace_t *namespaces;
		getdns_return_t ret;
		uint32_t i;
		if (TYPE(opt) == T_ARRAY) {
			if((count = RARRAY_LEN(opt)) != 0) {
				VALUE arr = rb_ary_new();
				rb_ary_push(arr, opt);
				if((namespaces = (getdns_namespace_t *) malloc(sizeof(getdns_namespace_t) * count)) != 0) {
					for(i = 0; i < count; i++) {
						namespaces[i] = (getdns_namespace_t)NUM2LONG(rb_ary_entry(opt,i));
					}
				}
				ret = getdns_context_set_namespaces(context, count, namespaces);
				if(ret != GETDNS_RETURN_GOOD) {
					rb_raise(rb_eNoMemError, "Failed to create context.");
				}
			}
		}
	}

	static void context_set_follow_redirects(getdns_context *context, VALUE opt) {
		getdns_return_t ret;
		uint64_t value;
		if (TYPE(opt) == T_FIXNUM) {
			value = NUM2LONG(opt);
			ret = getdns_context_set_follow_redirects(context, (getdns_redirects_t)value);
			if(ret != GETDNS_RETURN_GOOD) {
				rb_raise(rb_eNoMemError, "Failed to create context.");
			}
		}
	}

	static void context_set_dnssec_allowed_skew(getdns_context *context, VALUE opt) {
		getdns_return_t ret;
		uint32_t value;
		if (TYPE(opt) == T_FIXNUM) {
			value = (uint32_t)NUM2LONG(opt);
			if ((ret = getdns_context_set_dnssec_allowed_skew(context, value)) != GETDNS_RETURN_GOOD) {
				rb_raise(rb_eNoMemError, "Failed to create context.");
			}
		}
	}

	typedef void (*context_setter)(getdns_context* context, VALUE opt);

	typedef struct OptionSetter {
		const char* opt_name;
		context_setter setter;
	}SetOptions;

	static SetOptions SETTERS[] = {
		{	"stub", setStub},
		{	"upstreams", setUpstreams},
		{	"timeout", setTimeout},
		{	"use_threads", setUseThreads},
		{	"return_dnssec_status", setReturnDnssecStatus},
		{	"dns_transport", setTransport},
		{	"resolution_type", setResolutionType},
		{	"upstream_recursive_servers", setUpstreams},
		{	"namespaces",context_set_namespaces},
		{	"follow_redirects",context_set_follow_redirects},
		{	"dnssec_allowed_skew",context_set_dnssec_allowed_skew}
	};

	static size_t NUM_SETTERS = sizeof(SETTERS) / sizeof(OptionSetter);

	typedef struct Uint8OptionSetter {
		const char* opt_name;
		getdns_context_uint8_t_setter setter;
	}Uint8OptionSetter;

	static Uint8OptionSetter UINT8_OPTION_SETTERS[] = {
		{	"edns_extended_rcode", getdns_context_set_edns_extended_rcode},
		{	"edns_version", getdns_context_set_edns_version},
		{	"edns_do_bit", getdns_context_set_edns_do_bit}
	};

	static size_t NUM_UINT8_SETTERS = sizeof(UINT8_OPTION_SETTERS) / sizeof(Uint8OptionSetter);

	typedef struct Uint16OptionSetter {
		const char* opt_name;
		getdns_context_uint16_t_setter setter;
	}Uint16OptionSetter;

	static Uint16OptionSetter UINT16_OPTION_SETTERS[] = {
		{	"limit_outstanding_queries", getdns_context_set_limit_outstanding_queries},
		{	"edns_maximum_udp_payloadSize", getdns_context_set_edns_maximum_udp_payload_size}
	};

	static size_t NUM_UINT16_SETTERS = sizeof(UINT16_OPTION_SETTERS) / sizeof(Uint16OptionSetter);

	typedef int (*rb_foreach_func) (ANYARGS);

	static int do_print(VALUE key, VALUE value, VALUE ary) {
		rb_ary_push(ary, key);
		return ST_CONTINUE;
	}

	static int do_value(VALUE key, VALUE value, VALUE ary) {
		rb_ary_push(ary, value);
		return ST_CONTINUE;
	}

// set options on the context
	void applyOptions(VALUE self, VALUE opts) {
		struct GetdnsContextWrap *ptr;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		if(!ptr->ctx) {
			return;
		}
		if(!GNUtil::isDictionaryObject(opts)) {
			return;
		}
		if(!NIL_P(opts)) {
			if (TYPE(opts) != T_HASH) {
				rb_raise(rb_eNoMemError, "Failed to create context.");
			} else {
				VALUE ary;
				ary = rb_ary_new();
				rb_hash_foreach(opts, (rb_foreach_func) do_print, ary);
				size_t s = 0;
				// Walk the SETTERS array
				for(unsigned int i = 0; i < RHASH_SIZE(opts); i++) {
					VALUE str = rb_ary_entry(ary, i);
					char *name = StringValueCStr(str);
					VALUE opt = rb_hash_aref(opts, rb_str_new2(name));
					bool found = false;
					for (s = 0; s < NUM_SETTERS && !found; ++s) {
						if (strcmp(SETTERS[s].opt_name, name) == 0) {
							SETTERS[s].setter(ptr->ctx, opt);
							found = true;
							break;
						}
					}
					for (s = 0; s < NUM_UINT8_SETTERS && !found; ++s) {
						if (strcmp(UINT8_OPTION_SETTERS[s].opt_name, name) == 0) {
							found = true;
							uint32_t optVal = FIX2INT(opt);
							UINT8_OPTION_SETTERS[s].setter(ptr->ctx, (uint8_t)optVal);
						}
					}
					for (s = 0; s < NUM_UINT16_SETTERS && !found; ++s) {
						if (strcmp(UINT16_OPTION_SETTERS[s].opt_name, name) == 0) {
							found = true;
							uint32_t optVal = FIX2INT(opt);
							UINT16_OPTION_SETTERS[s].setter(ptr->ctx, (uint16_t)optVal);
						}
					}
				}
			}
		}
	};

	typedef struct event_base *eventBase;

	static eventBase create_event_base() {
		struct event_base *eventbase = event_base_new();
		if(eventbase == NULL) {
			return NULL;
		} else {
			return eventbase;
		}
	}

	static VALUE getdnsruby_context_initialize(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		getdns_return_t created = getdns_context_create(&ptr->ctx, 1);
		VALUE options = NULL;
		struct event_base *eventBase;	
		if(argc==1)
		{
			if((TYPE(argv[0]) == T_HASH))
			{			
				rb_scan_args(argc, argv, "01",&options);
				if (RHASH_SIZE(options) > 0) {
					applyOptions(self, options);
				}
			}
			else
			{
				rb_scan_args(argc, argv, "01",&eventBase);
				if(eventBase!=NULL) {
					(void)getdns_extension_set_libevent_base(ptr->ctx,eventBase);
				}
			}
		}
		else if(argc==2)
		{
			rb_scan_args(argc, argv, "02",&eventBase,&options);
			if((TYPE(options) == T_HASH)) {				
				if (RHASH_SIZE(options) > 0) {
					applyOptions(self, options);					
				}
			}
			if(eventBase!=NULL) {			
				(void)getdns_extension_set_libevent_base(ptr->ctx,eventBase);			
			}

		}
		else if(argc>2)
		rb_raise(rb_eArgError, "Wrong number of arguments");

		if (created != GETDNS_RETURN_GOOD) {
			rb_raise(rb_eNoMemError, "Failed to create context.");
		}
		return self;
	}

	static getdns_dict* get_extension(VALUE extensions) {
		getdns_return_t ret;
		VALUE ext_array;
		getdns_dict* ext_parameters;
		ext_array = rb_ary_new();
		rb_hash_foreach(extensions,(rb_foreach_func) do_print, ext_array);
		ext_parameters = getdns_dict_create();
		for(unsigned int i =0; i<RHASH_SIZE(extensions);i++) {
			VALUE ext_name = rb_ary_entry(ext_array,i);
			const char *extname = StringValueCStr(ext_name);
			VALUE ext_value = rb_hash_aref(extensions,rb_str_new2(extname));
			if (TYPE(ext_value) == T_FIXNUM) {
				uint32_t extvalue = NUM2UINT(ext_value);
				ret = getdns_dict_set_int(ext_parameters,extname,extvalue);
				if(ret!=GETDNS_RETURN_GOOD) {
					getdns_dict_destroy(ext_parameters);
					return NULL;
				}
			}
			else if (TYPE(ext_value) == T_ARRAY) {
				getdns_list* optvalue = getdns_list_create();
				for(unsigned int j =0; j<RARRAY_LEN(ext_value);j++)
				{
					VALUE opt = rb_ary_entry(ext_value,j);
					if (TYPE(opt) == T_FIXNUM) {
						uint32_t options_val = NUM2UINT(opt);
						getdns_list_set_int(optvalue, j, options_val);
					}
					else if (TYPE(opt) ==T_ARRAY) {
						if(RARRAY_LEN(opt) == 2) {
							struct getdns_bindata bindata;
							bindata.size = (size_t) NUM2INT(rb_ary_entry(opt,0));
							bindata.data =(uint8_t *) NUM2UINT(rb_ary_entry(opt,1));
							struct getdns_bindata *bin = &bindata;
							getdns_list_set_bindata(optvalue, j, bin);
						}
					}
				}
				ret = getdns_dict_set_list(ext_parameters,extname,optvalue);
				if(ret!=GETDNS_RETURN_GOOD) {
					getdns_dict_destroy(ext_parameters);
					return NULL;
				}
			} else if (TYPE(ext_value) == T_HASH) {
				getdns_dict* dictvalue = get_extension(ext_value);
				ret = getdns_dict_set_dict(ext_parameters,extname,dictvalue);
				if(ret!=GETDNS_RETURN_GOOD) {
					getdns_dict_destroy(ext_parameters);
					return NULL;
				}
			}
		}
		return ext_parameters;
	}

	static VALUE
	getdnsruby_context_lookup(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		VALUE name = NULL, extensions;
		getdns_dict* response = NULL;
		getdns_return_t gres;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		if(!ptr->ctx) {
			return Qfalse;
		}
		if (argc > 2 || argc == 0) { // there should only be 1 or 2 arguments
			rb_raise(rb_eArgError, "Wrong number of arguments");
		}
		rb_scan_args(argc, argv, "11",&name,&extensions);
		VALUE nameStr = StringValue(name);
		if(argc > 1) {
			if (RHASH_SIZE(extensions) > 0) {
				getdns_dict* this_extensions = get_extension(extensions);
				gres = getdns_address_sync(ptr->ctx, RSTRING_PTR(nameStr), this_extensions, &response);
			}
		} else {
			gres = getdns_address_sync(ptr->ctx, RSTRING_PTR(nameStr), NULL, &response);
		}
		if(gres != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(response);
			return Qfalse;
		}
		VALUE result = convertTorubyHash(response);
		getdns_dict_destroy(response);
		return result;
	}

	static VALUE
	getdnsruby_context_hostname(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		VALUE hostname = NULL, extensions;
		getdns_dict* response = NULL;
		getdns_return_t gres_h;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		if (!ptr-> ctx) {
			return Qfalse;
		}
		if (argc > 2 || argc == 0) { // there should only be 1 or 2 arguments
			rb_raise(rb_eArgError, "Wrong number of arguments");
		}
		rb_scan_args(argc, argv, "11",&hostname,&extensions);
		VALUE hostnameStr = StringValue(hostname);
		getdns_dict* ip = getdns_util_create_ip(RSTRING_PTR(hostnameStr));
		if (argc > 1) {
			if (RHASH_SIZE(extensions) > 0) {
				getdns_dict* this_extensions = get_extension(extensions);
				gres_h = getdns_hostname_sync(ptr->ctx, ip, this_extensions, &response);
			}
		} else {
			gres_h = getdns_hostname_sync(ptr->ctx, ip, NULL, &response);
		}
		if (gres_h != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(response);
			return Qfalse;
		}
		VALUE result = convertTorubyHash(response);
		getdns_dict_destroy(response);
		return result;
	}

	static VALUE
	getdnsruby_context_service(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		VALUE servicename = NULL, extensions;
		getdns_dict* response = NULL;
		getdns_return_t gres;
		if (!ptr-> ctx) {
			return Qfalse;
		}
		if (argc > 2 || argc == 0) { // there should only be 1 or 2 arguments
			rb_raise(rb_eArgError, "Wrong number of arguments");
		}
		rb_scan_args(argc, argv, "11",&servicename,&extensions);
		VALUE servicenameStr = StringValue(servicename);
		if (argc > 1) {
			if (RHASH_SIZE(extensions) > 0) {
				getdns_dict* this_extensions = get_extension(extensions);
				gres = getdns_service_sync(ptr->ctx, RSTRING_PTR(servicenameStr), this_extensions, &response);
			}
		} else {
			gres = getdns_service_sync(ptr->ctx, RSTRING_PTR(servicenameStr), NULL, &response);
		}
		if (gres != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(response);
			return Qfalse;
		}
		VALUE result = convertTorubyHash(response);
		getdns_dict_destroy(response);
		return result;
	}

	static VALUE
	getdnsruby_context_general(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		VALUE generalname = NULL, extensions;
		getdns_dict* response = NULL;
		getdns_return_t greg;
		VALUE rrtype;
		if (!ptr-> ctx) {
			return Qfalse;
		}
		if (argc > 3 || argc < 2) { // there should only be 1 or 2 arguments
			rb_raise(rb_eArgError, "Wrong number of arguments");
		}
		rb_scan_args(argc, argv, "21",&generalname,&rrtype,&extensions);
		VALUE generalnameStr = StringValue(generalname);
		int rr = NUM2INT(rrtype);
		if (argc > 2) {
			if (RHASH_SIZE(extensions) > 0) {
				getdns_dict* this_extensions = get_extension(extensions);
				greg = getdns_general_sync(ptr->ctx, RSTRING_PTR(generalnameStr), rr, this_extensions, &response);
			}
		} else {
			greg = getdns_general_sync(ptr->ctx, RSTRING_PTR(generalnameStr),rr, NULL, &response);
		}
		if (greg != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(response);
			return Qfalse;
		}
		VALUE result = convertTorubyHash(response);
		getdns_dict_destroy(response);
		return result;
	}

	static void this_callbackfn(getdns_context *this_context,
			getdns_callback_type_t this_callback_type,
			getdns_dict *this_response,
			void *this_userarg,
			getdns_transaction_t this_transaction_id) {
		VALUE userarg= (VALUE)this_userarg;
		VALUE callback = rb_ary_entry(userarg, 0);
		VALUE obj = rb_ary_entry(userarg, 1);
		UNUSED_PARAM(this_context);
		getdns_return_t this_ret;
		if (this_callback_type == GETDNS_CALLBACK_COMPLETE) {
			uint32_t this_error;
			this_ret = getdns_dict_get_int(this_response, "status", &this_error);
			if (this_error != GETDNS_RESPSTATUS_GOOD) {
				fprintf(stderr, "The search had no results, and a return value of %d. Exiting.\n", this_error);
				getdns_dict_destroy(this_response);
			}
			VALUE result = convertTorubyHash(this_response);

			rb_funcall(obj, rb_to_id(callback), 1,result);
		}
	}

	static VALUE
	getdnsruby_context_async_address(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		VALUE name = NULL, extensions;
		getdns_return_t gres;
		VALUE callback;
		VALUE obj;
		if (!ptr-> ctx) {
			return Qfalse;
		}
		struct event_base *this_event_base;  
		if (argc > 5 || argc == 0) { // there should only be 1 or 2 arguments
			rb_raise(rb_eArgError, "Wrong number of arguments");
		}
		rb_scan_args(argc, argv, "41",&name,&obj,&callback,&this_event_base,&extensions);
		if (rb_class_of(callback) != rb_cSymbol)
		rb_raise(rb_eTypeError, "Expected Symbol callbackack");
		VALUE this_userarg = rb_ary_new();
		rb_ary_store(this_userarg,0,callback);
		rb_ary_store(this_userarg,1,obj);
		getdns_transaction_t this_transaction_id = 0;
		VALUE nameStr = StringValue(name);
		if(argc > 4) {
			if (RHASH_SIZE(extensions) > 0) {
				getdns_dict* this_extensions = get_extension(extensions);
				gres = getdns_address(ptr->ctx, RSTRING_PTR(nameStr), this_extensions, (void *)this_userarg, &this_transaction_id, this_callbackfn);
			}
		}
		else {
			gres = getdns_address(ptr->ctx, RSTRING_PTR(nameStr), NULL, (void *)this_userarg, &this_transaction_id, this_callbackfn);
		}
		if(gres != GETDNS_RETURN_GOOD) {
			return Qfalse;
		}		
	}

	static VALUE
	getdnsruby_context_async_hostname(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		VALUE hostname = NULL, extensions;
		getdns_dict* response = NULL;
		getdns_return_t gres_h;
		VALUE callback;
		VALUE obj;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		if (!ptr-> ctx) {
			return Qfalse;
		}
		struct event_base *this_event_base;
		getdns_transaction_t this_transaction_id = 0;

		if (argc > 5 || argc == 0) { // there should only be 1 or 2 arguments
			rb_raise(rb_eArgError, "Wrong number of arguments");
		}
		rb_scan_args(argc, argv, "41",&hostname,&obj,&callback,&this_event_base,&extensions);
		if (rb_class_of(callback) != rb_cSymbol)
		rb_raise(rb_eTypeError, "Expected Symbol callbackack");
		VALUE hostnameStr = StringValue(hostname);
		VALUE this_userarg = rb_ary_new();
		rb_ary_store(this_userarg,0,callback);
		rb_ary_store(this_userarg,1,obj);
		getdns_dict* ip = getdns_util_create_ip(RSTRING_PTR(hostnameStr));
		if (argc > 4) {
			if (RHASH_SIZE(extensions) > 0) {
				getdns_dict* this_extensions = get_extension(extensions);
				gres_h = getdns_hostname(ptr->ctx, ip, this_extensions, (void *)this_userarg, &this_transaction_id, this_callbackfn);
			}
		} else {
			gres_h = getdns_hostname(ptr->ctx, ip, NULL, (void *)this_userarg, &this_transaction_id, this_callbackfn);
		}
		if (gres_h != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(response);
			return Qfalse;
		}
	}

	static VALUE
	getdnsruby_context_async_service(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		VALUE servicename = NULL, extensions;
		getdns_dict* response = NULL;
		getdns_return_t gres;
		VALUE callback;
		VALUE obj;
		if (!ptr-> ctx) {
			return Qfalse;
		}
		struct event_base *this_event_base;		
		getdns_transaction_t this_transaction_id = 0;

		if (argc > 5|| argc == 0) { // there should only be 1 or 2 arguments
			rb_raise(rb_eArgError, "Wrong number of arguments");
		}
		rb_scan_args(argc, argv, "41",&servicename,&obj,&callback,&this_event_base,&extensions);
		if (rb_class_of(callback) != rb_cSymbol)
		rb_raise(rb_eTypeError, "Expected Symbol callbackack");
		VALUE servicenameStr = StringValue(servicename);
		VALUE this_userarg = rb_ary_new();
		rb_ary_store(this_userarg,0,callback);
		rb_ary_store(this_userarg,1,obj);
		if (argc > 4) {
			if (RHASH_SIZE(extensions) > 0) {
				getdns_dict* this_extensions = get_extension(extensions);
				gres = getdns_service(ptr->ctx, RSTRING_PTR(servicenameStr), this_extensions, (void *)this_userarg, &this_transaction_id, this_callbackfn);
			}
		} else {
			gres = getdns_service(ptr->ctx, RSTRING_PTR(servicenameStr), NULL,(void *)this_userarg, &this_transaction_id, this_callbackfn);
		}
		if (gres != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(response);
			return Qfalse;
		}
	}

	static VALUE
	getdnsruby_context_async_general(int argc, VALUE *argv,VALUE self) {
		struct GetdnsContextWrap *ptr;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		VALUE generalname = NULL, extensions;
		getdns_dict* response = NULL;
		getdns_return_t greg;
		VALUE callback;
		VALUE rrtype;
		VALUE obj;
		if (!ptr-> ctx) {
			return Qfalse;
		}
		struct event_base *this_event_base;
		getdns_transaction_t this_transaction_id = 0;
		if (argc > 6 || argc < 2) { // there should only be 1 or 2 arguments
			rb_raise(rb_eArgError, "Wrong number of arguments");
		}
		rb_scan_args(argc, argv, "51",&generalname,&rrtype,&obj,&callback,&this_event_base,&extensions);
		if (rb_class_of(callback) != rb_cSymbol)
		rb_raise(rb_eTypeError, "Expected Symbol callbackack");
		VALUE generalnameStr = StringValue(generalname);
		int rr = NUM2INT(rrtype);
		VALUE this_userarg = rb_ary_new();
		rb_ary_store(this_userarg,0,callback);
		rb_ary_store(this_userarg,1,obj);
		if (argc > 5) {
			if (RHASH_SIZE(extensions) > 0) {
				getdns_dict* this_extensions = get_extension(extensions);
				greg = getdns_general(ptr->ctx, RSTRING_PTR(generalnameStr), rr, this_extensions, (void *)this_userarg, &this_transaction_id, this_callbackfn);
			}
		} else {
			greg = getdns_general(ptr->ctx, RSTRING_PTR(generalnameStr),rr, NULL, (void *)this_userarg, &this_transaction_id, this_callbackfn);
		}
		if (greg != GETDNS_RETURN_GOOD) {
			getdns_dict_destroy(response);
			return Qfalse;
		}
	}

	static VALUE dispatch_event_base(int argc, VALUE *argv,VALUE self) {
		struct event_base *this_event_base;
		struct GetdnsContextWrap *ptr;
		Data_Get_Struct(self, struct GetdnsContextWrap, ptr);
		if (!ptr-> ctx) {
			return Qfalse;
		}
		rb_scan_args(argc, argv, "10",&this_event_base);
		event_base_dispatch(this_event_base);
		event_base_free(this_event_base);
	}

	void Init_getdns(void) {
		mGetdns = rb_define_module("Getdns");
		cContext = rb_define_class_under(mGetdns, "Context", rb_cObject);
		rb_define_alloc_func(cContext, getdnsruby_context_alloc);
		rb_define_method(cContext, "initialize", RUBY_METHOD_FUNC(getdnsruby_context_initialize), -1);
		rb_define_method(cContext, "lookup", RUBY_METHOD_FUNC(getdnsruby_context_lookup), -1);
		rb_define_method(cContext, "hostname", RUBY_METHOD_FUNC(getdnsruby_context_hostname),-1);
		rb_define_method(cContext, "service", RUBY_METHOD_FUNC(getdnsruby_context_service), -1);
		rb_define_method(cContext, "general", RUBY_METHOD_FUNC(getdnsruby_context_general), -1);
		rb_define_method(cContext, "asyncaddress", RUBY_METHOD_FUNC(getdnsruby_context_async_address), -1);
		rb_define_method(cContext, "asynchostname", RUBY_METHOD_FUNC(getdnsruby_context_async_hostname), -1);
		rb_define_method(cContext, "asyncservice", RUBY_METHOD_FUNC(getdnsruby_context_async_service), -1);
		rb_define_method(cContext, "asyncgeneral", RUBY_METHOD_FUNC(getdnsruby_context_async_general), -1);
		rb_define_method(cContext, "dispatch_event_base", RUBY_METHOD_FUNC(dispatch_event_base),-1);
		rb_define_module_function(mGetdns, "create_event_base", RUBY_METHOD_FUNC(create_event_base),0);
	}
}
