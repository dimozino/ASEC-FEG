#!/bin/bash
Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`
step=`grep "Step" Infos.dat | awk '{ print $2 }'`
chromo=`grep "chromo" Infos.dat | awk '{ print $2 }'`
size=`grep "atoms" Infos.dat | awk '{ print $2 }'`


cd calculations
mkdir fororca-single
cd fororca-single

asecatoms=`head -1 ../dft/${Project}_dft.Final.xyz | awk '{print $1}'`
natoms=`head -1 ../../conversion/final_${Project}.xyz_2 | awk '{print $1}'`
natomsp1=$(($natoms+1))

head -$natomsp1 ../dft/${Project}_dft.Final.xyz | tail -$natoms | awk '{print $1, $2, $3, $4, $5}' > atoms
tail -$natoms ../../conversion/final_${Project}.xyz_2 | awk '{print $6}' > atomtyps
paste atoms atomtyps > mout
awk '{printf "%5d %-3s %11.6f %11.6f %11.6f %5d\n", $1, $2, $3, $4, $5, $6}' mout > mout1
echo "$natoms" > ${Project}_dft.Final.xyz 
cat mout1 >> ${Project}_dft.Final.xyz 
grep "^charge " ../dft/melacu63.prm > charges.txt


python ../../../files/qmcoords.py 
python ../../../files/field_dft.py 
cp $sourcedir/orcaheader protein.inp
cat ret.xyz >> protein.inp 
echo "*" >> protein.inp
wc -l field.pc > NU
awk '{print $1}' NU > NI
cat field.pc >> NI
mv NI field.pc
sed -i "s/nroots 3/nroots 4/g" protein.inp
bash ~/bin/mORCA3 protein
cd ../../ 
