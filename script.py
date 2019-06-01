ms1filename = "15b.ms1"

print('Reading the ms1file')
ms1file = open(ms1filename,'r')
scannum = -1
peaklist = []
rtime = 0
numpeaks = 0
for line in ms1file:
    if (line[0] == "H") or (line[0] == "Z") or (line[0] == "D"):
        continue
    if line[0] == "I":
        if ('RTime' in line):
            rtime = float(line.rstrip().split()[-1])
            peaklist.append( (rtime,[]) )
        continue
    if (line[0] == "S"):
        if scannum % 200 == 0:
            print("Reading scan " + str(scannum))
        scannum += 1
        continue
    if (len(line) > 1):
        tokens = line.rstrip().split()
        mz = float(tokens[0])
        intensity = float(tokens[1])
        #intensity = int(tokens[1])
        numpeaks += 1
        peaklist[-1][1].append( (mz,intensity) )
ms1file.close()
print('Numpeaks: ' + str(numpeaks))
