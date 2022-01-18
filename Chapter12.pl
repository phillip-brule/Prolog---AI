%bestfirst alg from start to a goal
bestfirst(Start, Solution):- expand([], 1(Start, 0/0),9999,yes,Solution). %9999 is greater than any f value

%expand(Path, Tree, Bound, Tree1, Solved, Solution):
	%% Path is between start node to the current Tree
	%% Tree1 is Tree expanded within Bound,
	%% if goal found then Solution is the Solution path and Solved = yea
%Case 1 current leaf node is goal node. construct solution path

expand(P,1(N,_),_,_,yes,[N|P]):-
	goal(N).

%Case 2 leaf node has f-value less than Bound
%Generates successors and expand them within Bound

expand(P,1(N,F/G),Bound,Tree1,Solved,Sol):-
	F=<Bound,
	(bagof(M/C,(s(N,M,C), not(member(M,P)),Succ),!
		succlist(G,Succ,Ts),
		bestf(Ts,F1),
		expand(P,t(N,F1/G,Ts),Bound,Tree1,Solved,Sol);
		Solved = never).


%Case 3 non leaf f-value less than bound
%Expand the most promising subtree; depending on results,
%procedure continues to decide

expand(P,t(N,F/G,[T|Ts]),Bound,Tree1,Solved,Sol):-
	F=<Bound,
	bestf(Ts,BF),min(Bound,BF,Bound1),
	expand([N|P],T,Bound1,T1,Solved1,Sol),
	continue(P,t(N,F/G,[T1,Ts]),Bound,Tree1,Solved1,Solved,Sol).

%Case 4 non leaf with empty subtrees which is a dead end case.
expand(_,t(_,_,[]),_,_,never,_):- !.

%Case 5 f-value greater than bound so no solution found here
expand(_,Tree,Bound,Tree,no,_):-
	f(Tree,F), F > Bound.


%continue(Path,Tree,Bound,NewTree,SubtreeSolved,TreeSolved,Solution)
continue(_,_,_,_,yes,yes,Sol).

continue(P,t(N,F/G,[T|Ts]),Bound,Tree1,no,Solved,Sol):-
	insert(T1,Ts,NTs),
	bestf(NTs,F1),
	expand(P,t(N,F1/G,NTs),Bound,Tree1,Solved,Sol).

continue(P,t(N,F/G,[_|Ts]),Bound,Tree1,never,Solved,Sol):-
	bestf(Ts,F1),
	expand((P,t(N,F/G,Ts),Bound,Tree1,no,Solved,Sol)).

%succlist(G0,[Node1,/Cost1,...],[1(BestNode,BestF/G),....]) makes list of search leaves ordered by f value
succlist(_,[],[]).

succlist(G0,[N/C|NCs],Ts):-
	G is G0 + C,
	h(N,H)  %H is heuristic value for N
	F is G + H,  %creating f value
	succlist(G0,NCs,Ts1),
	insert(1(N,F/G),Ts1,Ts).

%insert T into list of trees Ts with ordered by f values
insert(T,Ts,[T|Ts]):-
	f(T,F),bestf(Ts,F1),
	F=<F1,!.

insert(T,[T1|Ts],[T1|Ts1]):-
	insert(T,Ts,Ts1).

%extract f value
f(1(_,F/_),F). %leaf case
f(t(_,F/_,_),_). %tree case

bestf([T|_],F):-
	f(T,F).
bestf([],9999).


%Applying A* Best first search alg to the eight peice puzzle with space. 
%x/y positioning with the list representing coordinates of [Empty,1,2,3,4,5,6,7,8]
/*goal positioning  
	  1 2 3 
	  8   4
	  7 6 5
  */
goal([2/2, 1/3,2/3,3/3,3/2,3/1,2/1,1/1,1/2]).

% s(Node,SuccessorNode,Cost)
s([Empty|Tiles],[Tile|Tiles1],1):-
	swap(Empty,Tile,Tiles,Tiles1). %swap empty and tile in tiles giving tiles1

swap(Empty,Tile,[Tile|Ts],[Empty|Ts]):- % Tile's position is put at front in calling function Empty's position is now where tile sits
	mandist(Empty,Tile,1). %swap only performed if distance is 1

swap(Empty,Tile,[T1|Ts],[T1|Ts1]):-
	swap(Empty,Tile,Ts,Ts1). %keep calling swap going down the list until Tile is found at front

mandist(X/Y, X1/Y1,D):-
	diff(X,X1,Dx),
	diff(Y,Y1,Dy),
	D is Dx + Dy.

diff(A,B,D):- % D is |A-B|
	D is A-B, D >= 0,!
	; D is B-A.

%heuristic h is the sum of distances of each tile from its goal spot, plust 3x seq score
h([Empty|Tiles],H):-
	goal([Empty1|GoalSquares]),
	totdist(Tiles,GoalSquares,D), %total distance from goals
	seq(Tiles,S),
	H is D+3*S.

totdist([],[],0).

totdist([Tile|Tiles],[Square|Squares],D):-
	mandist(Tile,Square,D1),
	totdist(Tiles,Squares,D2),
	D is D1 + D2.

%seq(Tiles, Score) the score of this sequence.
seq([First|OtherTiles],S):-
	seq([First|OtherTiles],First,S).

seq([Tile1,Tile2|Tiles],First,S):-
	score(Tile1,Tile2,S1),
	seq([Tile2|Tiles],First,S2).
	S is S1+S2.

seq([Last],First,S):-
	score(Last,First,S).

score(2/2,_,1):- !. %Tile in center scores 1
%successor tiles meaning follows ordering shown in goal positioning
score(1/3,2/3, 0):- !.
score(2/3,3/3, 0):- !.
score(3/3,3/2, 0):- !.
score(3/2,3/1, 0):- !.
score(3/1,2/1, 0):- !.
score(2/1,1/1, 0):- !.
score(1/1,1/2, 0):- !.
score(1/2,1/3, 0):- !.
%Out of order tiles score 2
score(_,_,2).

showsol([]).

showsol([P|L]):=
	showsol([L]),
	nl, write('---'),
	showpos(P).

showpos([S0,S1,S2,S3,S4,S5,S6,S7,S8]):-
	member(Y,[3,2,1]),
	nl, member(X,[1,2,3]),
	member(Tile-X/Y, [''-S0,1-S1,2-S2,3-S3,4-S4,5-S5,6-S6,7-S7,8-S8]),
	write(Tile), fail,
	;true.

start1([2/2,1/3,3/2,2/3,3/3,3/1,2/1,1/1,1/2]).

%example query: start1(Pos),bestfirst(Pos,Sol),showsol(Sol).