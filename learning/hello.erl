%%%-------------------------------------------------------------------
%%% @author raduy
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. cze 2014 22:41
%%%-------------------------------------------------------------------
-module(hello).
-author("raduy").

-export([hello_world/1]).

hello_world(X) -> io:fwrite("hello, world~c\n", [X]).
