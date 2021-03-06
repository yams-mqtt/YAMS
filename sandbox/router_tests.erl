%%   Copyright 2013 KuldeepSinh Chauhan
%%
%%   Licensed under the Apache License, Version 2.0 (the "License");
%%   you may not use this file except in compliance with the License.
%%   You may obtain a copy of the License at
%%
%%       http://www.apache.org/licenses/LICENSE-2.0
%%
%%   Unless required by applicable law or agreed to in writing, software
%%   distributed under the License is distributed on an "AS IS" BASIS,
%%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%   See the License for the specific language governing permissions and
%%   limitations under the License.

-module(router_tests).
-include_lib("eunit/include/eunit.hrl").

%% Tests for router:get_type
get_type_connect_test() ->
    ?assert({ok, connect} =:=  router:get_type(<<1:4, 23400>>)).
get_type_conack_test() ->
    ?assert({ok, connack} =:=  router:get_type(<<2:4, 23400>>)).
get_type_publish_test() ->
    ?assert({ok, publish} =:=  router:get_type(<<3:4, 23400>>)).
get_type_puback_test() ->
    ?assert({ok, puback} =:=  router:get_type(<<4:4, 23400>>)).
get_type_pubrec_test() ->
    ?assert({ok, pubrec} =:=  router:get_type(<<5:4, 23400>>)).
get_type_pubrel_test() ->
    ?assert({ok, pubrel} =:=  router:get_type(<<6:4, 23400>>)).
get_type_pubcomp_test() ->
    ?assert({ok, pubcomp} =:=  router:get_type(<<7:4, 23400>>)).
get_type_subscribe_test() ->
    ?assert({ok, subscribe} =:=  router:get_type(<<8:4, 23400>>)).
get_type_suback_test() ->
    ?assert({ok, suback} =:=  router:get_type(<<9:4, 23400>>)).
get_type_unsubscribe_test() ->
    ?assert({ok, unsubscribe} =:=  router:get_type(<<10:4, 23400>>)).
get_type_unsuback_test() ->
    ?assert({ok, unsuback} =:=  router:get_type(<<11:4, 23400>>)).
get_type_pingreq_test() ->
    ?assert({ok, pingreq} =:=  router:get_type(<<12:4, 23400>>)).
get_type_pingresp_test() ->
    ?assert({ok, pingresp} =:=  router:get_type(<<13:4, 23400>>)).
get_type_disconnect_test() ->
    ?assert({ok, disconnect} =:=  router:get_type(<<14:4, 23400>>)).

%% Tests for router:get_remaining_bin
get_remaining_bin_0_test() ->
    ?assert({ok,<<>>} =:= router:get_remaining_bin(<<0>>)).
get_remaining_bin_65_test() ->
    ?assert({ok, <<1:520>>} =:= router:get_remaining_bin(<<65, 1:520>>)).
get_remaining_bin_127_test() ->
    ?assert({ok, <<1:1016>>} =:= router:get_remaining_bin(<<127, 1:1016>>)).
get_remaining_bin_128_test() ->
    ?assert({ok, <<1:1024>>} =:= router:get_remaining_bin(<<128, 1, 1:1024>>)).
get_remaining_bin_8192_test() ->
    ?assert({ok, <<1:65536>>} =:= router:get_remaining_bin(<<128, 64, 1:65536>>)).
get_remaining_bin_16383_test() ->
    ?assert({ok, <<1:131064>>} =:= router:get_remaining_bin(<<255, 127, 1:131064>>)).
get_remaining_bin_1048575_test() ->
    ?assert({ok, <<1:8388600>>} =:= router:get_remaining_bin(<<255, 255, 63, 1:8388600>>)).
get_remaining_bin_2097151_test() ->
    ?assert({ok, <<1:16777208>>} =:= router:get_remaining_bin(<<255, 255, 127, 1:16777208>>)).
get_remaining_bin_2097152_test() ->
    ?assert({ok, <<1:16777216>>} =:= router:get_remaining_bin(<<128, 128, 128, 1, 1:16777216>>)).
get_remaining_bin_134217727_test() ->
    ?assert({ok, <<1:1073741816>>} =:= router:get_remaining_bin(<<255, 255, 255, 63, 1:1073741816>>)).
get_remaining_bin_134217728_test() ->
    ?assert({ok, <<1:1073741824>>} =:= router:get_remaining_bin(<<128, 128, 128, 64, 1:1073741824>>)).
get_remaining_bin_268435455_test() ->
    ?assert({ok, <<1:2147483640>>} =:= router:get_remaining_bin(<<255, 255, 255, 127, 1:2147483640>>)).
get_remaining_bin_268435456_test() ->
    ?assert({error, invalid_remaining_length} =:= router:get_remaining_bin(<<255, 255, 255, 127, 1:2147483648>>)).

%% Test for router:encode_l
encode_length_0_test() ->
    ?assert(<<0>> =:= router:encode_l(0)).
encode_length_65_test() ->
    ?assert(<<65>> =:= router:encode_l(65)).
encode_length_127_test() ->
    ?assert(<<127>> =:= router:encode_l(127)).
encode_length_128_test() ->
    ?assert(<<128,1>> =:= router:encode_l(128)).
encode_length_8192_test() ->
    ?assert(<<128, 64>> =:= router:encode_l(8192)).
encode_length_16383_test() ->
    ?assert(<<255, 127>> =:= router:encode_l(16383)).
encode_length_16384_test() ->
    ?assert(<<128, 128, 1>> =:= router:encode_l(16384)).
encode_length_1048575_test() ->
    ?assert(<<255, 255, 63>> =:= router:encode_l(1048575)).
encode_length_1048576_test() ->
    ?assert(<<128, 128, 64>> =:= router:encode_l(1048576)).
encode_length_2097151_test() ->
    ?assert(<<255, 255, 127>> =:= router:encode_l(2097151)).
encode_length_2097152_test() ->
    ?assert(<<128, 128, 128, 1>> =:= router:encode_l(2097152)).
encode_length_134217727_test() ->
    ?assert(<<255, 255, 255, 63>> =:= router:encode_l(134217727)).
encode_length_134217728_test() ->
    ?assert(<<128, 128, 128, 64>> =:= router:encode_l(134217728)).
encode_length_268435455_test() ->
    ?assert(<<255, 255, 255, 127>> =:= router:encode_l(268435455)).
encode_length_268435456_test() ->
    ?assert({error, invalid_length} =:= router:encode_l(268435456)).
