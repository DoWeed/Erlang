-module(task_1).

-export([parse/2]).

-include_lib("eunit/include/eunit.hrl").

parse(Str, Data) when is_binary(Str) ->
    Fun = fun(K, V, Acc) ->
        binary:replace(Acc, key_to_template(K), parse_params(V)) end,
    maps:fold(Fun, Str, Data).


%% Надо использовать сплит и вытащить из строки "{{ }}" и в них искать параметр и его менять предварительно распарсить на нужный тип

key_to_template(K) ->
    iolist_to_binary(io_lib:format("{{~s}}", [erlang:binary_to_list(K)])). 

parse_params(Param) when is_integer(Param) -> integer_to_binary(Param);
parse_params(Param) -> iolist_to_binary(Param).




parse_test() ->
    In = <<"hello {{name}}!">>,
    Out = <<"hello Bob!">>,
    Data = #{<<"name">> => <<"Bob">>},
    ?assertEqual(Out, task_1:parse(In, Data)),
    ok.


parse_many_params_test() ->
    In = <<"User {{name}} won {{wins}} games and got {{points}} points">>,
    Out = <<"User Kate won 55 games and got 777 points">>,
    Data = #{<<"name">> => "Kate",
              <<"wins">> => 55,
              <<"points">> => 777},
    ?assertEqual(Out, task_1:parse(In, Data)),
    ok.


param_at_first_or_last_position_test() ->
    In1 = <<"{{name}} rocks!">>,
    Out1 = <<"Bill rocks!">>,
    Data1 = #{<<"name">> => <<"Bill">>},
    ?assertEqual(Out1, task_1:parse(In1, Data1)),

    In2 = <<"watch your {{direction}}">>,
    Out2 = <<"watch your back">>,
    Data2 = #{<<"direction">> => "back"},
    ?assertEqual(Out2, task_1:parse(In2, Data2)),

    In3 = <<"{{user}}, watch your {{direction}}">>,
    Out3 = <<"Bob, watch your back">>,
    Data3 = #{<<"user">> => <<"Bob">>, <<"direction">> => "back"},
    ?assertEqual(Out3, task_1:parse(In3, Data3)),
    ok.


no_params_in_str_test() ->
    In = <<"no params in this string">>,
    Out = <<"no params in this string">>,
    Data = #{<<"param1">> => <<"value1">>, <<"param2">> => <<"value1">>},
    ?assertEqual(Out, task_1:parse(In, Data)),
    ok.


no_params_in_data_test() ->
    In = <<"quick brown {{animal1}} jump over lazy {{animal2}}">>,
    Out = <<"quick brown  jump over lazy ">>,
    Data = #{<<"param1">> => <<"value1">>, <<"param2">> => <<"value1">>},
    ?assertEqual(Out, task_1:parse(In, Data)),
    ok.


unicode_data_in_test() ->
    In = <<"Привет {{имя}}!"/utf8>>,
    Out = <<"Привет Петя!"/utf8>>,
    Data = #{<<"имя"/utf8>> => <<"Петя"/utf8>>},
    ?assertEqual(Out, task_1:parse(In, Data)),
    ok.