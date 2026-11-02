#!/bin/bash
Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`
step=`grep "Step" Infos.dat | awk '{ print $2 }'`
chromo=`grep "chromo" Infos.dat | awk '{ print $2 }'`
size=`grep "atoms" Infos.dat | awk '{ print $2 }'`

cd calculations
mkdir fororca
cd fororca
cp ../dft/${Project}_dft.Final.xyz .
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
