Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
cd calculations
mkdir pre-resp
cd pre-resp
cp ../dft/${Project}_dft.key .
sed -i "s/QMMM 63/QMMM 62/g" ${Project}_dft.key
grep "^MM "  ${Project}_dft.key  | head -1 | awk '{print $3}' > z
grep "^MM "  ${Project}_dft.key  | head -1 | awk '{print $2}' > z1
mminit=$(cat z1)
mmold=$(cat z)
mmnew=$(($mmold - 3))
qmold=$(($mmold + 1))
qmnew=$(($mmnew + 1))
sed -i "s/MM ${mminit} ${mmold}/MM ${mminit} ${mmnew}/" ${Project}_dft.key
sed -i "s/ACTIVE ${mminit} ${mmold}/ACTIVE ${mminit} ${mmnew}/" ${Project}_dft.key
sed -i "s/QM -${qmold}/QM -${qmnew}/" ${Project}_dft.key
sed -i "s/ACTIVE -${qmold}/ACTIVE -${qmnew}/" ${Project}_dft.key
grep "^LA " ${Project}_dft.key | awk '{print $2}' > la
la=$(cat la)
la1=$(($la-1))
sed -i "/${la}/d" ${Project}_dft.key
head -$la ../dft/${Project}_dft.Final.xyz > pau
echo "$la1" > ${Project}_dft.xyz
tail -$la1 pau >> ${Project}_dft.xyz 
cp ../dft/melacu63.prm .
/home/ibsbnicigt/nikolaev_d/7.8.dev/tinker/bin_qmmm/xyzedit ${Project}_dft.xyz << EOF
20
1
EOF

cd ../../
