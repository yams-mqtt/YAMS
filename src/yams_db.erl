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
%%%     This module opens the acceptor-socket for incomming client messages.
%%% @end
%%% Created :  28 Aug 2013 by  KuldeepSinh Chauhan
%%%-------------------------------------------------------------------
-module(yams_db).
-export([init/0]).
-include("../include/yams_db.hrl").

%% This function is used to initialize, mnesia based database for YAMS.
init() ->
    %% Start mnesia
    mnesia:start(),
    %% This table will store mapping between ID of the connected client and its associated Acceptor Pid.
    %% This will be a RAM based table.
    mnesia:create_table(cid_to_apid, [{attributes, record_info(fields, cid_to_apid)}]),
    %% Subscription table will store Client ID and its subscribed topics.
    %% Contents of this table will be stored on the disk too, along with in the RAM.
    mnesia:create_table(subscription, [{disc_copies, [node()]}, {type, bag}, {attributes, record_info(fields, subscription)}]).


