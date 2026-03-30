-module(task_1).

-export([init/0, create_short/2, get_long/2, rand_str/1]).

-include_lib("eunit/include/eunit.hrl").


%%% module API

init() ->
    %% init randomizer
    <<A:32, B:32, C:32>> = crypto:strong_rand_bytes(12),
    rand:seed(exsp, {A,B,C}),
    State = {#{}},
    State.
    % State = your_state_structure,
    % State.


create_short(LongLink, State) ->
    {ShortM} = State,
    case lists:keyfind(LongLink, 2, maps:to_list(ShortM)) of
        {ShortLink, _} -> {ShortLink, State};
        false -> ShortLink = "http://hexlet.io" ++ rand_str(8),
                % LongM1 = LongM #{LongLink => ShortLink},
                ShortM1 = maps:put(ShortLink, LongLink, ShortM),
                {ShortLink, {ShortM1}}
    end.

% find_key(LongLink, ShortM) ->
%     PropList = maps:to_list(ShortM),
%     case lists:keyfind(LongLink, 2, PropList) of
%         {ShortLink, LongLink} -> {ok, ShortLink};
%         false -> error
%     end.

get_long(ShortLink, State) ->
    {ShortM} = State,
    case maps:find(ShortLink, ShortM) of
        {ok, LongLink} -> {ok, LongLink};
        error -> {error, not_found}
    end.


%% generates random string of chars [a-zA-Z0-9]
rand_str(Length) ->
    lists:map(fun(Char) when Char > 83 -> Char + 13;
                 (Char) when Char > 57 -> Char + 7;
                 (Char) -> Char
              end,
              [rand:uniform(110 - 48) + 47 || _ <- lists:seq(1, Length)]).


create_short_test() ->
    State1 = task_1:init(),
    {Short1, State2} = task_1:create_short("http://hexlet.io", State1),
    {Short2, State3} = task_1:create_short("http://lenta.ru", State2),
    {Short3, State4} = task_1:create_short("http://ya.ru", State3),
    {Short4, State5} = task_1:create_short("http://facebook.com", State4),
    {Short4, State6} = task_1:create_short("http://facebook.com", State5),
    ?assertMatch({Short1, _}, task_1:create_short("http://hexlet.io", State6)),
    ?assertMatch({Short2, _}, task_1:create_short("http://lenta.ru", State6)),
    ?assertMatch({Short3, _}, task_1:create_short("http://ya.ru", State6)),
    ?assertMatch({Short4, _}, task_1:create_short("http://facebook.com", State6)),
    ok.


get_long_test() ->
    State0 = task_1:init(),
    ?assertEqual({error, not_found}, task_1:get_long("foobar", State0)),

    {Short1, State1} = task_1:create_short("http://hexlet.io", State0),
    ?assertEqual({ok, "http://hexlet.io"}, task_1:get_long(Short1, State1)),

    {Short2, State2} = task_1:create_short("http://lenta.ru", State1),
    ?assertEqual({ok, "http://lenta.ru"}, task_1:get_long(Short2, State2)),

    {Short3, State3} = task_1:create_short("http://ya.ru", State2),
    ?assertEqual({ok, "http://ya.ru"}, task_1:get_long(Short3, State3)),

    {Short4, State4} = task_1:create_short("http://facebook.com", State3),
    ?assertEqual({ok, "http://facebook.com"}, task_1:get_long(Short4, State4)),

    ?assertEqual({ok, "http://hexlet.io"}, task_1:get_long(Short1, State4)),
    ?assertEqual({ok, "http://lenta.ru"}, task_1:get_long(Short2, State4)),
    ?assertEqual({ok, "http://ya.ru"}, task_1:get_long(Short3, State4)),
    ?assertEqual({ok, "http://facebook.com"}, task_1:get_long(Short4, State4)),
    ?assertEqual({error, not_found}, task_1:get_long("bla-bla-bla", State4)),

    ok.