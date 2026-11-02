#!/bin/bash

templatedir=`grep "sourcedir" Infos.dat | awk '{print $2}'`
Project=`grep "Project" Infos.dat | awk '{print $2}'`

ir=`grep "RET" ${Project}.gro | head -1 | awk '{print $3}'`
lr=`grep "RET" ${Project}.gro | tail -1 | awk '{print $3}'`
firsthoh=`grep "HOH" ${Project}.gro | head -1 | awk '{print $3}'`
oc2=$(($firsthoh - 1))
last=`grep "HOH" ${Project}.gro | tail -1 | awk '{print $3}'`

n=$ir
h=$(($ir+1))
ca=$(($ir+2))
ha=$(($ir+3))
cb=$(($ir+4))
hb1=$(($ir+5))
hb2=$(($ir+6))
cg=$(($ir+7))
hg1=$(($ir+8))
hg2=$(($ir+9))
cda=$(($ir+10))
hd1=$(($ir+11))
hd2=$(($ir+12))
ce=$(($ir+13))
he1=$(($ir+14))
he2=$(($ir+15))
nz=$(($ir+16))
hz=$(($ir+17))
c=$(($ir+18))
o=$(($ir+19))

c1=$(($oc2-47))
hr=$oc2
la=$(($last+1))
la1=$(($la+1))
la2=$(($la+2))
ow=$(($oc2+1))
o1=$(($o+1))
ir1=$(($ir+1))
lr2=$(($lr+2))
last2=$(($last+2))
cp topol.top topol_temp.top 


sed "s/natom/${n}/g; s/hatom/${h}/g; s/caatom/${ca}/g; s/haatom/${ha}/g; s/cbatom/${cb}/g; s/hb1atom/${hb1}/g; s/hb2atom/${hb2}/g; s/cgatom/${cg}/g; s/hg1atom/${hg1}/g; s/hg2atom/${hg2}/g; s/cdatom/${cda}/g; s/hd1atom/${hd1}/g; s/hd2atom/${hd2}/g; s/ceatom/${ce}/g; s/he1atom/${he1}/g; s/he2atom/${he2}/g; s/nzatom/${nz}/g; s/hzatom/${hz}/g; s/catom/${c}/g; s/oatom/${o}/g; s/c1atom/${c1}/g; s/hratom/${hr}/g; s/laatom/${la}/g" $templatedir/Rh_OptSCF.key > ${Project}_OptSCF.key

sed "s/natom/${n}/g; s/hatom/${h}/g; s/caatom/${ca}/g; s/haatom/${ha}/g; s/cbatom/${cb}/g; s/hb1atom/${hb1}/g; s/hb2atom/${hb2}/g; s/cgatom/${cg}/g; s/hg1atom/${hg1}/g; s/hg2atom/${hg2}/g; s/cdatom/${cda}/g; s/hd1atom/${hd1}/g; s/hd2atom/${hd2}/g; s/ceatom/${ce}/g; s/he1atom/${he1}/g; s/he2atom/${he2}/g; s/nzatom/${nz}/g; s/hzatom/${hz}/g; s/catom/${c}/g; s/oatom/${o}/g; s/c1atom/${c1}/g; s/hratom/${hr}/g" $templatedir/final_Rh.key > final_${Project}.key

cp $templatedir/Rh_OptSCF.input ${Project}_OptSCF.input
cp $templatedir/Rh_3-21G.input ${Project}_3-21G.input
cp $templatedir/Rh_3-21G_Opt.input ${Project}_3-21G_Opt.input
cp $templatedir/Rh_6-31G.input ${Project}_6-31G.input
cp $templatedir/Rh_6-31G_Opt-1.input ${Project}_6-31G_Opt-1.input
cp $templatedir/Rh_6-31G_Opt.input ${Project}_6-31G_Opt.input
cp $templatedir/Rh_CASPT2.input ${Project}_CASPT2.input
cp $templatedir/melacu63.prm .

sed "s/ceatom/${ce}/g; s/he1atom/${he1}/g; s/he2atom/${he2}/g; s/nzatom/${nz}/g; s/hzatom/${hz}/g; s/laatom/${la}/g; s/owatom/${ow}/g; s/protein/${Project}/g; s/c1atom/${c1}/g" $templatedir/qmcoords.py > qmcoords.py 


sed "s/natom/${n}/g; s/nzatom/${nz}/g; s/ceatom/${ce}/g; s/c1atom/${c1}/g; s/owatom/${ow}/g; s/catom/${c}/g; s/oatom/${o}/g; s/laatom/${la}/g; s/la1atom/${la1}/g; s/protein/${Project}/g" $templatedir/field1.py > field1.py


sed "s/natom/${n}/g; s/hatom/${h}/g; s/o1atom/${o1}/g; s/owatom/${ow}/g; s/c1atom/${c1}/g; s/protein/${Project}/g; s/ir1atom/${ir1}/g; s/lr2atom/${lr2}/g; s/la2atom/${la2}/g" $templatedir/update_retcoords.py > update_retcoords.py 

cp $templatedir/update_charges.py .

c1line=`grep -rwn "RET     C1" topol.top | awk '{print $1}'`
c1l=${c1line::-1}
sed -i "${c1l}s/  0.671828 /  c1char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.217668 /  c2char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   0.05067 /  h21char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   0.05067 /  h22char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.075694 /  c3char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.018903 /  h31char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.018903 /  h32char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.278879 /  c4char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.088546 /  h41char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.088546 /  h42char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.386458 /  c5char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.521185 /  c6char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   0.22715 /  c7char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.101459 /  h71char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.466486 /  c8char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.194572 /  h81char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.404354 /  c9char  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.455269 /  c10char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.189577 /  h101char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.219509 /  c11char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.143946 /  h111char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.635779 /  c12char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.202968 /  h121char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.740405 /  c13char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.751946 /  c14char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.246358 /  h141char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   0.30573 /  c15char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.176904 /  h151char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.556897 /  ct1char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.129067 /  ht11char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.129067 /  ht12char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.129067 /  ht13char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.556897 /  ct2char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.129067 /  ht21char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.129067 /  ht22char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.129067 /  ht23char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.494588 /  ct3char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.134713 /  ht31char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.134713 /  ht32char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.134713 /  ht33char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.356442 /  ct4char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.117005 /  ht41char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.117005 /  ht42char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.117005 /  ht43char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.480967 /  ct5char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.142602 /  ht51char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.142602 /  ht52char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.142602 /  ht53char/" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   -0.3479 / -0.3479  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/    0.2747 /  0.2747  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/     -0.24 /   -0.24  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/    0.1426 /  0.1426  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   -0.0094 / -0.0094  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/    0.0362 /  0.0362  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/    0.0362 /  0.0362  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/    0.0187 /  0.0187  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/    0.0103 /  0.0103  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/    0.0103 /  0.0103  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.053632 / cdchar   /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   0.03665 / 0.03665  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   0.03665 / 0.03665  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.216278 /  cechar  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.101532 /  he1char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.101532 /  he2char /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/ -0.347217 /   nzchar /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/  0.369592 /   hzchar /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/    0.7341 /  0.7341  /" topol_temp.top
c1l=$(($c1l + 1))
sed -i "${c1l}s/   -0.5894 / -0.5894  /" topol_temp.top

