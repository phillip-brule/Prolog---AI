%basic bubble sort for ints
bubblesort(List,Sorted):-
	swap(List,List1), !, bubblesort(List1,Sorted).
bubblesort(Sorted,Sorted).

swap([X,Y|T], [Y,X|T]):- X > Y.
swap([H|T], [H|Result]):- swap(T,Result).


%basic insertion sort
insertsort([],[]).
insertsort([X|T], Sorted):-
	insertsort(T, SortedT),
	insert(X, SortedT, Sorted).

insert(X,[Y|Sorted],[Y|Sorted1]):- X > Y, !, insert(X,Sorted,Sorted1).
insert(X,Sorted, [X|Sorted]).

%quick sort using difference lists
quicksort(List, Sorted):-
	quicksort2(List, Sorted-[]).

quicksort2([], Z-Z).
quicksort2([X|T], A1-Z1):-
	split(X, T, Small, Big),
	quicksort2(Small, A1-[X|A2]),
	quicksort2(Big,A2-Z2).

split(X,[],[],[]).
split(X,[Y|T],[Y|Small],Big):- X > Y,!, split(X,T,Small, Big).
split(X, [Y|T], Small, [Y|Big]):-split(X,T,Small,Big).


%9.1
%merge of sorted lists
merge(List,[], List).
merge([], List, List).
merge([X|Tail1],[Y|Tail2],[X|Result]):- X < Y, !, merge(Tail1,[Y|Tail2],Result).
merge(List, [Y|Tail], [Y|Result]):-merge(List,Tail,Result).

%9.4 mergesort
mergesort([],[]).
mergesort([X],[X]).
mergesort([X,Y], Sorted):- merge([X],[Y],Sorted).
mergesort(List, Sorted):-
	split_list(List,List1,List2),%split list into two halves and sort each half
	mergesort(List1,Sorted1),
	mergesort(List2,Sorted2),
	merge(Sorted1,Sorted2,Sorted). %merge two sorted lists

split_list(List, A, B):-
	split_list(List, List, A, B).
split_list(List, [], [], List).
split_list(List, [X], [], List).
split_list([H|T], [_,_|Tail1], [H|Tail2], List):-
	split_list(T,Tail1,Tail2,List).

 
 %9.5
%unsorted binary tree
binarytree(nil).
binarytree(t(L,X,R)):- binarytree(R), binarytree(L). %t = tree, L=left tree, R=right tree, X = root
%sorted binary tree
itemGrThanTree(_,nil).
itemGrThanTree(Item, t(_,X,_)):- Item > X.
itemLsThanTree(_,nil).
itemLsThanTree(Item, t(_,X,_)):- Item < X.
dictionary(nil).
dictionary(t(L,X,R)):-dictionary(L), dictionary(R), itemGrThanTree(X,L), itemLsThanTree(X,R).


%9.6
%simple max between heights
maxHeight(X,Y,X):- X > Y, !.
maxHeight(X,Y,Y).
height(nil,0).
height(t(L,X,R),Height):- height(L,H1), height(R,H2), maxHeight(H1,H2,Max), Height is Max+1.

%9.7 
%linearizes a tree into a list both methods use normal recursion and not tail recursion.
append_list([],L,L). %O(N) N being size of first list
append_list([H|T],L,[H|Rest]):- append_list(T,L,Rest). 
linearize(nil, []). %O(nlogn)  recursive formula: T(n) = 2T(n/2) + n/2 = nlogn 
linearize(t(L,X,R), [X|Rest]):- linearize(L,Tail1), linearize(R,Tail2), append_list(Tail1,Tail2,Rest).

%9.10
%evaluates arithmetic expresion
evaluate(X,R):- R is X.
%displays tree visually
show(Tree):- height(Tree,H), linearize(Tree,TreeList), show2(TreeList,H,0,1).
show2([],_,_,_).
%show2(TreeList, Indentation for each element, current lvl, element at current height)
show2([H|T],Indent,Level,Element):- 
	evaluate(2**Level, Lvl), Element == Lvl, !, Ind2 is Indent // 2, Level2 is Level+1, tab(Indent), write(H), nl, show2(T,Ind2,Level2,1).
show2([H|T],Indent,Level,Element):-
	Element2 is Element + 1, tab(Indent*Element), write(H), show2(T,Indent,Level,Element2).
