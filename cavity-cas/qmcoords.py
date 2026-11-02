f = open("protein_6-31G_Opt.Final.xyz", "r")
lines = f.readlines()
p = open("ret.xyz", "w")
prum=[]

for i in [ceatom, he1atom, he2atom, nzatom, hzatom]:   ## Lys QM part
    prum=lines[i].split()
    xcoord = prum[2]
    ycoord = prum[3]
    zcoord = prum[4] 
    atomchar = prum[1][0]
    p.write(str(atomchar) + '    ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')

for i in range(c1atom, owatom):   ## Ret: first QM atom, last QM atoms + 1 
     prum=lines[i].split()                                                                       
     xcoord = prum[2]
     ycoord = prum[3]
     zcoord = prum[4] 
     atomchar = prum[1][0]
     p.write(str(atomchar) + '    ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')


prum=lines[laatom].split()             ## LAH                        
xcoord = prum[2]
ycoord = prum[3]
zcoord = prum[4] 
atomchar = prum[1][2]
p.write(str(atomchar) + '    ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')

p.close()
