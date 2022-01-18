class(Number, positive) :- Number > -1, !.
class(Number, negative).


split([H|[]], [H], []):- class(H, positive).
split([H|[]], [], [H]):- class(H, negative).
split([H|L], [H|Lpos], Lneg ):- class(H, positive), split(L, Lpos, Lneg).
split([H|L], Lpos, [H|Lneg] ):- class(H, negative), split(L, Lpos, Lneg).

splitCut([H|[]], [H], []):- H > -1,!.
splitCut([H|[]], [], [H]).
splitCut([H|L], [H|Lpos], Lneg ):- class(H, positive), split(L, Lpos, Lneg),!.
splitCut([H|L], Lpos, [H|Lneg] ):- split(L, Lpos, Lneg).