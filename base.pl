:-set_prolog_flag(answer_write_options,[max_depth(0)]).
:-dynamic(edge/2).
% -----------------------------------------------------------------------
% Trabalho pratico: factos de cidades com localiza��o baseada em
% latitude e longitude e predicado auxiliar para calcular a dist�ncia
% entre quaisquer duas destas cidades.
% ------------------------------------------------------------------------

%city(name,latitude,longitude)
city(brussels,50.8462807,4.3547273).
city(tirana,41.33165,19.8318).
city(andorra,42.5075025,1.5218033).
city(vienna,48.2092062,16.3727778).
city(minsk,53.905117,27.5611845).
city(sarajevo,43.85643,18.41342).
city(sofia,42.6976246,23.3222924).
city(zagreb,45.8150053,15.9785014).
%city(nicosia,35.167604,33.373621).
%city(prague,50.0878114,14.4204598).
%city(copenhagen,55.6762944,12.5681157).
%city(london,51.5001524,-0.1262362).
%city(tallinn,59.4388619,24.7544715).
%city(helsinki,60.1698791,24.9384078).
%city(paris,48.8566667,2.3509871).
%city(marseille,43.296386,5.369954).
%city(tbilisi,41.709981,44.792998).
%city(berlin,52.5234051,13.4113999).
%city(athens,37.97918,23.716647).
%city(budapest,47.4984056,19.0407578).
%city(reykjavik,64.135338,-21.89521).
%city(dublin,53.344104,-6.2674937).
%city(rome,41.8954656,12.4823243).
%city(pristina,42.672421,21.164539).
%city(riga,56.9465346,24.1048525).
%city(vaduz,47.1410409,9.5214458).
%city(vilnius,54.6893865,25.2800243).
%city(luxembourg,49.815273,6.129583).
%city(skopje,42.003812,21.452246).
%city(valletta,35.904171,14.518907).
%city(chisinau,47.026859,28.841551).
%city(monaco,43.750298,7.412841).
%city(podgorica,42.442575,19.268646).
%city(amsterdam,52.3738007,4.8909347).
%city(belfast,54.5972686,-5.9301088).
%city(oslo,59.9138204,10.7387413).
%city(warsaw,52.2296756,21.0122287).
%city(lisbon,38.7071631,-9.135517).
%city(bucharest,44.430481,26.12298).
%city(moscow,55.755786,37.617633).
%city(san_marino,43.94236,12.457777).
%city(edinburgh,55.9501755,-3.1875359).
%city(belgrade,44.802416,20.465601).
%city(bratislava,48.1483765,17.1073105).
%city(ljubljana,46.0514263,14.5059655).
%city(madrid,40.4166909,-3.7003454).
%city(stockholm,59.3327881,18.0644881).
%city(bern,46.9479986,7.4481481).
%city(kiev,50.440951,30.5271814).
%city(cardiff,51.4813069,-3.1804979).

%  dist_cities(brussels,prague,D).
%  D = 716837.
dist_cities(C1,C2,Dist):-
    city(C1,Lat1,Lon1),
    city(C2,Lat2,Lon2),
    distance(Lat1,Lon1,Lat2,Lon2,Dist).

degrees2radians(Deg,Rad):-
	Rad is Deg*0.0174532925.

% distance(latitude_first_point,longitude_first_point,latitude_second_point,longitude_second_point,distance
% in meters)
distance(Lat1, Lon1, Lat2, Lon2, Dis2):-
	degrees2radians(Lat1,Psi1),
	degrees2radians(Lat2,Psi2),
	DifLat is Lat2-Lat1,
	DifLon is Lon2-Lon1,
	degrees2radians(DifLat,DeltaPsi),
	degrees2radians(DifLon,DeltaLambda),
	A is sin(DeltaPsi/2)*sin(DeltaPsi/2)+ cos(Psi1)*cos(Psi2)*sin(DeltaLambda/2)*sin(DeltaLambda/2),
	C is 2*atan2(sqrt(A),sqrt(1-A)),
	Dis1 is 6371000*C,
	Dis2 is round(Dis1).

% distance(50.8462807,4.3547273,50.0878114,14.4204598,D).
% Online: http://www.movable-type.co.uk/scripts/latlong.html
%

% Given three colinear points p, q, r, the function checks if
% point q lies on line segment 'pr'
%onSegment(P, Q, R)
onSegment((PX,PY), (QX,QY), (RX,RY)):-
    QX =< max(PX,RX),
    QX >= min(PX,RX),
    QY =< max(PY,RY),
    QY >= min(PY,RY).

 
% To find orientation of ordered triplet (p, q, r).
% The function returns following values
% 0 --> p, q and r are colinear
% 1 --> Clockwise
% 2 --> Counterclockwise

orientation((PX,PY), (QX,QY), (RX,RY), Orientation):-
	Val is (QY - PY) * (RX - QX) - (QX - PX) * (RY - QY),
	
	(
		Val == 0, !, Orientation is 0;
		Val >0, !, Orientation is 1;
		Orientation is 2
	).
 
orientation4cases(P1,Q1,P2,Q2,O1,O2,O3,O4):-
    orientation(P1, Q1, P2,O1),
    orientation(P1, Q1, Q2,O2),
    orientation(P2, Q2, P1,O3),
    orientation(P2, Q2, Q1,O4).
 
% Funções de interceptions 
 
% The main function that returns true if line segment 'p1q1'
% and 'p2q2' intersect.
doIntersect(P1,Q1,P2,Q2):-
    % Find the four orientations needed for general and
    % special cases
	orientation4cases(P1,Q1,P2,Q2,O1,O2,O3,O4),
	
	(	
    % General case
    O1 \== O2 , O3 \== O4,!;

    % Special Cases
    % p1, q1 and p2 are colinear and p2 lies on segment p1q1
    O1 == 0, onSegment(P1, P2, Q1),!;
 
    % p1, q1 and p2 are colinear and q2 lies on segment p1q1
    O2 == 0, onSegment(P1, Q2, Q1),!;
 
    % p2, q2 and p1 are colinear and p1 lies on segment p2q2
    O3 == 0, onSegment(P2, P1, Q2),!;
 
     % p2, q2 and q1 are colinear and q1 lies on segment p2q2
    O4 == 0, onSegment(P2, Q1, Q2),!
    ).

%----------------------------------------------------------------------------------------------------
% rGraph(Origin,UnorderedListOfEdges,OrderedListOfEdges)
%
% Examples:
% ---------
% ?- rGraph(a,[[a,b],[b,c],[c,d],[e,f],[d,f],[e,a]],R).
%
% ?- rGraph(brussels,[[vienna, sarajevo], [sarajevo, tirana],[tirana,sofia], [sofia, minsk], [andorra,brussels],[brussels,minsk],[vienna,andorra]],R).
%
%
rGraph(Orig,[[Orig,Z]|R],R2):-!,
	reorderGraph([[Orig,Z]|R],R2).
rGraph(Orig,R,R3):-
	member([Orig,X],R),!,
	delete(R,[Orig,X],R2),
	reorderGraph([[Orig,X]|R2],R3).
rGraph(Orig,R,R3):-
	member([X,Orig],R),
	delete(R,[X,Orig],R2),
	reorderGraph([[Orig,X]|R2],R3).


reorderGraph([],[]).

reorderGraph([[X,Y],[Y,Z]|R],[[X,Y]|R1]):-
	reorderGraph([[Y,Z]|R],R1).

reorderGraph([[X,Y],[Z,W]|R],[[X,Y]|R2]):-
	Y\=Z,
	reorderGraph2(Y,[[Z,W]|R],R2).

reorderGraph2(_,[],[]).
reorderGraph2(Y,R1,[[Y,Z]|R2]):-
	member([Y,Z],R1),!,
	delete(R1,[Y,Z],R11),
	reorderGraph2(Z,R11,R2).
reorderGraph2(Y,R1,[[Y,Z]|R2]):-
	member([Z,Y],R1),
	delete(R1,[Z,Y],R11),
	reorderGraph2(Z,R11,R2).
    
    
%------------------------------------------------------------------------------------------------------------------
	
% Iteração 1 (Pergunta 1)

tsp1(City, Path, Cost) :-
	findall((Caminho, Custo),
		(caminho_hamiltoniano(City, Caminho), custo(Caminho, Custo)), Solucoes),
		sort(2, @<, Solucoes, [(Path, Cost)|_]).

caminho_hamiltoniano(Origem, Caminho) :-
	caminho(Origem, fim, Caminho1),
	reverse(Caminho1, [_|Caminho2]),
	reverse([Origem|Caminho2], Caminho),
	findall(C, city(C, _, _), Nodos),
	length(Nodos, L1),
	L2 is L1 + 1,
	length(Caminho, L2).

caminho(Origem, Destino, Caminho) :-
	caminho1(Origem, [Destino], Caminho).

caminho1(A, [A|Caminho], [A|Caminho]).
caminho1(A, [Y|Caminho1], Caminho) :-
	ligacao(X, Y), 
	\+ member(X, Caminho1),
	caminho1(A, [X, Y|Caminho1], Caminho).

ligacao(X, Y) :- edge(X, Y); edge(Y, X).	
	
createGraph() :-
	findall(C, city(C,_,_), L),
	append(L, [fim], LS),
	createEdges(LS).

createEdges([]).
createEdges([H|T]) :- createEdge(H, T), createEdges(T).

createEdge(A, [B]) :- assertz(edge(A, B)), !.
createEdge(A, [B|T]):- assertz(edge(A, B)), createEdge(A, T).

custo([_], 0):- !.
custo([A,B|T], C) :- 
	dist_cities(A, B, C1),
	custo([B|T], C2),
	C is C1 + C2.

% -----------------------------------------------------------------------------------------------------------------------

% Iteração 2 (Pergunta 3)

tsp2(City, Caminho, Custo):-
	% Encontrar todas as cidades que não City.
	findall(C, (city(C, _,_), C \= City), L),
	tsp2_aux(City, L, Solucao),
	append([City],Solucao, CaminhoSemVolta), /*Concatnação da primeira cidade com o resultado*/
	append(CaminhoSemVolta, [City], Caminho), /*Volta*/
	custo(Caminho, Custo).

tsp2_aux(_, [], []):- !. 
tsp2_aux(City, CidadesAVisitar, [ProximaCidade|Caminho]) :-
	findall((C, D), (member(C, CidadesAVisitar), dist_cities(City, C, D)), L),
	sort(2, @<, L, ListaNova), 
	primeiro(ListaNova,(ProximaCidade,_)),
	delete(CidadesAVisitar, ProximaCidade, RestantesCidadesAVisitar),
	tsp2_aux(ProximaCidade, RestantesCidadesAVisitar, Caminho).

primeiro([H|_], H).

% -----------------------------------------------------------------------------------------------------------------------

% Iteração 3 (Pergunta 4)

tsp3(City, Path, Cost):-
	tsp2(City, Caminho, _),
	gerar_segmentos(Caminho, Segmentos),
	eliminarCruzamentos(Segmentos, Circuito),
	rGraph(City, Circuito, Circuito1), !, desfazerSegmentos(Circuito1, Path),
	custo(Path, Cost).
	
	

desfazerSegmentos([[A, B]], [A, B]):-!.
desfazerSegmentos([[A,_]|Resto], [A|Resto1]):-desfazerSegmentos(Resto, Resto1).
	

adicionarSegmento(A, B, C, D, Segmentos, SegmentosFinais):-
		\+member([A, C], Segmentos),
		\+member([C, A], Segmentos), !,
		append([[A, C]], Segmentos, SegmentosFinais1),
		append([[B, D]], SegmentosFinais1, SegmentosFinais).
adicionarSegmento(A, B, C, D, Segmentos, SegmentosFinais):-
	append([[A, D]], Segmentos, SegmentosFinais1),
	append([[B, C]], SegmentosFinais1, SegmentosFinais).


eliminarCruzamentos(Segmentos, Segmentos):-
	% Lista de Cruzamentos
	findall(([A,B],[C,D]), 
		(member([A,B], Segmentos), member([C,D], Segmentos), city(A, Ax, Ay), city(B, Bx, By), city(C, Cx, Cy), city(D, Dx, Dy), 
		A\==C, A\==D, B\==C, B\==D,  doIntersect((Ax,Ay), (Bx,By), (Cx,Cy), (Dx,Dy))), []), !.
eliminarCruzamentos(Segmentos, Circuito):-
	% Lista de Cruzamentos
	findall(([A,B],[C,D]), 
		(member([A,B], Segmentos), member([C,D], Segmentos), city(A, Ax, Ay), city(B, Bx, By), city(C, Cx, Cy), city(D, Dx, Dy), 
		A\==C, A\==D, B\==C, B\==D,  doIntersect((Ax,Ay), (Bx,By), (Cx,Cy), (Dx,Dy))), [Cruzamento|_]),
	eliminarCruzamento(Cruzamento, Segmentos, Circuito1),!,
	eliminarCruzamentos(Circuito1, Circuito).

eliminarCruzamento(([A, B],[C, D]), Segmentos, Circuito):-
	delete(Segmentos, [A, B], S1),
	delete(S1, [C, D], S2),
	dist_cities(A, C, Dac), dist_cities(A, D, Dad),
	
	(
	
		(Dac < Dad, !, adicionarSegmento(A, B, C, D, S2, Circuito));
		
		(adicionarSegmento(A, B, D, C, S2, Circuito))
	
	
	
	).
			
gerar_segmentos([], []):-!.
gerar_segmentos([_], []):-!.
gerar_segmentos([A,B|T], [[A, B]|Resto]):-
	gerar_segmentos([B|T], Resto).


%--------------------------------------------------------------------------------------------------------------------------------------
% Iteração 4 (Pergunta 5)	

tsp4(City, Path, Cost):- executar([Caminho|_]), rotacao(City, Caminho, Caminho1), append(Caminho1, [City], Path), custo(Path, Cost).

rotacao(Origem, [Origem|T], [Origem|T]):-!.
rotacao(Origem, [H|T], Solucao):-
	append(T, [H], L),
	rotacao(Origem, L, Solucao).

geracoes(100).
populacao(8).
cidades(8).
%prob_cruzamento(0.4).
prob_mutacao(0.5).

executar(Populacao):-
	gerar_populacao(Pop),
	ordenar_populacao(Pop, PopOrd),
	geracoes(G),
	gerar_geracao(G, PopOrd, Populacao).

cruzamento([], []):-!.
cruzamento([A], [A]):-!.	
cruzamento([Ind1, Ind2|Resto], [Ind1, Ind2, NInd1, NInd2|Resto1]):-
		%gerar_pontos_cruzamento(P1, P2),
		cruzar(Ind1, Ind2, 2, 4, NInd1, NInd2),
		cruzamento(Resto, Resto1).
		
gerar_pontos_cruzamento(P1,P2):-
	cidades(N),
	Tamanho is N + 1,
	random(1, Tamanho, A),
	random(1, Tamanho, B),
	%A\==B,
	((A < B, !, P1 = A, P2 = B);
	P1 = B, P2 = A).
	
cruzar(Ind1, Ind2, P1, P2, NInd1, NInd2):-
	cidades(Cidades),
	Length is Cidades + 1,
	
	%Partir os Individuos pelos pontos de cruzamento.
	sublista(Ind1, 1, P1, Ind11),
	sublista(Ind1, P1, P2, Ind12),
	sublista(Ind1, P2, Length, Ind13),
	sublista(Ind2, 1, P1, Ind21),
	sublista(Ind2, P1, P2, Ind22),
	sublista(Ind2, P2, Length, Ind23),
	
	%Marcar repeditos.
	append(Ind11, Ind13, Ind1Parcial),
	append(Ind21, Ind23, Ind2Parcial),
	repetidos(Ind12, Ind2Parcial, Ind12Marcado),
	repetidos(Ind22, Ind1Parcial, Ind22Marcado),
	
	%Reagrupar os Novos Indivíduos.
	append(Ind11, Ind22Marcado, NInd1Temp),
	append(NInd1Temp, Ind13, NInd1Marcado),
	append(Ind21, Ind12Marcado, NInd2Temp),
	append(NInd2Temp, Ind23, NInd2Marcado),
	
	%Subsituir os Genes Marcados.
	findall(C, (city(C, _, _), \+member(C, NInd1Marcado)), LInd1),
	findall(C, (city(C, _, _), \+member(C, NInd2Marcado)), LInd2),
	substituir(NInd1Marcado, LInd1, NInd1),
	substituir(NInd2Marcado, LInd2, NInd2).

substituir([], _, []):-!.
substituir(A, [], A):-!.
substituir([H|T], [M|U], [A|R]):-
	(H == 'X', A = M, substituir(T, U, R), !);
	(A = H, substituir(T, [M|U], R)).
	
repetidos([], _, []):-!.
repetidos([H|T], L, [A|R]):-
	((member(H, L),  A ='X', !); A=H),
	repetidos(T, L, R).	

sublista(_, 1, 1, []):-!.
sublista([H|T], 1, Indice2, [H|R]):-
	NIndice2 is Indice2 - 1,
	sublista(T, 1, NIndice2, R), !.
sublista([_|T], Indice1, Indice2, R):-
	NIndice1 is Indice1 - 1,
	NIndice2 is Indice2 - 1,
	sublista(T, NIndice1, NIndice2, R).
	
gerar_geracao(0, Pop, Pop):-
	%write('Geracao 0:'), nl, write(Pop), nl,
	!.
	
gerar_geracao(G, Pop, Populacao):-
	%write('Geracao '), write(G), write(':'), nl, write(Pop), nl, !,
	cruzamento(Pop, NPop1),
	mutacao(NPop1, NPopMut),
	ordenar_populacao(NPopMut, NPopOrd),
	selecao(NPopOrd, NPopSel),
	G1 is G - 1,
	gerar_geracao(G1, NPopSel, Populacao).

mutacao([],[]):-!.
mutacao([Individuo|Resto], [Individuo1|Resto1]):-
	prob_mutacao(P),
	random(0.0, 1.0, Prob),
	((Prob < P, !, mutacao_individuo(Individuo, Individuo1));
	Individuo1 = Individuo),
	mutacao(Resto, Resto1).
	


mutacao_individuo(Individuo, Mutante):-
		gerar_pontos_cruzamento(P1, P2),
		P11 is P1 - 1,
		P21 is P2 - 1,
		trocarValores(Individuo, P11, P21, Mutante).

trocarValores(As,I,J,Cs) :-
   %same_length(As,Cs),
   append(BeforeI,[AtI|PastI],As),
   append(BeforeI,[AtJ|PastI],Bs),
   append(BeforeJ,[AtJ|PastJ],Bs),
   append(BeforeJ,[AtI|PastJ],Cs),
   length(BeforeI,I),
   length(BeforeJ,J), !.		

selecao(PopIni, PopFin):-
	populacao(N),
	T is N +1,
	sublista(PopIni, 1, T, PopFin).

avaliar_individuo([PrimeiroGene|Genes], Fitness):-
	
	custo([PrimeiroGene|Genes], C1),
	reverse(Genes, [UltimoGene|_]),
	dist_cities(PrimeiroGene, UltimoGene, C2),
	Fitness is C1 + C2.

ordenar_populacao(Populacao, Ordenada):-
	findall((Individuo, Fitness),
		(member(Individuo, Populacao), avaliar_individuo(Individuo, Fitness)) , ListaPares),
	sort(2, @=<, ListaPares, ListaOrdenada),
	findall(I, member((I,_), ListaOrdenada), Ordenada).	
	
gerar_populacao(Populacao):-
	populacao(Tamanho),
	findall(C, city(C, _, _), Cidades),
	gerar_populacao(Tamanho, Cidades, Populacao).

gerar_populacao(0, _, []):-!.
gerar_populacao(Tamanho, Cidades, [Individuo|Resto]):-
	T is Tamanho - 1,
	random_permutation(Cidades, Individuo),
	gerar_populacao(T, Cidades, Resto).
