-module(task_1).

-export([start/1]).

-include_lib("eunit/include/eunit.hrl").

start(Files) ->
    Parent = self(),
    Reducer = spawn(fun() -> reducer(Parent, #{}, length(Files)) end),
    [spawn(fun() -> mapper(File, Reducer) end) || File <- Files],
    receive
        {result, Result} -> Result
    end.

mapper(File, Reducer) ->
    case file:read_file(File) of
        {ok, Binary} ->
            Text = binary_to_list(Binary),
            Words = string:tokens(Text, " .,!?;:\n\r\t"),
            Counts = lists:foldl(fun(Word, Acc) ->
                BinaryWord = list_to_binary(Word),
                maps:update_with(BinaryWord, fun(Count) -> Count + 1 end, 1, Acc)
            end, #{}, Words),
            Reducer ! {counts, Counts};
        {error, _Reason} ->
            io:format("~p: Не удалось прочитать файл~n", [File]),
            Reducer ! {counts, #{}}
    end.

reducer(Parent, Acc, 0) ->
    Parent ! {result, Acc};
reducer(Parent, Acc, Remaining) ->
    receive
        {counts, Counts} ->
            NewAcc = maps:fold(fun(Word, Count, AccMap) ->
                maps:update_with(Word, fun(Existing) -> Existing + Count end, Count, AccMap)
            end, Acc, Counts),
            reducer(Parent, NewAcc, Remaining - 1)
    end.

file5_test() ->
    Data = task_1:start(["data1.txt",
                             "data2.txt",
                             "data3.txt",
                             "data4.txt",
                             "data5.txt"]),
    ?assertEqual(3, maps:get(<<"а"/utf8>>, Data)),
    ?assertEqual(1, maps:get(<<"бензопила"/utf8>>, Data)),
    ?assertEqual(4, maps:get(<<"в"/utf8>>, Data)),
    ?assertEqual(2, maps:get(<<"вслух"/utf8>>, Data)),
    ?assertEqual(1, maps:get(<<"заинтригован"/utf8>>, Data)),
    ?assertEqual(1, maps:get(<<"царя"/utf8>>, Data)),
    ok.


file2_test() ->
    Data = task_1:start(["data1.txt", "data2.txt"]),
    ?assertEqual(2, maps:get(<<"а"/utf8>>, Data)),
    ?assertEqual(1, maps:get(<<"бензопила"/utf8>>, Data)),
    ?assertEqual(2, maps:get(<<"в"/utf8>>, Data)),
    ?assertEqual(error, maps:find(<<"вслух"/utf8>>, Data)),
    ?assertEqual(1, maps:get(<<"заинтригован"/utf8>>, Data)),
    ?assertEqual(1, maps:get(<<"царя"/utf8>>, Data)),
    ok.


file1_test() ->
    Data = task_1:start(["data1.txt", "data777.txt"]),
    ?assertEqual(error, maps:find(<<"а"/utf8>>, Data)),
    ?assertEqual(1, maps:get(<<"бензопила"/utf8>>, Data)),
    ?assertEqual(2, maps:get(<<"в"/utf8>>, Data)),
    ?assertEqual(error, maps:find(<<"вслух"/utf8>>, Data)),
    ?assertEqual(1, maps:get(<<"заинтригован"/utf8>>, Data)),
    ?assertEqual(error, maps:find(<<"царя"/utf8>>, Data)),
    ok.