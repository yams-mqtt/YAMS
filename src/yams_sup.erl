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
%%% @author KuldeepSinh Chauhan
%%% @copyright (C) 2013
%%% @doc yams_sup is the root supervisor. 
%%%      It starts listener_sup for listening incoming TCP connection requests.
%%%      It also starts msg_sup for accepting (receiving) and sending messages among clients.
%%% @end
%%% Created : Aug 2013 by KuldeepSinh Chauhan
%%%-------------------------------------------------------------------


-module(yams_sup).
%% yams_sup implements supervisor interface.
-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

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

    %Suprevisor for Connection Listener 
    ListenerSup = {listener_sup, {listener_sup, start_link, []}, Restart, Shutdown, Type, [listener_sup]},
    %Supervisor for Messages
    MsgSup = {msg_sup, {msg_sup, start_link, []}, Restart, Shutdown, Type, [msg_sup]},

    %%In the following list, the order of given supervisors is very important.
    %%Starting from the lowest level, supervisors will be started upto the highest level, 
    %%ensuring, lower level Supervisor is ready before it is used by the higher level.
    {ok, {SupFlags, [MsgSup, ListenerSup]}}.

%% ===================================================================
%% Non-API functions
%% ===================================================================
