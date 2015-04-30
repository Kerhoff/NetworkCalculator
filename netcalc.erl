-module(netcalc).

-export([init/0, set_ip/0, address_to_binary/1]).

%% 1.1. На входе получаем IP-адресс и длину маскиподсети
%% 1.2. На выходе получаем:  - адресс подсети,
%%                           - адресс хоста в подсети,
%%                           - двоичное представление маски и адресса.

init() ->
  io:format("Please, enter IP address~n using template:~n Ip = {ip, {_, _, _, _}, mask, _}~n").

set_ip() ->
	{ip, {192, 168, 1, 1}, mask, 24}.

address_to_binary(Address) ->
	{ip, {A, B, C, D}, mask, Mask} = Address,
	IpBin = ip_to_binary([integer_to_list(N) || N <- [A, B, C, D]], []),
	MaskBin = mask_to_binary(Mask, []),
	[IpBin, MaskBin].

	%%integer_to_binary(A, 2)
	%%<< <<X>> || X <- [A, B, C, D]>>
%%переводим все данные в бинарный режим и работаем с бинарными выражениями 
%%integer_to_binary(Integer, Base).

ip_to_binary([], Acc) -> lists:reverse(Acc); %%нужно добавлять нули до восьми знаков в октете,  исопльзовать zip() для собрания списков в кортеж
ip_to_binary([Octet | Rest], Acc) ->
	Len = 8 - length(Octet),
	Octet2 = serialize_octet(Len, Octet),
	ip_to_binary(Rest, [Octet2 | Acc]).

mask_to_binary(0, Acc) ->  %% можно использовать lists:foreach(), lists:nthtail(), lists:split(), lists:sublist(List, Start, Len)
	Nulls = 32 - length(Acc),
	serialize_mask(Nulls, Acc);
mask_to_binary(Mask, Acc) ->
  Mask2 = Mask - 1,
  mask_to_binary(Mask2, [1 | Acc]).

serialize_mask(0, Acc) -> 
	Acc2 = lists:reverse(Acc),
	A = lists:sublist(Acc2, 1, 8),
	B = lists:sublist(Acc2, 9, 8),
	C = lists:sublist(Acc2, 17, 8),
	D = lists:sublist(Acc2, 25, 8),
	[A, B, C, D];
serialize_mask(Nulls, Acc) ->
	Nulls2 = Nulls - 1,
	serialize_mask(Nulls2, [0 | Acc]).

serialize_octet(0, Octet) -> Octet;
serialize_octet(Len, Octet) ->
	Len2 = Len - 1,
	serialize_octet(Len2, [0 | Octet]).



%%check_ip(Address) ->
	%%get_ip(Address).
	%%get_mask(Address);
	%%get_subnet(Address).

%% 2.1. На входе получаем адресс сети, длину маски подсети
%% 2.2. На выходе получаем: - сеть,
%%                                        - возможные адресса хостов,
%%                                        - адресс сети и broadcast адресс сети,
%%                                        - все подсети данной длины.
