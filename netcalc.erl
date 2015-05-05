-module(netcalc).

-export([set_ip/0, start/1, mask_to_binary/1]).

set_ip() ->
	io:format("Please, enter IP address~n using template:~n Ip = {ip, {_, _, _, _}, mask, {_, _, _, _}}~n"),
	{ip, {192, 168, 129, 1}, mask, {255, 255, 128, 0}}.

start(Ip) ->
	{ip, Ip2, mask, Mask} = Ip,
	
	<<A3, B3, C3, D3>> = list_to_binary(tuple_to_list(Ip2)),
	<<A4, B4, C4, D4>> = list_to_binary(tuple_to_list(Mask)),

	Subnet = {A3 band A4, B3 band B4, C3 band C4, D3 band D4},
	
	[ip, Ip2, subnet_mask, Mask, subnet, Subnet].






	%% можно использовать lists:foreach(), lists:nthtail(), lists:split(), lists:sublist(List, Start, Len)
	%%получаем длину маски подсети
	%%делим маску подсети кратно 8, получаем колиесктво октетов <<255>>
	%%делим с остатком на 8 и получаем остаток для октета = количеству бит
	%%в соостветствии с остатком формируем октет <<N>>
	%%сравнивеам количество полученных октетов, и добавляем октеты <<0>> до получения 4 октетов
	%%выход - 4 октета

create_full_octet(0, Acc) -> Acc;
create_full_octet(Num, Acc) ->
	Num2 = Num - 1,
	create_full_octet(Num2, [<<255:8>> | Acc]).

mask_to_binary(Ip) ->
	{_, _, mask, Mask} = Ip,
	Num_full_octets = Mask div 8,
	Full_octet = create_full_octet(Num_full_octets, []),
	Full_octet.
