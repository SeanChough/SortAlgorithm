-module(selectSort).
-export([start/0]).
%% 选择排序：
%% 对包含100个随机整数的列表进行排序：小->大

start() ->
	List = genList(100,0,[]),
	io:format("The list is:~n~w~n",[List]),
	
	Result = startSort(List,1),
	io:format("Sorted list:~n~w~n",[Result]).
	
genList(Limit,Num,List) ->
	case Num of
		Limit ->
			List;
		_ ->
			NewList = List ++ [rand:uniform(100)],
			genList(Limit, Num+1, NewList)
	end.
	
startSort(List,Ref) when length(List)-1 == Ref ->
	{Sorted,Left} = lists:split(length(List)-2,List),
	[Head|Tail] = Left,		%% TailList is a list
	[Tail|_] = TailList,
	if 
	%% if Head is an integer and Tail is list, "Head > Tail" 
	%% is always false
	Head > Tail ->
		Result = Sorted ++ [Tail] ++ [Head],
		Result;
	true ->
		List
	end;
startSort(List,Ref) ->
	MinValTmp = lists:nth(Ref,List),
	NewList = sort(List,Ref,MinValTmp,Ref,Ref),
	startSort(NewList,Ref+1).
	
sort(List,StartRef,MinVal,MinRef,CursorRef) ->
	if
		CursorRef > length(List) ->
			{Head,Need} = lists:split((StartRef-1),List),	
			[StartVal|MidTmp] = Need,							
			Result = 
				case MinRef == StartRef of
					true -> List;
					_ -> 
						{Mid,TailTmp} = lists:split((MinRef-StartRef-1),MidTmp),
						[Selected|Tail] = TailTmp,							
						Head ++ [Selected] ++ Mid ++ [StartVal] ++ Tail
				end,
			Result;
		true ->
			Obj = lists:nth(CursorRef,List),	%% consider the item at Ref position is current mix value
			if
				MinVal > Obj ->
					sort(List,StartRef,Obj,CursorRef,CursorRef+1);
				true ->
					sort(List,StartRef,MinVal,MinRef,CursorRef+1)
			end
	end.