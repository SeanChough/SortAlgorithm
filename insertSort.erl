-module(insertSort).
-export([start/0]).
%% 直接插入排序：
%% 对包含100个随机整数的列表进行排序：小->大

start() ->
	List = genList(100,0,[]),
	io:format("The list is:~n~w~n",[List]),
	
	StartMilliSec = getTime(),
	[First|Rest] = List,
	Result = startSort([First],Rest),
	EndMilliSec = getTime(),
	TimeCost = timeCost(StartMilliSec, EndMilliSec),
	io:format("Sorted list:~n~w,~nTime cost:~w~n",[Result,TimeCost]).
	
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
	
startSort(HeadL,[]) ->
	HeadL;
startSort(HeadL,RestL) ->
	%%Length = length(HeadL),
	[Need|Rest] = RestL,
	NewHeadL = sort(1,HeadL,Need),
	startSort(NewHeadL,Rest).
	
sort(Ref,HeadL,Need) ->
	if 
		Ref > length(HeadL) ->
			HeadL ++ [Need];
		true ->
			Obj = lists:nth(Ref,HeadL),
			if 
				Need =< Obj ->
					{HeadList,TailList} = lists:split(Ref-1,HeadL),
					HeadList ++ [Need] ++ TailList;
				true ->
					sort(Ref+1,HeadL,Need)
			end
	end.
	
timeCost(StartMilliSec, EndMilliSec) ->
	MilliSec = EndMilliSec - StartMilliSec,
	MilliSec1 = MilliSec rem 1000,	%%milli seconds
	Sec = MilliSec/1000,	%%seconds
	{Sec,seconds,MilliSec1,milliseconds}.
	