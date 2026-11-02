#!/bin/bash

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`





cd calculations
mkdir 3-21g-opt
cd 3-21g-opt
cp ../3-21g/${Project}_3-21G.xyz ${Project}_3-21G_Opt.xyz
cp ../3-21g/${Project}_3-21G.key ${Project}_3-21G_Opt.key
cp ../3-21g/${Project}_3-21G.JobIph ${Project}_3-21G_Opt.JobIph
cp ../3-21g/${Project}_3-21G.Espf.Data ${Project}_3-21G_Opt.Espf.Data
cp ../../../files/${Project}_3-21G_Opt.input .
cp ../3-21g/melacu63.prm .
sed "s/${Project}_OptSCF/${Project}_3-21G_Opt/g" ../optscf/molcas.sh > molcas.sh
bash ~/bin/mBASH molcas -Npr 1 -Time 20
cd ../../
