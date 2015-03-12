%% Copyright 2013 KuldeepSinh Chauhan

%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at

%% http://www.apache.org/licenses/LICENSE-2.0

%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

%%%-------------------------------------------------------------------
%%% @author  KuldeepSinh Chauhan
%%% @copyright (C) 2013, 
%%% @doc
%%%     This module will route messages to message handlers in accordance with their type.
%%% @end
%%% Created : 15 Aug 2013 by KuldeepSinh Chauhan
%%%-------------------------------------------------------------------
-module(router_svr).

-behaviour(gen_server).

%% API
-export([
	 start_link/2,
	 create/2,
	 stop/1
	]).

%% gen_server callbacks
-export([
	 init/1, 
	 handle_call/3, 
	 handle_cast/2, 
	 handle_info/2,
	 terminate/2, 
	 code_change/3
	]).

-define(SERVER, ?MODULE). 
-define(MAX_LENGTH, 268435455).

-record(state, 
	{
	  apid, %% PID of associated Acceptor.
	  msg, %% Message received from the acceptor.
	  rsvrpid %% PID of self (RPid).
	}
       ).

%%%===================================================================
%%% API
%%%===================================================================
create(APid, Msg) ->
    router_svr_sup:start_child(APid, Msg).

%%--------------------------------------------------------------------
%% @doc
%% Starts the router
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(APid, Msg) ->
    gen_server:start_link(?MODULE, [APid, Msg], []).


stop(RSvrPid) ->
    gen_server:cast(RSvrPid, stop).


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([APid, Msg]) ->
    {ok, #state{apid = APid, msg = Msg, rsvrpid = self()}, 0}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast(stop, State ) ->
    {stop, normal, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(timeout, #state{apid = APid, msg = Msg, rsvrpid = RSvrPid} = State) ->
    call_router_fsm(APid, RSvrPid, Msg),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%% %%%===================================================================
call_router_fsm(APid, RSvrPid, Pkt) ->
    {ok, RFSMPid} = router_fsm:create(),
    case router_fsm:send_event(RFSMPid, {validate_fb, APid, Pkt}) of
	valid ->
	    case router_fsm:send_event(RFSMPid, {validate_rl}) of
		valid ->
		    router_fsm:send_event(RFSMPid, {route_pkt}),
		    stop(RSvrPid);
		_ ->     
		    stop(RSvrPid)		    
	    end;
	_ ->
	    stop(RSvrPid)
    end.
