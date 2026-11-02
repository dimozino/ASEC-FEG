#!/bin/bash

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`
step=`grep "Step" Infos.dat | awk '{ print $2 }'`
chromo=`grep "chromo" Infos.dat | awk '{ print $2 }'`
PATH=/home/nikolaev_d/G_$HOSTNAME/gromacs-5.1.2/bin/:$PATH

cd calculations
mkdir 6-31g
cd 6-31g
cp ../3-21g-opt/${Project}_3-21G_Opt.Final.xyz ${Project}_6-31G.xyz
cp ../3-21g-opt/${Project}_3-21G_Opt.key ${Project}_6-31G.key
cp ../../../files/${Project}_6-31G.input .
cp ../3-21g-opt/melacu63.prm .
sed "s/${Project}_OptSCF/${Project}_6-31G/g" ../optscf/molcas.sh > molcas.sh
bash ~/bin/mBASH molcas -Npr 1 -Time 20
cd ../../
