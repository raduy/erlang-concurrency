%%%-------------------------------------------------------------------
%%% @author raduy
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(ex3).
-author("raduy").

%% API
-export([c_run/0, b_run/0, a_run/0, start/0]).


start() ->
  register(process_a, spawn(?MODULE, a_run, [])),
  register(process_b, spawn(?MODULE, b_run, [])),
  register(process_c, spawn(?MODULE, c_run, [])).

a_run() ->
  process_c ! aaa,
%%   timer:sleep(10),

  a_run().

b_run() ->
  process_c ! bbb,
%%   timer:sleep(10),

  b_run().

c_run() ->
  receive
    aaa ->
      io:format("aaa")
  end,

  receive
    bbb ->
      io:format("bbb"),
      c_run();
    _ ->
      c_run()
  end.