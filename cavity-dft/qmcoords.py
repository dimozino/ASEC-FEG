f = open("protein_dft.Final.xyz", "r")
lines = f.readlines()
p = open("ret.xyz", "w")
prum=[]

for i in [nzatom, hzatom]:   # QM Lys
    prum=lines[i].split()
    xcoord = prum[2]
    ycoord = prum[3]
    zcoord = prum[4] 
    atomchar = prum[1][0]
    p.write(str(atomchar) + '    ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')

for i in range(c1atom, owatom):  # first QM RET, first atom after QM RET
     prum=lines[i].split()                                                                       
     xcoord = prum[2]
     ycoord = prum[3]
     zcoord = prum[4] 
     atomchar = prum[1][0]
     p.write(str(atomchar) + '    ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')


prum=lines[laatom].split()   # LAH                                                                     
xcoord = prum[2]
ycoord = prum[3]
zcoord = prum[4] 
atomchar = prum[1][2]
p.write(str(atomchar) + '    ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')

p.close()
