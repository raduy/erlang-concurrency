%%%-------------------------------------------------------------------
%%% @author raduy
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. cze 2014 10:08
%%%-------------------------------------------------------------------
-module(dolphins).
-compile(export_all).
-author("raduy").

%% API
-export([]).

dolphin1() ->
  receive
    do_a_flip ->
      io:format("How about no?~n");
    fish ->
      io:format("So long ang thanks for all the fish!~n");
    _ ->
      io:format("Heh, we're smarter than you humans. ~n")
  end.

dolphin2() ->
  receive
    {From, do_a_flip} ->
      From ! "How about no?";
    {From, fish} ->
      From ! "So long and thanks";
    _ ->
      io:format("Heh we're smarter than you humans.")
  end.

dolphin3() ->
  receive
    {From, do_a_flip} ->
      From ! "How about no?",
      dolphin3();
    {From, fish} ->
      From ! "So long and thanks";
    _ ->
      io:format("Heh we're smarter than you humans."),
      dolphin3()
  end.

