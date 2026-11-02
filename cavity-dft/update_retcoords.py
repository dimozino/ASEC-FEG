f = open("protein_dft.Final.xyz", "r")
lines = f.readlines()
p = open("ret.xyz", "w")
prum=[]

for i in range(natom, o1atom):  # First Lys atom, Final Lys atom +1
    prum=lines[i].split()
    xcoord = prum[2]
    ycoord = prum[3]
    zcoord = prum[4] 
    p.write(str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')

for i in range(c1atom, owatom):  # First RET atom, Final RET atom + 1 
     prum=lines[i].split()                                                                       
     xcoord = prum[2]
     ycoord = prum[3]
     zcoord = prum[4] 
     p.write(str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')

p.close()
f.close()

k = open("ret.xyz", "r")
k1 = open("ret1.xyz", "w")
retold = k.readlines()

retnew = []

retnew.append(retold[20])
retnew.append(retold[21])
retnew.append(retold[40])
retnew.append(retold[41])

retnew.append(retold[22])
retnew.append(retold[42])
retnew.append(retold[43])
retnew.append(retold[23])
retnew.append(retold[44])
retnew.append(retold[45])
retnew.append(retold[24])
retnew.append(retold[25])
retnew.append(retold[26])
retnew.append(retold[46])
retnew.append(retold[27])
retnew.append(retold[47])
retnew.append(retold[28])
retnew.append(retold[29])
retnew.append(retold[48])
retnew.append(retold[30])
retnew.append(retold[49])
retnew.append(retold[31])
retnew.append(retold[50])
retnew.append(retold[32])
retnew.append(retold[33])
retnew.append(retold[51])
retnew.append(retold[34])
retnew.append(retold[52])
retnew.append(retold[35])
retnew.append(retold[53])
retnew.append(retold[54])
retnew.append(retold[55])
retnew.append(retold[36])
retnew.append(retold[56])
retnew.append(retold[57])
retnew.append(retold[58])
retnew.append(retold[37])
retnew.append(retold[59])
retnew.append(retold[60])
retnew.append(retold[61])
retnew.append(retold[38])
retnew.append(retold[62])
retnew.append(retold[63])
retnew.append(retold[64])
retnew.append(retold[39])
retnew.append(retold[65])
retnew.append(retold[66])
retnew.append(retold[67])
retnew.append(retold[0])
retnew.append(retold[1])
retnew.append(retold[2])
retnew.append(retold[3])
retnew.append(retold[4])
retnew.append(retold[5])
retnew.append(retold[6])
retnew.append(retold[7])
retnew.append(retold[8])
retnew.append(retold[9])
retnew.append(retold[10])
retnew.append(retold[11])
retnew.append(retold[12])
retnew.append(retold[13])
retnew.append(retold[14])
retnew.append(retold[15])
retnew.append(retold[16])
retnew.append(retold[17])
retnew.append(retold[18])
retnew.append(retold[19])

for i in range(len(retnew)):
    k1.write(str(retnew[i]))

k1.close()
k.close()

f = open("Best_Config.gro", "r")
lines = f.readlines()
p = open("start", "w")
p1 = open("end", "w")
p2 = open("ret", "w")

for i in range(0, hatom):  # First RET atom + 1;
    p.write(lines[i])

for i in range(lr2atom,la2atom): # Final RET atom +2; Final line in .gro
    p1.write(lines[i])

j=0
f1 = open("ret1.xyz", "r")
lines1 = f1.readlines()
t=[]
o=[]

for i in range(ir1atom, lr2atom):  # First RET atom +1; Final RET atom +2
    t = lines[i].split()
    res = t[0]
    atnam = t[1]
    atnum = t[2]
    o = lines1[j].split()
    xcoord = float(o[0])
    ycoord = float(o[1])
    zcoord = float(o[2])
    xcoord1 = xcoord/10
    ycoord1 = ycoord/10
    zcoord1 = zcoord/10
    x1=str(xcoord1)
    y1=str(ycoord1)
    z1=str(zcoord1)
    xf = "{:.3f}".format(xcoord1)
    yf = "{:.3f}".format(ycoord1)
    zf = "{:.3f}".format(zcoord1)
    j = j+1
    p2.write(str(res) + '  ' + str(atnam) + '  ' + str(atnum) + '   ' + xf + '   ' + yf + '   ' + zf + '\n')
p2.close()

