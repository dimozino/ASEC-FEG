#!/bin/bash
Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`


$sourcedir/preresp.sh
cd calculations
mkdir resp
cd resp
cp ../dft/${Project}_dft.Final.xyz .
cp ../pre-resp/${Project}_dft.xyz_2 .
grep "^charge " ../dft/melacu63.prm > charges.txt 

python ../../../files/qmcoords_dft.py 
cat retlah.xyz >> ret.xyz 
python ../../../files/field_dft_resp.py 
cp $sourcedir/respheaderorca opt.inp 
cat ret.xyz >> opt.inp 
echo "*" >> opt.inp
wc -l field.pc > NU
awk '{print $1}' NU > NI
cat field.pc >> NI
mv NI field.pc
bash ~/bin/mORCA3_r opt
/home/ibsbnicigt/nikolaev_d/Multiwfn_3.8_dev_bin_Linux_noGUI/Multiwfn opt.molden.input << EOF
7
18
1
y
0
0
q
EOF
awk '{print $5}' opt.molden.chg > newcharges.txt
cd ../../
