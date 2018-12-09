-module(mergeSort).
-export([start/0]).
%% 归并排序
%% 将?RANGE个数的随机序列排序：小->大
%% 由分入合，最后得到顺序序列

-define(RANGE,100).
start() ->
	List = genList(?RANGE,0,[]),
	io:format("The list is:~n~w~n",[List]),
	
	Result = mergeSort(List),
	io:format("The result is:~n~w~n", [Result]).
	
mergeSort(List) ->
	Length = length(List),
	Results = start(trunc(Length/2),List),	
	Results.
	
start(_MRef,List) when length(List) == 1 ->
	List;
start(MRef,List) ->
	{LeftL,RightL} = lists:split(MRef,List),
	LeftResult = start(trunc(length(LeftL)/2),LeftL),
	RightResult = start(trunc(length(RightL)/2),RightL),
	Sorted = mergeL(1,LeftResult,1,RightResult,[]),
	%io:format("Sorted is:~p~n",[Sorted]),
	Sorted.
	
%% 合并
mergeL(ARef,ListA,BRef,ListB,Results) when ARef > length(ListA),BRef > length(ListB) ->
	%io:format("Results is:~p~n",[Results]),
	Results;
mergeL(ARef,ListA,BRef,ListB,Results) when ARef > length(ListA),BRef =< length(ListB) ->
	NewResults = Results ++ lists:nthtail(BRef-1,ListB),
	%io:format("New results is:~p~n",[NewResults]),
	NewResults;
mergeL(ARef,ListA,BRef,ListB,Results) when BRef > length(ListB),ARef =< length(ListA) ->
	NewResults = Results ++ lists:nthtail(ARef-1,ListA),
	%io:format("New results is:~p~n",[NewResults]),
	NewResults;
mergeL(ARef,ListA,BRef,ListB,Results) ->
	AV = lists:nth(ARef,ListA),
	BV = lists:nth(BRef,ListB),
	%io:format("AV:~p,BV:~p~n",[AV,BV]),
	%timer:sleep(5000),
	if AV > BV ->
		mergeL(ARef,ListA,BRef+1,ListB,Results ++ [BV]);
	true ->
		mergeL(ARef+1,ListA,BRef,ListB,Results ++ [AV])
	end.
	
%% 生成随机数列
genList(Limit,Num,List) ->
	case Num of
		Limit ->
			List;
		_ ->
			NewList = List ++ [rand:uniform(Limit)],
			genList(Limit, Num+1, NewList)
	end.