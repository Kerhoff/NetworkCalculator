-module(netcalc).

-export([init/0, ip_to_binary/1, mask_to_binary/1]).

%% 1.1. На входе получаем IP-адресс и длину маска подсети
%% 1.2. На выходе получаем:  - адресс подсети,
%%                                        - адресс хоста в подсети,
%%                                        - двоичное представление маски и адресса.

init() ->
  io:format("Please, enter IP address~n using template:~n Ip = {ip, {_, _, _, _}, mask, _}~n").

ip_to_binary(Address) ->
  {ip, {A, B, C, D}, _, _} = Address,
  A2 = integer_to_list(A, 2),
  B2 = integer_to_list(B, 2),
  C2 = integer_to_list(C, 2),
  D2 = integer_to_list(D, 2),
  {A2, B2, C2, D2}.

mask_to_binary(Address) ->
  {_,_, mask, Mask} = Address,
  mask_to_binary(Mask, []).

mask_to_binary(0, Acc) -> Acc;
mask_to_binary(Mask, Acc) ->
  Mask2 = Mask - 1,
  mask_to_binary(Mask2, [1 | Acc]).

%%check_ip(Address) ->
	%%get_ip(Address).
	%%get_mask(Address);
	%%get_subnet(Address).
%%get_ip(Address) ->
%%	get_ip(Address, []).

%%get_ip([], Acc) -> Acc;
%%get_ip([Address2 | Rest], Acc) ->
%%	{ip, Ip, _, _} = Address2,
%%	get_ip(Rest, [Ip | Acc]). 
%% подается не список а кортеж, значит обрабатывать нужно сразу или подавать список

%% 2.1. На входе получаем адресс сети, длину маски подсети
%% 2.2. На выходе получаем: - сеть,
%%                                        - возможные адресса хостов,
%%                                        - адресс сети и broadcast адресс сети,
%%                                        - все подсети данной длины.
