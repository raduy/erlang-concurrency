%%%-------------------------------------------------------------------
%%% @author raduy
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(ex1).
-author("raduy").

%% API
-export([start/0]).
-export([a_run/0, b_run/0]).

start() ->
  register(process_a, spawn(?MODULE, a_run, [])),
  register(process_b, spawn(?MODULE, b_run, [])).


a_run() ->
  receive
    hello ->
      io:format("process a reveived message. Sending its to b."),
      process_b ! hello,
      a_run()
  end.

b_run() ->
  receive
    hello ->
       io:format("hello~n"),
       b_run();
    killme ->
      io:format("Killed~n")
  end.
