-module(task_1).

-export([new_game/0, win/1, move/3]).
-include_lib("eunit/include/eunit.hrl").


new_game() ->
    {{f, f, f},
     {f, f, f},
     {f, f, f}}.


win({{Player, Player, Player}, {_, _, _}, {_, _, _}}) when Player =/= f -> {win, Player}; 
win({{_, _, _}, {_, _, _}, {Player, Player, Player}}) when Player =/= f -> {win, Player}; 
win({{_, _, _}, {Player, Player, Player}, {_, _, _}}) when Player =/= f -> {win, Player}; 
win({{Player, _, _}, {_, Player, _}, {_, _, Player}}) when Player =/= f -> {win, Player}; 
win({{Player, _, _}, {Player, _, _}, {Player, _, _}}) when Player =/= f -> {win, Player}; 
win({{_,Player,_}, {_, Player, _}, {_, Player, _}}) when Player =/= f -> {win, Player}; 
win({{_, _, Player}, {_, Player, _}, {Player, _, _}}) when Player =/= f -> {win, Player}; 
win({{_, _, Player}, {_, _, Player}, {_, _, Player}}) when Player =/= f -> {win, Player}; 
win(_) -> no_win.

% win(GameState) ->
%     case GameState of
%         {{Player, Player, Player}, {_, _, _}, {_, _, _}} when Player =/= f -> {win, Player};
%         {{Player, _, _}, {_, Player, _}, {_, _, Player}} when Player =/= f  -> {win, Player};
%         {{Player, _, _}, {Player, _, _}, {Player, _, _}}  when Player =/= f -> {win, Player};
%         {{_, Player,_}, {_, Player, _}, {_, Player, _}}  when Player =/= f -> {win, Player};
%         {{_, _, Player}, {_, Player, _}, {Player, _, _}}  when Player =/= f -> {win, Player};
%         {{_, _, Player}, {_, _, Player}, {_, _, Player}}  when Player =/= f -> {win, Player};
%         _ -> no_win
%     end.

win_test() ->
    ?assertEqual(no_win, task_1:win(task_1:new_game())),
    ?assertEqual(no_win, task_1:win({{x,o,x},
                                          {o,x,o},
                                          {o,x,o}})),
    ?assertEqual({win, x}, task_1:win({{x,x,x},
                                            {f,f,f},
                                            {f,f,f}})),
    ?assertEqual({win, o}, task_1:win({{f,f,x},
                                            {o,o,o},
                                            {f,x,f}})),
    ?assertEqual({win, x}, task_1:win({{o,o,f},
                                            {f,o,f},
                                            {x,x,x}})),
    ?assertEqual({win, o}, task_1:win({{o,f,f},
                                            {o,x,f},
                                            {o,x,x}})),
    ?assertEqual({win, x}, task_1:win({{f,x,f},
                                            {o,x,o},
                                            {f,x,o}})),
    ?assertEqual({win, o}, task_1:win({{x,x,o},
                                            {o,x,o},
                                            {x,f,o}})),
    ?assertEqual({win, x}, task_1:win({{x,f,o},
                                            {f,x,o},
                                            {f,o,x}})),
    ?assertEqual({win, o}, task_1:win({{x,x,o},
                                            {x,o,x},
                                            {o,f,f}})),
    ok.



% move(Cell, Player, GameState) when {Cell, GameState} == {1, {{f, Cell_2, Cell_3}, Line_2, Line_3}} -> {ok, {{Player, Cell_2, Cell_3}, Line_2, Line_3}};
% move(Cell, Player, GameState) when {Cell, GameState} == {2, {{Cell_1, f, Cell_3}, Line_2, Line_3}} -> {ok, {{Cell_1, Player, Cell_3}, Line_2, Line_3}};
% move(Cell, Player, GameState) when {Cell, GameState} == {3, {{Cell_1, Cell_2, f}, Line_2, Line_3}} -> {ok, {{Cell_1, Cell_2, Player}, Line_2, Line_3}};
% move(Cell, Player, GameState) when {Cell, GameState} == {4, {Line_1, {f, Cell_2, Cell_3}, Line_3}} -> {ok, {Line_1, {Player, Cell_2, Cell_3}, Line_3}};
% move(Cell, Player, GameState) when {Cell, GameState} == {5, {Line_1, {Cell_1, f, Cell_3}, Line_3}} -> {ok, {Line_1, {Cell_1, Player, Cell_3}, Line_3}};
% move(Cell, Player, GameState) when {Cell, GameState} == {6, {Line_1, {Cell_1, Cell_2, f}, Line_3}} -> {ok, {Line_1, {Cell_1, Cell_2, Player}, Line_3}};
% move(Cell, Player, GameState) when {Cell, GameState} == {7, {Line_1, Line_2, {f, Cell_2, Cell_3}}} -> {ok, {Line_1, Line_2, {Player, Cell_2, Cell_3}}};
% move(Cell, Player, GameState) when {Cell, GameState} == {8, {Line_1, Line_2, {Cell_1, f, Cell_3}}} -> {ok, {Line_1, Line_2, {Cell_1, Player, Cell_3}}};
% move(Cell, Player, GameState) when {Cell, GameState} == {9, {Line_1, Line_2, {Cell_1, Cell_2, f}}} -> {ok, {Line_1, Line_2, {Cell_1, Cell_2, Player}}};
% move(_, _, _) -> {error, invalid_move}.

move(Cell, Player, GameState) ->
    case {Cell, GameState} of
        {1, {{f, Cell_2, Cell_3}, Line_2, Line_3}} -> {ok, {{Player, Cell_2, Cell_3}, Line_2, Line_3}};
        {2, {{Cell_1, f, Cell_3}, Line_2, Line_3}} -> {ok, {{Cell_1, Player, Cell_3}, Line_2, Line_3}};
        {3, {{Cell_1, Cell_2, f}, Line_2, Line_3}} -> {ok, {{Cell_1, Cell_2, Player}, Line_2, Line_3}};
        {4, {Line_1, {f, Cell_2, Cell_3}, Line_3}} -> {ok, {Line_1, {Player, Cell_2, Cell_3}, Line_3}};
        {5, {Line_1, {Cell_1, f, Cell_3}, Line_3}} -> {ok, {Line_1, {Cell_1, Player, Cell_3}, Line_3}};
        {6, {Line_1, {Cell_1, Cell_2, f}, Line_3}} -> {ok, {Line_1, {Cell_1, Cell_2, Player}, Line_3}};
        {7, {Line_1, Line_2, {f, Cell_2, Cell_3}}} -> {ok, {Line_1, Line_2, {Player, Cell_2, Cell_3}}};
        {8, {Line_1, Line_2, {Cell_1, f, Cell_3}}} -> {ok, {Line_1, Line_2, {Cell_1, Player, Cell_3}}};
        {9, {Line_1, Line_2, {Cell_1, Cell_2, f}}} -> {ok, {Line_1, Line_2, {Cell_1, Cell_2, Player}}};
        _ -> {error, invalid_move}
    end.

move_test() ->
    G0 = task_1:new_game(),

    {ok, G1} = task_1:move(1, x, G0),
    ?assertEqual({{x,f,f},{f,f,f},{f,f,f}}, G1),
    ?assertEqual({error, invalid_move}, task_1:move(1, x, G1)),

    {ok, G2} = task_1:move(5, o, G1),
    ?assertEqual({{x,f,f},{f,o,f},{f,f,f}}, G2),
    ?assertEqual({error, invalid_move}, task_1:move(5, o, G2)),

    {ok, G3} = task_1:move(4, x, G2),
    ?assertEqual({{x,f,f},{x,o,f},{f,f,f}}, G3),
    ?assertEqual({error, invalid_move}, task_1:move(4, x, G3)),

    {ok, G4} = task_1:move(7, o, G3),
    ?assertEqual({{x,f,f},{x,o,f},{o,f,f}}, G4),
    ?assertEqual({error, invalid_move}, task_1:move(7, o, G4)),

    {ok, G5} = task_1:move(2, x, G4),
    ?assertEqual({{x,x,f},{x,o,f},{o,f,f}}, G5),
    ?assertEqual({error, invalid_move}, task_1:move(2, x, G5)),

    {ok, G6} = task_1:move(3, o, G5),
    ?assertEqual({{x,x,o},{x,o,f},{o,f,f}}, G6),
    ?assertEqual({error, invalid_move}, task_1:move(3, o, G6)),

    ?assertEqual({win, o}, task_1:win(G6)),

    ok.


move2_test() ->
    ?assertEqual({ok, {{x,f,f},{f,f,f},{f,f,f}}}, task_1:move(1, x, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({ok, {{f,x,f},{f,f,f},{f,f,f}}}, task_1:move(2, x, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({ok, {{f,f,x},{f,f,f},{f,f,f}}}, task_1:move(3, x, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({ok, {{f,f,f},{x,f,f},{f,f,f}}}, task_1:move(4, x, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({ok, {{f,f,f},{f,x,f},{f,f,f}}}, task_1:move(5, x, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({ok, {{f,f,f},{f,f,o},{f,f,f}}}, task_1:move(6, o, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({ok, {{f,f,f},{f,f,f},{o,f,f}}}, task_1:move(7, o, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({ok, {{f,f,f},{f,f,f},{f,o,f}}}, task_1:move(8, o, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({ok, {{f,f,f},{f,f,f},{f,f,o}}}, task_1:move(9, o, {{f,f,f},{f,f,f},{f,f,f}})),
    ?assertEqual({error, invalid_move}, task_1:move(10, o, {{f,f,f},{f,f,f},{f,f,f}})),
    ok.