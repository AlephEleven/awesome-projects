class List:

    def __init__(self):
        pass

    def hd(ls):
        match ls:
            case []:
                raise Exception("hd: Empty List")
            case [h, *t]:
                return h

    def tl(ls):
        match ls:
            case []:
                raise Exception("tl: Empty List")
            case [h, *t]:
                return t


    def map(f, ls):
        return [f(i) for i in ls]

    def mapi(f, ls):
        return [f(indx, i) for indx, i in enumerate(ls)]

    def flatten(ls):
        match ls:
            case []:
                return []
            case [[*h], *t]:
                return List.flatten(h)+List.flatten(t)
            case [h, *t]:
                return [h]+List.flatten(t)

    def filter(f, ls):
        match ls:
            case []:
                return []
            case [h, *t] if f(h):
                return [h]+List.filter(f, t)
            case [h, *t]:
                return List.filter(f, t)

    def partition(f, ls, part=[[],[]]):
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
        match ls:
            case []:
                return a
            case [h, *t]:
                return f(h, List.fold_right(f, a, t))

    def for_all(f, ls):
        return List.fold_right(lambda h, r: f(h) and r, True, ls)

    def exists(f, ls):
        return List.fold_right(lambda h, r: f(h) or r, False, ls)

    def mem(ele, ls):
        return List.exists(lambda x: x==ele, ls)

