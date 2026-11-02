#!/bin/bash

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`





cd calculations
mkdir caspt2
cd caspt2
cp ../6-31g-opt/${Project}_6-31G_Opt.Final.xyz ${Project}_CASPT2.xyz
cp ../6-31g-opt/${Project}_6-31G_Opt.key ${Project}_CASPT2.key
cp ../6-31g-opt/${Project}_6-31G_Opt.JobIph ${Project}_CASPT2.JobIph
cp ../../../files/${Project}_CASPT2.input .
cp ../6-31g-opt/melacu63.prm .
sed "s/${Project}_OptSCF/${Project}_CASPT2/g" $HOME/scripts/molcas.sh > molcas.sh
bash ~/bin/mBASH molcas -Npr 1 -Time 20
cd ../../
