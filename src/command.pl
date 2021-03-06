
status :-
    init(_),
    player(Username,Job,Level,HP,MaxHP,Att,Def,EXP,MaxEXP,Gold),
    write('\nUsername :'),
    write(Username),
    write('\nJob      :'),
    write(Job),
    write('\nLevel    :'),
    write(Level),
    write('\nHealth   :'),
    write(HP),write('/'), write(MaxHP),
    write('\nAttack   :'),
    write(Att),
    write('\nDefense  :'),
    write(Def),
    write('\nEXP      :'),
    write(EXP),write('/'), write(MaxEXP),
    write('\nGold     :'),
    write(Gold).
    
map :-
    init(_),
    printX(0,0),!,
	print_legend.

% Perintah Navigasi:
% Gerak ke atas
w :-
    player_X(TempX),
    player_Y(TempY),
    Next is (TempY - 1),
	(
	Next =:= 0 -> write('Hmmm... You still have a task to do in this world, Traveler!')
	;
	shop(Y,X), Next =:= Y, TempX =:= X ->
		write('You are at Shop! Happy Trading!'),nl,
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		shop
	;
	boss_dungeon(Y,X), Next =:= Y, TempX =:= X ->
		write('You are at The Iron Catacombs! Advance towards pyrrhic victory, Traveler!'),nl,
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		dungeon
	;
	water(Y,X), Next =:= Y, TempX =:= X ->
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
		write('You are at ['),write(Next),write(','),write(TempX),write(']'),
        stamina(N),
        N1 is N - 1,
        (
        N1 =:= 0 ->
			nl,nl,
			print_you_drowned,
            write('\nBetter watch your surroundings next time, Traveler!'),
            quit
        ;
        retract(stamina(N)),
        asserta(stamina(N1))
        )
	;
	quest(Y,X), Next =:= Y, TempX =:= X ->
		write('Ad astra abyssoque! You are at Quest Board!'),nl,
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		questlist
	;
	enemy(ID,_,_,_,_,_,_,Y,X), Next =:= Y, TempX =:= X ->
		(
			ID =:= 1 ->
				print_slime
			;
			ID =:= 2 ->
				print_goblin
			;
			ID =:= 3 ->
				print_wolf
		),
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
        battleMode(X,Next,0,N1),
        randomEnemy,!
	;
	mount(Y,X), Next =:= Y, TempX =:= X ->
		write('This path is too dangerous, better pick another way around, Traveler!')
	;
	retract(player_Y(_)),
	asserta(player_Y(Next)),!,
	write('You are at ['),write(Next),write(','),write(TempX),write(']'),
    retract(stamina(_)),
    asserta(stamina(5))
	).

% Gerak ke kiri
a :-
    player_X(TempX),
    player_Y(TempY),
    Next is (TempX - 1),
	(
	Next =:= 0 -> write('Hmmm... You still have a task to do in this world, Traveler!')
	;
	shop(Y,X), TempY =:= Y, Next =:= X ->
		write('You are at Shop! Happy Trading!'),nl,
		retract(player_X(_)),
		asserta(player_X(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		shop
	;
	boss_dungeon(Y,X), TempY =:= Y, Next =:= X ->
		write('You are at The Iron Catacombs! Advance towards pyrrhic victory, Traveler!'),nl,
		retract(player_X(_)),
		asserta(player_X(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
        dungeon
	;
	water(Y,X), TempY =:= Y, Next =:= X ->
		retract(player_X(_)),
		asserta(player_X(Next)),!,
		write('You are at ['),write(TempY),write(','),write(Next),write(']'),
        stamina(N),
        N1 is N - 1,
        (
        N1 =:= 0 ->
			nl,nl,
			print_you_drowned,
            write('\nBetter watch your surroundings next time, Traveler!'),
            quit
        ;
        retract(stamina(N)),
        asserta(stamina(N1))
        )
	;
    quest(Y,X), TempY =:= Y, Next =:= X ->
		write('Ad astra abyssoque! You are at Quest Board!'),nl,
		retract(player_X(_)),
		asserta(player_X(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		questlist
    ;
    enemy(ID,_,_,_,_,_,_,Y,X), TempY =:= Y, Next =:= X ->
		(
			ID =:= 1 ->
				print_slime
			;
			ID =:= 2 ->
				print_goblin
			;
			ID =:= 3 ->
				print_wolf
		),
		retract(player_X(_)),
		asserta(player_X(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
        battleMode(Next,Y,0,N1),
        randomEnemy,!
    ;
	mount(Y,X), TempY =:= Y, Next =:= X ->
		write('This path is too dangerous, better pick another way around, Traveler!')
	;
	retract(player_X(_)),
	asserta(player_X(Next)),!,
	write('You are at ['),write(TempY),write(','),write(Next),write(']'),
    retract(stamina(_)),
    asserta(stamina(5))
	).

% Gerak ke bawah
s :-
    player_X(TempX),
    player_Y(TempY),
    Next is (TempY + 1),
	(
	Next =:= 34 -> write('Hmmm... You still have a task to do in this world, Traveler!')
	;
	shop(Y,X), TempX =:= X, Next =:= Y ->
		write('You are at Shop! Happy Trading!'),nl,
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		shop
	;
	boss_dungeon(Y,X), TempX =:= X, Next =:= Y ->
		write('You are at The Iron Catacombs! Advance towards pyrrhic victory, Traveler!'),nl,
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
        dungeon
	;
	water(Y,X), TempX =:= X, Next =:= Y ->
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
		write('You are at ['),write(Next),write(','),write(TempX),write(']'),
        stamina(N),
        N1 is N - 1,
        (
        N1 =:= 0 ->
			nl,nl,
			print_you_drowned,
            write('\nBetter watch your surroundings next time, Traveler!'),
            quit
        ;
        retract(stamina(N)),
        asserta(stamina(N1))
        )
	;
    quest(Y,X), TempX =:= X, Next =:= Y ->
		write('Ad astra abyssoque! You are at Quest Board!'),nl,
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		questlist
    ;
    enemy(ID,_,_,_,_,_,_,Y,X), TempX =:= X, Next =:= Y ->
		(
			ID =:= 1 ->
				print_slime
			;
			ID =:= 2 ->
				print_goblin
			;
			ID =:= 3 ->
				print_wolf
		),
		retract(player_Y(_)),
		asserta(player_Y(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
        battleMode(X,Next,0,N1),
        randomEnemy,!
    ;
	mount(Y,X), TempX =:= X, Next =:= Y ->
		write('This path is too dangerous, better pick another way around, Traveler!')
	;
	retract(player_Y(_)),
	asserta(player_Y(Next)),!,
	write('You are at ['),write(Next),write(','),write(TempX),write(']'),
    retract(stamina(_)),
    asserta(stamina(5))
	).

% Gerak ke kanan
d :-
    player_X(TempX),
    player_Y(TempY),
    Next is (TempX + 1),
	(
	Next =:= 34 -> write('Hmmm... You still have a task to do in this world, Traveler!')
	;
	shop(Y,X), TempY =:= Y, Next =:= X ->
		write('You are at Shop! Happy Trading!'),nl,
		retract(player_X(_)),
		asserta(player_X(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		shop
	;
	boss_dungeon(Y,X), TempY =:= Y, Next =:= X ->
		write('You are at The Iron Catacombs! Advance towards pyrrhic victory, Traveler!'),nl,
		retract(player_X(_)),
		asserta(player_X(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
        dungeon
	;
	water(Y,X), TempY =:= Y, Next =:= X ->
		retract(player_X(_)),
		asserta(player_X(Next)),!,
		write('You are at ['),write(TempY),write(','),write(Next),write(']'),
        stamina(N),
        N1 is N - 1,
        (
        N1 =:= 0 ->
			nl,nl,
			print_you_drowned,
            write('\nBetter watch your surroundings next time, Traveler!'),
            quit
        ;
        retract(stamina(N)),
        asserta(stamina(N1))
        )
	;
    quest(Y,X), TempY =:= Y, Next =:= X ->
		write('Ad astra abyssoque! You are at Quest Board!'),nl,
		retract(player_X(_)),
		asserta(player_X(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
		questlist
    ;
    enemy(ID,_,_,_,_,_,_,Y,X), TempY =:= Y, Next =:= X ->
		(
			ID =:= 1 ->
				print_slime
			;
			ID =:= 2 ->
				print_goblin
			;
			ID =:= 3 ->
				print_wolf
		),
		retract(player_X(_)),
		asserta(player_X(Next)),!,
        retract(stamina(_)),
        asserta(stamina(5)),
        battleMode(Next,Y,0,N1),
        randomEnemy,!
    ;
	mount(Y,X), TempY =:= Y, Next =:= X ->
		write('This path is too dangerous, better pick another way around, Traveler!')
	;
	retract(player_X(_)),
	asserta(player_X(Next)),!,
	write('You are at ['),write(TempY),write(','),write(Next),write(']'),
    retract(stamina(_)),
    asserta(stamina(5))
	).

tp :-
	player_X(_),
    player_Y(_),
	write('\nChoose a waypoint:\n'),
	write('1. Monstadt\n'),
	write('2. Liyue Harbor\n'),
	write('3. Qingyun Peak\n\n'),
	read(WPchoice),
	(
		WPchoice =:= 1 ->
			monstadt(Y,X)
		;
		WPchoice =:= 2 ->
			liyue_harbor(Y,X)
		;
		WPchoice =:= 3 ->
			qingyun_peak(Y,X)
	),
	retract(player_Y(_)),
	retract(player_X(_)),
	asserta(player_Y(Y)),
	asserta(player_X(X)).

cancel :-
	write('\n').