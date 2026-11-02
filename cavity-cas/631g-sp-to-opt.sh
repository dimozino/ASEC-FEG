#!/bin/bash

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`





cd calculations
mkdir 6-31g-opt
cd 6-31g-opt
cp ../6-31g/${Project}_6-31G.xyz ${Project}_6-31G_Opt.xyz
cp ../6-31g/${Project}_6-31G.key ${Project}_6-31G_Opt.key
cp ../6-31g/${Project}_6-31G.JobIph ${Project}_6-31G_Opt.JobIph
cp ../6-31g/${Project}_6-31G.Espf.Data ${Project}_6-31G_Opt.Espf.Data
cp ../../../files/${Project}_6-31G_Opt.input .
cp ../6-31g/melacu63.prm .
sed "s/${Project}_OptSCF/${Project}_6-31G_Opt/g" ../optscf/molcas.sh > molcas.sh
bash ~/bin/mBASH molcas -Npr 1 -Time 20

cd ../../
