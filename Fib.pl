% improving efficiency of fib sequence through asserting facts aka caching


% innefficient fib sequence follows
fib(1,1).
fib(2,1).
fib(N,F):-
	N > 2,
	N1 is N - 1, fib(N1, F1),
	N2 is N - 2, fib(N2, F2), % many computations are redone when computing fib(N2, F2) that where just done in the previous line.
	F is F1 + F2.

% making fib more efficient using asserta
fib2(1,1).
fib2(2,1).
fib2(N,F):-
	N > 2,
	N1 is N - 1, fib2(N1, F1),
	N2 is N - 2, fib2(N2, F2), %Now the program may see this goal already is listed from running the previous goal or a different run of fib2
	F is F1 + F2,
	asserta(fib2(N,F)).



%forward fibinacci sequence - changing algorithm to improve efficiency, start from base numbers and calculate up to Nth number
fib3(N,F):- fib3(2, N, 1, 1, F). % we start with knowing the result for the first 2 numbers, which are 1 and 1
fib3(M,N,F1,F2,F2) :- M >= N. %Once M == N the sequence should stop as we have computed
fib3(M,N,F1,F2,F):-  %M,F1,F2 are all accumulators
	M < N,
	NextM is M + 1,
	NextF2 is F1 + F2,
	fib3(NextM, N, F2, NextF2, F). % this is tail recursive as prolog can optimize, forget everything else and just return the result of this call.