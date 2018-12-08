-module(quickSort).
-export([start/0,switchInList/3]).
%% 快速排序
%% 将?RANGE个随机数排序：小->大

%% 写此代码遇到了很多坑，
%% 一是因为没有真正理解该排序法的行为步骤；
%% 二是因为一些特殊的情况不容易想到，只能通过debug发现。
%% 在函数一开始打印出参数是个不错的主意。

-define(RANGE,100).

start() ->
	List = genList(?RANGE,0,[]),
	io:format("The list is:~n~w~n",[List]),
	
	Result = quickSort(List),
	io:format("The result is:~n~w~n", [Result]).
	
quickSort(List) ->
	Results = actSort({0,0}, 1,length(List)-1,List),
	Results.
actSort({_LStop, _RStop}, _LRef, _RRef, List) when length(List) == 0; length(List) == 1; length(List) ==2 ->
	%io:format("when length is (0,1 or 2):~w,~w,~w,~w,~w~n",[LStop, RStop, LRef, RRef, List]),
	case length(List) of
		2 ->
			[A,B] = List,
			if
				A > B ->
					[B,A];
				true ->
					List
			end;
		_ ->
			List
	end;
actSort({_LStop, _RStop}, LRef, RRef, List) when LRef == RRef ->	%%交换Pivot的位置后，List将会分为左右两个子List
	%io:format("when func clause 2:~w,~w,~w,~w,~w~n",[LStop, RStop, LRef, RRef, List]),
	Results = 
	case lists:nth(length(List),List) >= lists:nth(LRef,List) of 
		true ->	%%List数列中的最大值？
			{ContinueList,TailList} = lists:split(length(List)-1,List),
			actSort({0,0},1,length(ContinueList)-1,ContinueList) ++ TailList;
		false ->
			NewList = switchInList(LRef, length(List), List),
			{LList, RListTmp} = lists:split(LRef-1, NewList),
			[Pivot|RList] = RListTmp,
			LListResult = actSort({0,0},1,length(LList)-1,LList),
			RListResult = actSort({0,0},1,length(RList)-1,RList),
			LListResult ++ [Pivot] ++ RListResult
	end,
	Results;
actSort({LStop, RStop}, LRef, RRef, List) when LStop==1, RStop==1 ->	%%两个下标均停止移动，需要相互交换
	%io:format("when func clause 3:~w,~w,~w,~w,~w~n",[LStop, RStop, LRef, RRef, List]),
	NewList = switchInList(LRef, RRef, List),
	actSort({0,0},LRef+1, RRef, NewList);
actSort({LStop, _RStop}, LRef, RRef, List) ->	%%从小到大排序，左边收集小数，右边收集大数
	%io:format("when func clause 4:~w,~w,~w,~w,~w~n",[LStop, RStop, LRef, RRef, List]),
	Pivot = lists:nth(length(List),List),
	AV = lists:nth(LRef,List),
	BV = lists:nth(RRef,List),
	case LStop==1 of 
		true ->	
			if
				BV < Pivot ->
					actSort({1,1},LRef, RRef, List);
				true ->
					actSort({1,0},LRef, RRef-1, List)
			end;
		false ->
			if
				AV > Pivot ->
					actSort({1,0},LRef, RRef, List);
				true ->
					actSort({0,0},LRef+1, RRef, List)
			end
	end.
	
%% Common:调换List中任意两个位置的数	
switchInList(Pos1,Pos2,List) ->
	{HeadL,MidListTmp1} = lists:split(Pos1-1,List),
	[FirstE|MidListTmp2] = MidListTmp1,
	{MidList,TailListTmp} = lists:split(Pos2-Pos1-1,MidListTmp2),
	[SecondE|TailL] = TailListTmp,
	HeadL ++ [SecondE] ++ MidList ++ [FirstE] ++ TailL.
%% Common:生成随机数列
genList(Limit,Num,List) ->
	case Num of
		Limit ->
			List;
		_ ->
			NewList = List ++ [rand:uniform(Limit)],
			genList(Limit, Num+1, NewList)
	end.