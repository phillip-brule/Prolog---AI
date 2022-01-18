%11.2
%setting state soace and goal
s(a,b).
s(b,c).
s(c,d).
goal(d).
not_member(Node,[]).
not_member(Node,[H|T]):- Node \= H, not_member(Node,T).
%depth first search with cycle detection and depth limiting using count and 
depthfirst(Path,Node,[Node],_):- goal(Node). %return goal as last Node in solution.
depthfirst(Path,Node,[Node|Sol],MaxDepth):-
	MaxDepth > 0,
	s(Node,Node1), %s = state space, this checks that there is an edge between Node and Node1
	not_member(Node1,Path), %prevent cycle
	Max1 is MaxDepth -1, % decrement depth to be traversed before recursive call
	depthfirst([Node|Path], Node1, Sol, Max1). %return Sol - the solution from goal node to current starting node

% Example run ?- depthfirst([],a,Sol,3).  nl Sol = [a, b, c, d] .