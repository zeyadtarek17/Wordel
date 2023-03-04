
main:-
	write('Welcome to Pro-Wordle!'),nl,
	
	write('----------------------'),nl,
	build_kb,
	write('The available categories are:'),categories(L2),write(L2),nl,
	play.

build_kb:-
	write('Please enter a word and its category on separate lines:'),nl,
	read(X),
	(
	X=done , 
	write('Done building the words database...');
	read(Y),
	assert(word(X,Y)),
	build_kb
	).

play:- chooseCategory(C),
       chooseLength(L,C),
       pick_word(W,L,C),
       G is L+1,
	   write('Game started. You have '), write(G), write(' guesses.'),nl,
       gameLoop(W,L,C,G).
	

chooseCategory(C):-
	write("Choose a category"),nl,
	read(X),
	(
	is_category(X),C=X;
	write("This category doesn't exist"),nl,chooseCategory(C)
	).

chooseLength(L,C):-
	write('Choose a length'),nl,
	read(X),
	(
	word(W,C),
	string_length(W,X),L=X;
	write('There are no words of this length.'),nl,
	chooseLength(L,C)
	).

gameLoop(W,L,C,G):- 
	
	write('Enter a word composed of '),write(L),write(' letters'),nl,
	read(X),
	(
	(string_length(X,O),O\==L,write('Word is not composed of '),write(L),write(' letters. Try again. '),
	write('Remaining Guesses are '),write(G),nl,gameLoop(W,L,C,G)) ;
	(X==W,write('You won')); 
	(G1 is G-1, G1==0,write('You lost') );
	(atom_chars(X,L1),length(L1,L),atom_chars(W,L2),correct_letters(L1,L2,R1),
	write('Correct lettters are: '),write(R1),nl, 
	correct_positions(L1,L2,R2),write('Correct lettters in correct positions are: '), write(R2), nl,
	write('Remaining Guesses are '),G1 is G-1,write(G1),nl,gameLoop(W,L,C,G1))).

is_category(C):-
	word(_,C).

categories(L):-
	setof(B,is_category(B),L).
same([],[]).
same([H1|T1],[H2|T2]):-
	H1==H2,
	same(T1,T2).

available_length(L):-
	word(X,_),
	atom_length(X,L).
pick_word(W,L,C):-
	word(W,C),
	atom_length(W,L).
correct_letters(L1,L2,CL):-
	intersection(L1,L2,CL).
correct_positions([H1|T1],[H2|T2],L):-
	H1\==H2,
	correct_positions(T1,T2,L).
correct_positions([H1|T1],[H2|T2],[H1|T3]):-	
	H1==H2,
	correct_positions(T1,T2,T3).
correct_positions([],[],[]).		