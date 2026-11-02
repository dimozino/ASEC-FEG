#!/bin/bash
Project=`grep "Project" Infos.dat | awk '{ print $2 }'`

cd calculations
mkdir 3-21g
cd 3-21g
cp ../optscf/${Project}_OptSCF.Final.xyz ${Project}_3-21G.xyz
cp ../optscf/melacu63.prm .
cp ../../../files/${Project}_3-21G.input .
cp ../optscf/${Project}_OptSCF.key ${Project}_3-21G.key 
sed "s/${Project}_OptSCF/${Project}_3-21G/g" ../optscf/molcas.sh > molcas.sh 
bash ~/bin/mBASH molcas -Npr 1 -Time 20

cd ../../
