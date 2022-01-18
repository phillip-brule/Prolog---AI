
%add X at end of list function
%first normal recursive implementation
add_at_end([], X, [X]).
add_at_end([H|T], X, [H|NewList]):-
	add_at_end(T, X, NewList).

/*concat_(List - H1, H1-H2, List - H2). %simple concat using difference lists
add_at_end2(List, Item, NewList):-
	concat_([List|H1] -H1, [Item|H2] - H2, NewList - H2). %use concat method to insert faster at end of list.
*/


add_at_end3(List - [Item], [Item] - H2, List - H2). % using difference lists 
% example of use add_at_end3([1,2,3,4,5|H1]-H1,[6]-H2,X-H2) X is wanted list


%8.3
reverse(List, Reversed):- reverse_help(List, Reversed-[]).
reverse_help([], R-R).
reverse_help([H|T], L-R) :- reverse_help(T, L-[H|R]).


%8.5 Tail Recursive Max Function
max([X|T], Max):- max(T, X, Max).
max([], Max, Max).
max([H|T], CurrentMax, Max):- H > CurrentMax, !, max(T,H,Max).
max([H|T], CurrentMax, Max):- max(T,CurrentMax,Max).