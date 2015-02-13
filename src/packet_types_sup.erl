%% Copyright 2013 KuldeepSinh Chauhan
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

%%%-------------------------------------------------------------------
%%% @author  KuldeepSinh Chauhan
%%% @copyright (C) 2013, 
%%% @doc
%%%     This module will supervise implementation of the MQTT protocol.
%%% @end
%%% Created : 10 Aug 2013 by KuldeepSinh Chauhan
%%% Updated : 05 Feb 2015 by KuldeepSinh Chauhan
%%%-------------------------------------------------------------------
-module(packet_types_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================
start_link() ->
    supervisor:start_link({local, ?MODULE},?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = infinity,
    Type = supervisor,

    %Suprevisor for message type = ping request
    PingRequestSup = {pingreq_sup, {pingreq_sup, start_link, []}, Restart, Shutdown, Type, [pingreq_sup]},

    %Suprevisor for message type = disconnect
    DisconnectSup = {disconnect_sup, {disconnect_sup, start_link, []}, Restart, Shutdown, Type, [disconnect_sup]},

    %Suprevisor for message type = connect
    ConnectSup = {connect_sup, {connect_sup, start_link, []}, Restart, Shutdown, Type, [connect_sup]},

    %Suprevisor for message type = publish
    PublishSup = {publish_sup, {publish_sup, start_link, []}, Restart, Shutdown, Type, [publish_sup]},

    %Suprevisor for message type = unsubscribe
    UnsubscribeSup = {unsubscribe_sup, {unsubscribe_sup, start_link, []}, Restart, Shutdown, Type, [unsubscribe_sup]},

    %Suprevisor for message type = subscribe
    SubscribeSup = {subscribe_sup, {subscribe_sup, start_link, []}, Restart, Shutdown, Type, [subscribe_sup]},

    %Suprevisor for topic parser FSM
    %TParserSup = {topic_parser, {topic_parser_sup, start_link, []}, Restart, Shutdown, Type, [topic_parser_sup]},

    %%In the following list, the order of given supervisors is very important.
    %%Starting from the lowest level, supervisors will be started upto the highest level, 
    %%ensuring, lower level Supervisor is ready before it is used by the higher level.
    {ok, 
     {SupFlags, 
      [
       UnsubscribeSup, 
       SubscribeSup, 
       PublishSup, 
       PingRequestSup,
       DisconnectSup, 
       ConnectSup
      ]
     }
    }.

%% ===================================================================
%% Non-API functions
%% ===================================================================
