-module(bubbleSort).
-export([start/0]).
%% 冒泡排序：
%% 对包含100个随机整数的列表进行排序：小->大

start() ->
	List = genList(100,0,[]),
	io:format("The list is:~n~w~n",[List]),
	
	StartMilliSec = getTime(),
	Result = startSort(List,{100,1}),
	EndMilliSec = getTime(),
	TimeCost = timeCost(StartMilliSec, EndMilliSec),
	io:format("Sorted list:~n~w,~nTime cost:~w~n",[Result,TimeCost]).

%% generate some random integers	
genList(Limit,Num,List) ->
	case Num of
		Limit ->
			List;
		_ ->
			NewList = List ++ [rand:uniform(100)],
			genList(Limit, Num+1, NewList)
	end.
	
getTime() ->
	{Hour, Min, Sec} = time(),
	timer:hms(Hour, Min, Sec).
	
startSort(List,{2,FirstRef}) ->
	sort(List,2,FirstRef);
startSort(List,{Range,FirstRef}) ->
			case FirstRef == Range of
				true ->
					startSort(List,{Range-1,1});	%% a new range
				false ->
					NewList = sort(List,Range,FirstRef),
					startSort(NewList,{Range-1,1})
			end.
	
timeCost(StartMilliSec, EndMilliSec) ->
	MilliSec = EndMilliSec - StartMilliSec,
	MilliSec1 = MilliSec rem 1000,	%%milli seconds
	Sec = MilliSec/1000,	%%seconds
	{Sec,seconds,MilliSec1,milliseconds}.
	
sort(List,Range,FirstRef) ->
	if 
		FirstRef ==  Range ->
			List;
		true ->
			First = lists:nth(FirstRef, List),
			Second = lists:nth(FirstRef+1, List),
			if 
				First > Second ->
					%% change
					{Head,TmpTail} = lists:split(FirstRef-1,List),
					[FItem,SItem|Tail] = TmpTail,
					ListGet = Head ++ [SItem,FItem] ++ Tail,
					sort(ListGet,Range,FirstRef+1);
				true ->
					%% continue
					sort(List,Range,FirstRef+1)
			end
	end.					