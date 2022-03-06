from dataclasses import dataclass, field
from List_matching import List

#init for recursive node
class Node:
    pass

@dataclass(frozen=True, order=True)
class Node:
    '''
    Node(v, l) type

    Makes a general tree
    - val = object()
    - leaves = list of Node

    returns an object of node type

    sample tree:
    
    t = Node(1,[
                Node(2,[]),
                Node(3,
                        [Node(5,[]),
                        Node(6,
                                [Node(7, [])])]),
                Node(4,[])
    ])

    returns

          1
        / | \
        2 3  4
          | \
          5  6
              \
               7
    '''
    val : object() = field(default=None)
    leaves : list[Node] = field(default_factory=list)

class Tree:
    def __init__(self):
        pass

    def height(t):
        '''
        Tree.height(Node)

        Gets height of tree
        - t = <Node(v, ls)>
        
        Ex: sample tree

        returns 4

        Throws exception if not a tree
        '''
        def height_h(c, t):
            match t:
                case Node(_, []):
                    return c
                case Node(_, ls):
                    return List.fold_right(lambda x,r: max(x, r), 0, List.map(lambda h: height_h(c+1, h), ls))
                case _:
                    raise Exception("height: Invalid Tree")

        return height_h(0, t)+1

    def nodes(t):
        '''
        Tree.nodes(Node)

        Gets total nodes in tree
        - t = <Node(v, ls)>
        
        Ex: sample tree

        returns 7

        Throws exception if not a tree
        '''
        def nodes_h(t):
            match t:
                case Node(_, ls):
                    return len(ls) + List.fold_right(lambda x,r: x+r, 0, List.map(nodes_h, ls))
                case _:
                    raise Exception("nodes: Invalid Tree")

        return nodes_h(t)+1

    def path_to_leaves(t):
        '''
        Tree.path_to_leaves(Node)

        Gets all paths to leaves from root of tree, each path denoted as an index from [0 .. n] for each level of the tree
        - t = <Node(v, ls)>
        
        Ex: sample tree

        returns [[0], [1, 0], [1, 1, 0], [2]]
        '''
        def path_to_leaves_h(lis, t):
            match t:
                case Node(_, []):
                    return [lis]
                case Node(_, ls):
                    return List.flatten(List.mapi(lambda path, route: (path_to_leaves_h(lis+[path], route)), ls), False)
        return path_to_leaves_h([], t)

    def path_to_val(t, val):
        '''
        Tree.path_to_val(Node, val)

        Get all paths to value from root of tree, similar to path_to_leaves
        - t = <Node(v, ls)>
        - val = object()
        
        Ex: sample tree, 6

        returns [[1,1]]

        Throws exception if val not in list
        returns [[]] if val is in root
        '''
        def path_to_val_h(lis, t, val):
            match t, val:
                case Node(v, ls), vl:
                    ls_res = [lis] if vl==v else []
                    return ls_res+List.flatten(List.mapi(lambda path, route: (path_to_val_h(lis+[path], route, val)), ls), False)
        
        res = list(filter(None, path_to_val_h([], t, val)))

        if t.val == val:
            return [[]]+res
        elif not res:
            raise Exception("path_to_val: val not contained in Tree")
        
        return res

    def val_occurances(t, val):
        '''
        Tree.val_occurances(Node, val)

        Get total occurances of value in tree
        - t = <Node(v, ls)>
        - val = object()

        Ex: sample tree, 6

        return 1

        Returns 0 if there are no occurances
        '''
        try:
            res = len(Tree.path_to_val(t, val))
        except:
            res = 0

        return res

    def get_path_val(t, path):
        '''
        Tree.get_path_val(Node, list)

        Gets the value at the given path
        - t = <Node(v, ls)>
        - path = list of int
        
        Ex: sample tree, [1, 1]

        returns 3

        Throws exception if path is too long or invalid path given
        '''
        match t, path:
            case Node(v, []), p if len(p) > 0:
                raise Exception("get_path_val: Path too long")
            case Node(v, _), p if len(p) == 0:
                return v
            case Node(v, ls), _:
                try:
                    next_branch = ls[path[0]]
                except:
                    raise Exception("get_path_val: Invalid path")
                else:
                    return Tree.get_path_val(next_branch, path[1:])
    
    def get_leaves(t):
        '''
        Tree.get_leaves(Node)

        Gets all leaves in tree
        - t = <Node(v, ls)>
        
        Ex: sample tree

        returns [2, 5, 7, 4]
        '''
        return [Tree.get_path_val(t, i) for i in Tree.path_to_leaves(t)]

    def map_tree(f, t):
        '''
        Tree.map_tree(function, Node)

        Maps function to values of tree
        - t = <Node(v, ls)>
        - f = <function(a)>
        
        Ex: lambda x: x+1, sample tree

                      2
                    / | \
                   3  4  5
                      | \
                      6  7
                          \
                           8

        Throws exception if invalid tree
        '''
        match t:
            case Node(v, l):
                return Node(f(v), List.map(lambda x: Tree.map_tree(f, x), l))
            case _:
                raise Exception("map_tree: Invalid Tree")

    def fold_tree(f, t):
        '''
        Tree.map_tree(function, Node)

        Recursively applies function and folds tree
        - t = <Node(v, ls)>
        - f = <function(a, b)>
        
        Throws exception if invalid tree
        '''
        match t:
            case Node(v, l):
                return f(v, List.map(lambda x: Tree.fold_tree(f, x), l))
            case _:
                raise Exception("map_tree: Invalid Tree")

    def preorder(t):
        '''
        Tree.preorder(Node)

        Gets preorder of tree
        - t = <Node(v, ls)>

        Ex: sample tree

        returns [1, 2, 3, 5, 6, 7, 4]
        '''
        return Tree.fold_tree(lambda i, rs: [i]+List.flatten(rs, False), t)