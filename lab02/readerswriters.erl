-module(readerswriters).
-export([run/0, writer/1, reader/1, buffer/3, create_readers/2]).

run() ->
  Buffer_PID = spawn(readerswriters, buffer, [0, 0, -1]),
  create_readers(10000, Buffer_PID),
  create_writers(8000, Buffer_PID).

create_readers(N, Buffer_PID) ->
  if
    N > 0 ->
      spawn(readerswriters, reader, [Buffer_PID]),
      create_readers(N - 1, Buffer_PID);
    true ->
      ok
  end.

create_writers(N, Buffer_PID) ->
  if
    N > 0 ->
      spawn(readerswriters, writer, [Buffer_PID]),
      create_writers(N - 1, Buffer_PID);
    true ->
      ok
  end.

writer(Buffer) ->
  timer:sleep(random:uniform(50)),

  Buffer ! {writing_request, self()},

  receive
    write_request_accepted ->
      io:fwrite("writer entered reading room ~p\n", [self()])
  end,

  timer:sleep(random:uniform(50)),

  Buffer ! {writing_finished}.

reader(Buffer) ->
  timer:sleep(random:uniform(50)),

  Buffer ! {reading_request, self()},

  receive
    read_request_accepted ->
      io:fwrite("reader entered reading room ~p\n", [self()])
  end,

  timer:sleep(random:uniform(50)),
  Buffer ! {reading_finished}.

buffer(Readers_Amount, Writer_Locked, Writer_PID) ->
%%   io:fwrite("~p\n", [self()]),
  receive
    {writing_request, Writer_Sender} ->
      if
        (Writer_Locked == 0) and (Readers_Amount == 0) ->
          Writer_Sender ! write_request_accepted,
          buffer(Readers_Amount, 1, Writer_Sender);
        (Writer_Locked == 0) ->
          buffer(Readers_Amount, 1, Writer_Sender);
        true ->
          self() ! {writing_request, Writer_Sender},
          buffer(Readers_Amount, 1, Writer_PID)
      end;

    {writing_finished} ->
      buffer(Readers_Amount, 0, -1);

    {reading_request, Reader_Sender} ->
      if
        Writer_Locked == 0 ->
          Reader_Sender ! read_request_accepted,
          buffer(Readers_Amount + 1, 0, -1);
        true ->
          self() ! {reading_request, Reader_Sender},
          buffer(Readers_Amount, Writer_Locked, Writer_PID)
      end;

    {reading_finished} ->
      if
        (Readers_Amount == 1) and (Writer_Locked == 1) ->
          Writer_PID ! write_request_accepted,
          buffer(0, 1, Writer_PID);
        true ->
          buffer(Readers_Amount - 1, Writer_Locked, Writer_PID)
      end
  end.



