-module(router).
-export([route/1]).
-include_lib("eunit/include/eunit.hrl").

route(Bin = <<MT:4, _/binary>>) ->
    case MT of 
	1 ->
	    {ok, connect, Bin};
	2 ->
	    {ok, conack, Bin};
	3 ->
	    {ok, publish, Bin};
	4 ->
	    {ok, puback, Bin};
	5 ->
	    {ok, pubrec, Bin};
	6 ->
	    {ok, pubrel, Bin};
	7 ->
	    {ok, pubcomp, Bin};
	8 ->
	    {ok, subscribe, Bin};
	9 ->
	    {ok, suback, Bin};
	10 ->
	    {ok, unsubscribe, Bin};
	11 ->
	    {ok, unsuback, Bin};
	12 ->
	    {ok, pingreq, Bin};
	13 ->
	    {ok, pingresp, Bin};
	14 ->
	    {ok, disconnect, Bin};
	_ ->
	    {error, invalid_message_type, Bin}
    end.


route_connect_test() ->
    ?assert({ok, connect, <<1:4, 23400>>} =:= route(<<1:4, 23400>>)).
route_conack_test() ->
    ?assert({ok, conack, <<2:4, 23400>>} =:= route(<<2:4, 23400>>)).
route_publish_test() ->
    ?assert({ok, publish, <<3:4, 23400>>} =:= route(<<3:4, 23400>>)).
route_puback_test() ->
    ?assert({ok, puback, <<4:4, 23400>>} =:= route(<<4:4, 23400>>)).
route_pubrec_test() ->
    ?assert({ok, pubrec, <<5:4, 23400>>} =:= route(<<5:4, 23400>>)).
route_pubrel_test() ->
    ?assert({ok, pubrel, <<6:4, 23400>>} =:= route(<<6:4, 23400>>)).
route_pubcomp_test() ->
    ?assert({ok, pubcomp, <<7:4, 23400>>} =:= route(<<7:4, 23400>>)).
route_subscribe_test() ->
    ?assert({ok, subscribe, <<8:4, 23400>>} =:= route(<<8:4, 23400>>)).
route_suback_test() ->
    ?assert({ok, suback, <<9:4, 23400>>} =:= route(<<9:4, 23400>>)).
route_unsubscribe_test() ->
    ?assert({ok, unsubscribe, <<10:4, 23400>>} =:= route(<<10:4, 23400>>)).
route_unsuback_test() ->
    ?assert({ok, unsuback, <<11:4, 23400>>} =:= route(<<11:4, 23400>>)).
route_pingreq_test() ->
    ?assert({ok, pingreq, <<12:4, 23400>>} =:= route(<<12:4, 23400>>)).
route_pingresp_test() ->
    ?assert({ok, pingresp, <<13:4, 23400>>} =:= route(<<13:4, 23400>>)).
route_disconnect_test() ->
    ?assert({ok, disconnect, <<14:4, 23400>>} =:= route(<<14:4, 23400>>)).
route_less_than_1_test() ->
    ?assert({error, invalid_message_type, <<0:4, 23400>>} =:= route(<<0:4, 23400>>)).
route_more_than_14_test() ->
    ?assert({error, invalid_message_type, <<15:4, 23400>>} =:= route(<<15:4, 23400>>)).

