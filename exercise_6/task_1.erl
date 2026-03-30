-module(task_1).

-include_lib("stdlib/include/ms_transform.hrl").

-include_lib("eunit/include/eunit.hrl").

-export([init/0,
         add_idea/5, get_idea/1,
         ideas_by_author/1, ideas_by_rating/1,
         get_authors/0]).

-record(idea, {id, title, author, rating, description}).


init() ->
    ets:new(great_ideas_table, [set, named_table, {keypos, 2}]),
    ets:insert(great_ideas_table,
               [#idea{id = 1, title = "Мороженое с огурцами", author = "Боб Бобов", rating = 100,
                      description = "Крошим огурцы кубиками и добавляем в мороженое"},
                #idea{id = 2, title = "Добыча воды на Марсе", author = "Билл Билов", rating = 500,
                      description = "Бурим скважины на Марсе, доставляем воду на Землю ракетами"},
                #idea{id = 3, title = "Извлечение энергии квазаров", author = "П. И. Шурупов", rating = 100500,
                      description = "Секретно"},
                #idea{id = 4, title = "Куртка с тремя рукавами", author = "Боб Бобов", rating = 15,
                      description = "Рукава из разных материалов, расчитаны на разную погоду."},
                #idea{id = 5, title = "Кроссовки-степлеры", author = "Олечка", rating = 78,
                      description = "Полезная вещь для офиса и фитнеса"},
                #idea{id = 6, title = "Способ ловли кузнечиков", author = "Алекс Аквамаринов", rating = 777,
                      description = "Сачком их, сачком."},
                #idea{id = 7, title = "Вулканический зонт", author = "Боб Бобов", rating = 12,
                      description = "Защищает самолеты от вулканической пыли."},
                #idea{id = 8, title = "Телефон-шар", author = "Див Стобс", rating = 8383,
                      description = "Удобно лежит в руке, имеет устройство ввода на основе гироскопа"},
                #idea{id = 9, title = "Автоматическая кормушка для котов", author = "П. И. Шурупов", rating = 9000,
                      description = "Нужно использовать энергию квазаров для этой цели"},
                #idea{id = 10, title = "Самодвижущаяся лестница", author = "Васисуалий Л.", rating = 42,
                      description = "Имеет большой потенциал применения в небоскребах."}]),
    ok.

setup() ->
    task_1:init().


teardown() ->
    ets:delete(great_ideas_table).

add_idea(Id, Title, Author, Rating, Description) ->
    % case ets:lookup(great_ideas_table, Id) of
        % [] -> 
            ets:insert(great_ideas_table, [#idea{id = Id, title = Title, author = Author, rating = Rating, description = Description}]).
        % [#idea{id = Id}] ->
            % ets:insert(great_ideas_table, [#idea{id = Id, title = Title, author = Author, rating = Rating, description = Description}])
    % end

get_idea(Id) ->
    case ets:lookup(great_ideas_table, Id) of
        [Idea] -> {ok, Idea};
        [] -> not_found
    end.

ideas_by_author(Author) ->
    ets:match_object(great_ideas_table, {idea, '_', '_', Author, '_', '_'}).


ideas_by_rating(Rating) ->
    RatingSelect = ets:fun2ms(fun(#idea{rating = SearchR} = Idea) when SearchR >= Rating -> Idea end),
    ets:select(great_ideas_table, RatingSelect).


get_authors() ->
    AuthorsFun = ets:fun2ms(fun(#idea{author = Author}) -> Author end),
    Authors_1 = ets:select(great_ideas_table, AuthorsFun),
    Authors_2 = lists:foldl(fun(Author, Acc) ->
                            case maps:find(Author, Acc) of
                                {ok, Num} -> Acc#{Author => Num + 1};
                                error -> Acc#{Author => 1}
                            end
                        end,
                        #{}, Authors_1),
    lists:sort(fun({N1, A}, {N2, A}) -> N1 < N2;
                  ({_, A1}, {_, A2}) -> A1 > A2
                end, maps:to_list(Authors_2)).

add_idea_test() ->
    task_1:init(),
    ?assertEqual(10, ets:info(great_ideas_table, size)),
    task_1:add_idea(11, "some idea", "Bob", 100, "some description"),
    ?assertEqual(11, ets:info(great_ideas_table, size)),
    task_1:add_idea(20, "other idea", "Bill", 100, "other description"),
    ?assertEqual(12, ets:info(great_ideas_table, size)),
    task_1:add_idea(20, "other idea", "Bill", 500, "updated description"),
    ?assertEqual(12, ets:info(great_ideas_table, size)),
    ok.

get_idea_test() ->
    setup(),
    ?assertEqual({ok, {idea, 1, "Мороженое с огурцами", "Боб Бобов", 100,
                       "Крошим огурцы кубиками и добавляем в мороженое"}},
                 task_1:get_idea(1)),
    ?assertEqual(not_found, task_1:get_idea(777)),
    task_1:add_idea(777, "some idea", "Bob", 100, "some description"),
    ?assertEqual({ok, {idea, 777, "some idea", "Bob", 100, "some description"}},
                 task_1:get_idea(777)),
    teardown(),
    ok.

ideas_by_author_test() ->
    setup(),
    ?assertEqual([{idea,1,"Мороженое с огурцами","Боб Бобов",100,
                   "Крошим огурцы кубиками и добавляем в мороженое"},
                  {idea,4,"Куртка с тремя рукавами","Боб Бобов",15,
                   "Рукава из разных материалов, расчитаны на разную погоду."},
                  {idea,7,"Вулканический зонт","Боб Бобов",12,
                   "Защищает самолеты от вулканической пыли."}],
                 lists:sort(task_1:ideas_by_author("Боб Бобов"))),
    ?assertEqual([{idea,3,"Извлечение энергии квазаров","П. И. Шурупов",
                   100500,"Секретно"},
                  {idea,9,"Автоматическая кормушка для котов","П. И. Шурупов",
                   9000,"Нужно использовать энергию квазаров для этой цели"}],
                 lists:sort(task_1:ideas_by_author("П. И. Шурупов"))),
    ?assertEqual([], task_1:ideas_by_author("Бил Билов")),
    teardown(),
    ok.


ideas_by_rating_test() ->
    setup(),
    ?assertEqual([{idea,3,"Извлечение энергии квазаров","П. И. Шурупов",
                   100500,"Секретно"}],
                 task_1:ideas_by_rating(100500)),
    ?assertEqual([{idea,3,"Извлечение энергии квазаров","П. И. Шурупов",
                   100500,"Секретно"},
                  {idea,8,"Телефон-шар","Див Стобс",8383,
                   "Удобно лежит в руке, имеет устройство ввода на основе гироскопа"},
                  {idea,9,"Автоматическая кормушка для котов","П. И. Шурупов",
                   9000,"Нужно использовать энергию квазаров для этой цели"}],
                 lists:sort(task_1:ideas_by_rating(1000))),
    teardown(),
    ok.


get_authors_test() ->
    setup(),
    ?assertEqual([{"Боб Бобов",3},
                  {"П. И. Шурупов",2},
                  {"Алекс Аквамаринов",1},
                  {"Билл Билов",1},
                  {"Васисуалий Л.",1},
                  {"Див Стобс",1},
                  {"Олечка",1}],
                 task_1:get_authors()),
    teardown(),
    ok.
