-module(heapSort).
-export([start/0]).
%% 堆排序
%% 将?RANGE个随机数排序：小->大(构建最大堆)
-define(RANGE,100).

start() ->
	List = genList(?RANGE,0,[]),
	io:format("The list is:~n~w~n",[List]),
	
	Result = heapSort(List,length(List),[]),
	io:format("The result is:~n~w~n", [Result]).
	
heapSort(List,Length,Result) when Length == 2 ->
	[HeadE|[TailE]] = List,
	if
		HeadE > TailE ->
			[TailE] ++ [HeadE] ++ Result;
		true ->
			List ++ Result
	end;
heapSort(List,Length,Result) ->
	ParentNodes = getParentNodes(List,1,[]),
	Results1 = sortMaxHeap(List,ParentNodes),% 构建最大堆并交换最大值
	{NeedList,Result2} = lists:split(Length-1,Results1),
	heapSort(NeedList,Length-1,Result2 ++ Result).

%% 交换最大值
sortMaxHeap(List,ParentNodes) when length(ParentNodes) == 0 ->
	[FirstE|MidListTmp] = List,% max value
	{MidList,[TailE]} = lists:split(length(List)-2,MidListTmp),
	[TailE] ++ MidList ++ [FirstE];
%% 构建最大堆
sortMaxHeap(List,ParentNodes) ->
	% length of the ParentNodes list
	NodesLength = length(ParentNodes),
	{LeftParentNodes,NeedNodes} = lists:split(NodesLength-1,ParentNodes),
	NewList = 
		case NeedNodes of
			% 将三个/两个节点上的最大的数与Ref节点交换
			[{Ref,LeftChildRef,RightChildRef}] ->
				% 选择出最大值的节点位置
				MaxNode = getMaxNode(List,Ref,LeftChildRef,RightChildRef),
				if Ref == MaxNode ->
					List;
				true ->	
					% 交换List中任意两个位置的数
					List1 = switchInList(Ref,MaxNode,List), % Ref < MaxNode
					List1
				end;
			[{Ref,LeftChildRef}] ->
				RefE = lists:nth(Ref,List),
				LeftE = lists:nth(LeftChildRef,List),
				if
					LeftE > RefE ->
						List1 = switchInList(Ref,LeftChildRef,List),
						List1;
					true ->
						List
				end
		end,
	sortMaxHeap(NewList,LeftParentNodes).
	
switchInList(Pos1,Pos2,List) ->
	{HeadL,MidListTmp1} = lists:split(Pos1-1,List),
	[FirstE|MidListTmp2] = MidListTmp1,
	{MidList,TailListTmp} = lists:split(Pos2-Pos1-1,MidListTmp2),
	[SecondE|TailL] = TailListTmp,
	HeadL ++ [SecondE] ++ MidList ++ [FirstE] ++ TailL.

getMaxNode(List,Pos1,Pos2,Pos3) ->
	First = lists:nth(Pos1,List),
	Second = lists:nth(Pos2,List),
	Third = lists:nth(Pos3,List),
	MaxPos =
		if
			Second > First ->
				if 
					Third > Second -> Pos3;
					true -> Pos2
				end;
			true -> 
				if 
					Third > First -> Pos3;
					true -> Pos1
				end
		end,
	MaxPos.

%% 获取尚不具备堆性质的树的父节点
getParentNodes(List,Ref,ValidParentNodes) ->
	if 
	Ref > length(List) ->
		ValidParentNodes;
	true ->
		F = trunc(math:log2(Ref)),%Ref，当前数节点所在下标
		%Line = F + 1,%第几行
		LineMinRef = trunc(math:pow(2,F)),%该行第一个数字的下标
		LineMaxRef = LineMinRef + (trunc(math:pow(2,F))-1),%该行最后一个数字的下标
		%% 计算出理论上当前节点的两个子节点
		LeftChildRef = (LineMaxRef+1) + (Ref-LineMinRef)*2,
		RightChildRef = LeftChildRef + 1,
		%% 判断两个子节点是否真实存在
		NewVPNodes = %NewValidParentNodes
			case LeftChildRef =< length(List) of
				true -> 
					%Nodes1 = ValidParentNodes ++ [LeftChildRef],
					case RightChildRef =< length(List) of
						true ->
							Nodes1 = ValidParentNodes ++ [{Ref,LeftChildRef,RightChildRef}],
							Nodes1;
						_ -> 
							Nodes1 = ValidParentNodes ++ [{Ref,LeftChildRef}],
							Nodes1
					end;
				_ -> ValidParentNodes
			end,
		getParentNodes(List,Ref+1,NewVPNodes)
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