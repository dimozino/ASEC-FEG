#!/bin/bash
Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`
step=`grep "Step" Infos.dat | awk '{ print $2 }'`
chromo=`grep "chromo" Infos.dat | awk '{ print $2 }'`



mkdir Update
cd Update
cp ../MD_ASEC/Best_Config.gro .
cp ../calculations/dft/${Project}_dft.Final.xyz .
cp ../calculations/resp/newcharges.txt .
python ../../files/update_retcoords.py 
awk '{printf "%8s %6s %4d %7.3f %7.3f %7.3f\n", $1, $2, $3, $4, $5, $6}' ret >> reta
cat reta >> start
cat end >> start 
rm ret reta end 
mv start ${Project}_new.gro 
cp ../../files/topol_temp.top .
python ../../files/update_charges.py 
step1=$(($step+1))
cd ../../
mkdir Step_$step1
cd Step_$step1
cp ../Step_$step/Infos.dat .
sed -i "/Step/d" Infos.dat 
echo "Step $step1" >> Infos.dat 
mkdir Dynamic
cd Dynamic
cp $sourcedir/mdrun.mdp .
cp -r ../../files/amber* .
cp ../../files/posre.itp .
cp ../../files/${Project}.ndx .
cp ../../Step_$step/Update/topol.top .
cp ../../Step_$step/Update/${Project}_new.gro .
cd ../../
