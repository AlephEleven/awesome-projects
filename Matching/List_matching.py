class List:

    def __init__(self):
        pass
    
    def hd(ls):
        '''
        List.hd(list)

        Gets head of list
        - ls = [x1, x2, x3 ...]

        returns x1

        Throws exception if empty list
        '''
        match ls:
            case []:
                raise Exception("hd: Empty List")
            case [h, *t]:
                return h

    def tl(ls):
        '''
        List.tl(list)

        Gets tail of list
        - ls = [x1, x2, x3 ...]
        
        returns [x2, x3 ...]

        Throws exception if empty list
        '''
        match ls:
            case []:
                raise Exception("tl: Empty List")
            case [h, *t]:
                return t


    def map(f, ls):
        '''
        List.map(function, list)

        Maps function to list
        - ls = [x1, x2, x3 ...]
        - f = <function(a)>
        
        returns [f(x1), f(x2), f(x3) ...]
        '''
        return [f(i) for i in ls]

    def mapi(f, ls):
        '''
        List.mapi(function, list)

        Maps function with two parameters, first parameter being the index of the list
        - ls = [x1, x2, x3 ...]
        - f = <function(a,b)>
        
        returns [f(0, x1), f(1, x2), f(2, x3) ...]
        '''
        return [f(indx, i) for indx, i in enumerate(ls)]

    def flatten(ls, depth=True):
        '''
        List.flatten(list)

        Flattens list in all depths, or one layer if depth set to false
        - ls = [x1, x2, x3 ...]
        - depth = bool
        
        Ex: [[1,5,3], 0, [[5], 2, [[-1]]]], True

        returns [1, 5, 3, 0, 5, 2, -1]

        Ex: [[1,5,3], 0, [[5], 2, [[-1]]]], False

        returns [1, 5, 3, 0, [5], 2, [[-1]]]]
        '''
        match ls, depth:
            case [], _:
                return []
            case [[*h], *t], True:
                return List.flatten(h)+List.flatten(t)
            case [[*h], *t], False:
                return [i for i in h]+List.flatten(t, depth)
            case [h, *t], _:
                return [h]+List.flatten(t, depth)


    def filter(f, ls):
        '''
        List.filter(function, list)

        Filters list based on function
        - ls = [x1, x2, x3 ...]
        - f = <function(a)> -> boolean

        Ex: [5, 3, 2, 10], lambda x: x>2

        returns [5, 3, 10]
        '''
        match ls:
            case []:
                return []
            case [h, *t] if f(h):
                return [h]+List.filter(f, t)
            case [h, *t]:
                return List.filter(f, t)

    def partition(f, ls, part=[[],[]]):
        '''
        List.partition(function, list)

        Partitions list into list of lists, works similar to filter, but keeps filtered values in second index of list
        - ls = [x1, x2, x3 ...]
        - f = <function(a)> -> boolean

        Ex: [5, 3, 2, 10], lambda x: x>2

        returns [[5, 3, 10], [2]]
        '''
        match ls:
            case []:
                return part
            case [h, *t] if f(h):
                part[0] += [h]
                return List.partition(f, t, part)
            case [h, *t]:
                part[1] += [h]
                return List.partition(f, t, part)
            

    def fold_right(f, a, ls):
        '''
        List.fold_right(function, base, list)

        Recursively applies function on itself till it reaches base case
        - ls = [x1, x2, x3 ...]
        - a = object (base case)
        - f = <function(a)>


        returns f(x1, f(x2, f(x3, f(...))))
        '''
        match ls:
            case []:
                return a
            case [h, *t]:
                return f(h, List.fold_right(f, a, t))

    def for_all(f, ls):
        '''
        List.for_all(function, list)

        Checks if all values of list meet case
        - ls = [x1, x2, x3 ...]
        - f = <function(a)>


        returns True if f(x1) ... f(xn) is True, else False
        '''
        return List.fold_right(lambda h, r: f(h) and r, True, ls)

    def exists(f, ls):
        '''
        List.exists(function, list)

        Checks if any values of list meet case
        - ls = [x1, x2, x3 ...]
        - f = <function(a)>


        returns True if any f(x1) ... f(xn) is True, else False
        '''
        return List.fold_right(lambda h, r: f(h) or r, False, ls)

    def mem(ele, ls):
        '''
        List.mem(object, list)

        Checks if any values of list meet case
        - ls = [x1, x2, x3 ...]
        - ele = object


        returns True if ele exists in ls, else False
        '''
        return List.exists(lambda x: x==ele, ls)