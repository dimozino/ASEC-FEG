f = open("protein_dft.Final.xyz", "r")
lines = f.readlines()

numberlines = len(lines)

f1 = open("charges.txt", "r")
chargelines = f1.readlines()

numberofcharges = len(chargelines)

k=[]
q=[]
pau=[-0.34790, 0.27470, -0.24000, 0.14260, -0.00940, 0.03620, 0.03620, 0.01870, 0.01030, 0.01030, -0.1744, -0.0012, -0.0012, 0.0000, 0.05020, 0.05020, 0.73410, -0.58940]


range1=range(natom, nzatom)  # Lys 1st atom ... NZ 

trum=[]
for i in range(numberofcharges):
    trum = chargelines[i].split()
    atype = trum[1]
    acharge = trum[2]
    k.append(atype)
    q.append(acharge)

p = open("field.pc", "w")
prum=[]

for i in range(1, nzatom):   ## 1, first QM atoms LYS part
    prum=lines[i].split()
    xcoord = prum[2]
    ycoord = prum[3]
    zcoord = prum[4] 
    atomtype = prum[5] 
    h=k.index(atomtype)

    mo=i-natom
    atomcharge=q[h]
    if i in range1:
        atomcharge=pau[mo]

    p.write(str(atomcharge) + '   ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')

for i in range(catom, c1atom): # first atom after QM Lys, first QM RET
    prum=lines[i].split()
    xcoord = prum[2]
    ycoord = prum[3]
    zcoord = prum[4] 
    atomtype = prum[5] 
    h=k.index(atomtype)
    atomcharge=q[h]
    if i == catom:
        atomcharge=pau[16]
    elif i == oatom:
        atomcharge=pau[17]

    p.write(str(atomcharge) + '   ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')

for i in range(owatom, laatom): ## first atom after QM RET, LAH
    prum=lines[i].split()
    xcoord = prum[2]
    ycoord = prum[3]
    zcoord = prum[4] 
    atomtype = prum[5] 
    h=k.index(atomtype)
    atomcharge=q[h]
    p.write(str(atomcharge) + '   ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord)  + '\n')



for i in range(la1atom, numberlines): ## first atom after LAH
    prum=lines[i].split()
    xcoord = prum[2]
    ycoord = prum[3]
    zcoord = prum[4] 
    atomtype = prum[5] 
    h=k.index(atomtype)
    atomcharge=q[h]
    p.write(str(atomcharge) + '   ' + str(xcoord) + '    ' + str(ycoord) + '    ' + str(zcoord) + '\n')


p.close()
