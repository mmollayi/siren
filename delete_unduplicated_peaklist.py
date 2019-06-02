def delete_unduplicated_peaklist( peaklists, tol=0.005 ): 
    svs = [ [] for i in range(len(peaklists)) ]
    for t in range(0,len(svs)-1):
        if t % 100 == 1:
            print('t: ' + str(t) + ' ' + str(len(svs[t-1])), len(a).__str__(), len(b).__str__()	)
        if t == 0:
            a = peaklists[t]
        else:
            a = b
        b = peaklists[t+1]
        i = 0
        j = 0
        I = len(a)
        J = len(b)
        while i<I and j<J:
            diff = a[i][0]-b[j][0]
            if abs(diff) <= tol:
                svs[t].append(a[i])	
                svs[t+1].append(b[j])	
            if diff > 0:
                j += 1
            else:
                i += 1
                svs[t] = list(set(svs[t]))
                svs[t].sort()
    return svs
