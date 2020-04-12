route(dublin, cork, 200, 'fct').
route(cork, dublin, 200, 'fct').
route(cork, corkAirport, 20, 'fc').
route(corkAirport, cork, 25, 'fc').
route(dublin, dublinAirport, 10, 'fc').
route(dublinAirport, dublin, 20, 'fc').
route(dublinAirport, corkAirport, 225, 'p').
route(corkAirport, diblinAirport, 225, 'p').

verify(P1,P2,Trans,Time) :- route(P1,P2,Km,Modes), atom_chars(Modes,List), member(p,List), atom_chars(Trans,List1), member(p,List1), Time is Km / 500 * 60,!.
verify(P1, P2,Trans,Time) :- route(P1,P2,Km,Modes), atom_chars(Modes,List), member(t,List), atom_chars(Trans,List1), member(t,List1), Time is Km / 100 * 60,!.
verify(P1,P2,Trans,Time) :- route(P1,P2,Km,Modes), atom_chars(Modes,List), member(c,List), atom_chars(Trans,List1), member(c,List1), Time is Km / 80 * 60,!.
verify(P1, P2,Trans,Time) :- route(P1,P2,Km,Modes), atom_chars(Modes, List), member(f, List), atom_chars(Trans,List1), member(f,List1), Time is Km / 5 * 60,!.

getroute(P1, P2, Visited,Modes, Final,Time) :- route(P1,P2,_,_), append([P2, P1],Visited, List), reverse(List, Final),verify(P1,P2,Modes,Time).
getroute(P1, P2, Visited,Modes, Final,Time) :- route(P1,P3,_,_),\+member(P3, Visited),getroute(P3, P2, [P1|Visited],Modes, Final,Newtime),
  verify(P1,P3,Modes,Dibs),Time is Newtime + Dibs.

buildlib(P1,P2,Minutes,Mode) :-getroute(P1,P2,[],Mode,_,_),  bagof(Times,Final, getroute(P1,P2,[],Mode,Final,Times), Time), min_member(Minutes,Time),!.

journey(S,D,M) :- write('Time in minutes: ') ,buildlib(S,D,Minutes,M), write(Minutes).