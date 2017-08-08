function[valueintree, nodeintree] = tree(tree_depth, tree_width, seek_value)
       %输入：树的深度、树的广度、搜索的值
       %返回：树中接近的值、节点名字，如果没有接近的值，节点名字为空
       %根据树的深度、节点的儿子数量计算树总的节点个数
       node_num = 0;
       for n= 0 : (tree_depth-1)
              node_num = node_num + tree_width ^ n;
       end
 
       %为树的存储空间赋值
       %node name，按照广度优先为节点排号
       tree_nodename = (1 : node_num);
       %node value
       tree_nodevalue = rand(1 : node_num);
       %node father and son
       tree_nodefather(1) = 0;
       tree_nodeson = zeros(1, node_num);
       n = 2;
       k = 1;
       while n <= node_num
              for m = 1 : tree_width
                     tree_nodefather(n) = k;
                     if m==1
                            tree_nodeson(k) = n;
                     end
                     n = n + 1;
              end
              k = k + 1;
       end
       %node neighbor
       tree_nodeneighbor(1) = 0;
       n = 2;
       while n <= node_num
              for m = 1 : tree_width
                     if m ==tree_width
                            tree_nodeneighbor(n) = 0;
                     else
                            tree_nodeneighbor(n) = n + 1;
                     end
                     n = n + 1;
              end
       end
stack = zeros(1, tree_depth);
nodeinstack = zeros(1, node_num);
stack_ptr = 1;
stack(1) = 1;
nodeinstack(1) = 1;
valueintree = seek_value;
nodeintree = 0;
 
while stack_ptr > 0
    n = stack(stack_ptr);
    if abs(tree_nodevalue(n) - seek_value) < 1e-3
              %如果搜索到值，返回
              valueintree = tree_nodevalue(n);
              nodeintree = tree_nodename(n);
              break;
    end
    
    if tree_nodeson(n) ~= 0 && nodeinstack(n) == 1
        %如果节点有儿子，并且第一次入栈，将儿子节点入栈
        stack_ptr = stack_ptr + 1;
        m = tree_nodeson(n);
        stack(stack_ptr) = m;
        nodeinstack(m) = nodeinstack(m) + 1;
    elseif tree_nodeneighbor(n) ~= 0
        %否则，如果节点右边有兄弟，节点出栈，然后将右边兄弟入栈
        m = tree_nodeneighbor(n);
        stack(stack_ptr) = m;
        nodeinstack(m) = nodeinstack(m) + 1;
    else
        %再否则，出栈，然后将父亲节点的入栈次数加一
        stack_ptr = stack_ptr - 1;
        m = stack(stack_ptr);
        nodeinstack(m) = nodeinstack(m) + 1;
    end
end
end