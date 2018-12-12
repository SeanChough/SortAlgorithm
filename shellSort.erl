%% @author eioznxh
%% @doc @todo Add description to shellSort.

%% 希尔排序：
%% 将?RANGE个随机数排序：小->大
-module(shellSort).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).
-define(RANGE,100).



%% ====================================================================
%% Internal functions
%% ====================================================================
start() ->
	List = genList(?RANGE,0,[]),
	io:format("The list is:~n~w~n",[List]),
	
	Length = length(List),
	Result = sort_loop_1(List,trunc(Length/2)),
	io:format("The result is:~n~w~n", [Result]).

%% 增量变化
sort_loop_1(List,0) ->
	List;
sort_loop_1(List,Increment) ->
	Result = sort_loop_2(List,1,Increment),
	%io:format("Increment ~w result is:~n~w~n",[Increment,Result]),
	NewIncrement = trunc(Increment/2),					%% 取整
	sort_loop_1(Result,NewIncrement).
	
%% 每一个分组
sort_loop_2(List,Ref,Increment) when Ref+Increment > length(List) ->
	List;
sort_loop_2(List,Ref,Increment) ->
	%%ToInsertSort_RefList
	IntegerList = lists:seq(Ref,?RANGE),
	%ToInsertSort_RefList = [X||X <- IntegerList, X+Increment =< 20],
	ToInsertSort_RefList = getRefList(IntegerList,[],Ref,Increment, ?RANGE),
	%io:format("Increment ~w reflist is:~n~w~n",[Increment,ToInsertSort_RefList]),
	ResultTmp = insertSort(List, ToInsertSort_RefList, 2, 2),	%%进行插入排序
	sort_loop_2(ResultTmp, Ref+1, Increment).

%% 插入排序（稳定性）
insertSort(ToSortedList, RefList, StartRoR, _RoR) when StartRoR > length(RefList) ->
	ToSortedList;
insertSort(ToSortedList, RefList, StartRoR, RoR) ->				%% Ref of RefList
	if 
		StartRoR > length(RefList) ->
			ToSortedList;
		true ->
			case RoR of
				1 ->
					insertSort(ToSortedList, RefList, StartRoR+1, StartRoR+1);
				_ ->
					ARef = lists:nth(RoR-1, RefList),
					BRef = lists:nth(RoR, RefList),
					A = lists:nth(ARef, ToSortedList),
					B = lists:nth(BRef, ToSortedList),
					if
						A > B ->
							{HeadList,TailListTmp1} = lists:split(ARef-1,ToSortedList),
							[_A|MidListTmp] = TailListTmp1,
							{MidList,TailListTmp2} = lists:split(BRef-ARef-1,MidListTmp),
							[_B|TailList] = TailListTmp2,
							ASortedList = HeadList ++ [B] ++ MidList ++ [A] ++ TailList,
							insertSort(ASortedList, RefList, StartRoR, RoR-1);
						true ->
							insertSort(ToSortedList, RefList, StartRoR+1, StartRoR+1)
					end
			end
							
	end.

%% 生成RefList
getRefList(IntegerList, RefList, Value, Increment, Limit) ->
	if
		Value+Increment =< Limit ->
			getRefList(IntegerList, RefList++[Value], Value+Increment, Increment, Limit);
		true ->
			NewRefList = RefList++[Value],
			NewRefList
	end.
	
%% 生成随机数列
genList(Limit,Num,List) ->
	case Num of
		Limit ->
			List;
		_ ->
			NewList = List ++ [rand:uniform(?RANGE)],
			genList(Limit, Num+1, NewList)
	end.
