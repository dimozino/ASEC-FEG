#!/bin/bash

# Initialization of Gromacs 
module add gromacs/2019.4/gcc
export OMPI_MCA_btl_openib_allow_ib=1
export OMPI_MCA_btl_openib_if_include="mlx5_0:1"
module load python/3.8

# Path to scripts and name of the protein 

sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`
Project=`grep "Project" Infos.dat | awk '{ print $2 }'`

# Launching the vmd script that calculates the size of the system to generate the simulation box in gromacs 
# The dimensions of simulation box is the last line in .gro file

sed "s/XXX/${Project}/" $sourcedir/size.tcl > size.tcl
vmd -dispdev text -e size.tcl > size.log

# Extracting info from size.log 

awk 'c&&!--c; /atomselect0/{c=1}' size.log > A
sed 's/{//g; s/}//g' A > AA
awk 'c&&!--c; /atomselect0/{c=2}' size.log > B
awk '{print $1}' AA > X1
awk '{print $4}' AA > X2
x1=$(cat X1)
x2=$(cat X2)
dx=$(awk "BEGIN {print $x2 - $x1 + 0.5; exit}")
ddx=$(awk -v v="$dx" 'BEGIN{printf "%d", v}')
Dx=$(awk "BEGIN {print $ddx + 32 ; exit}")
awk '{print $2}' AA > Y1
awk '{print $5}' AA > Y2
y1=$(cat Y1)
y2=$(cat Y2)
dy=$(awk "BEGIN {print $y2 - $y1 + 0.5; exit}")
ddy=$(awk -v v="$dy" 'BEGIN{printf "%d", v}')
Dy=$(awk "BEGIN {print $ddy + 32 ; exit}")
awk '{print $3}' AA > Z1
awk '{print $6}' AA > Z2
z1=$(cat Z1)
z2=$(cat Z2)
dz=$(awk "BEGIN {print $z2 - $z1 + 0.5; exit}")
ddz=$(awk -v v="$dz" 'BEGIN{printf "%d", v}')
Dz=$(awk "BEGIN {print $ddz + 32 ; exit}")

# The size with vmd is calculated in angstrom, boxdimensions.py converts in nm used in Gromacs

sed  "s/QQQ/${Dx}/; s/WWW/${Dy}/; s/EEE/${Dz}/" $sourcedir/boxdimensions.py > boxdimensions.py
python3 boxdimensions.py
rm A AA B X1 X2 Y1 Y2 Z1 Z2
t1=$(cat Xdim)
t2=$(cat Ydim)
t3=$(cat Zdim)

# Generating simulation box for the system
gmx editconf -f ${Project}.gro -bt triclinic -box $t1 $t2 $t3 -o ${Project}_box.gro -c
rm Xdim Ydim Zdim boxdimensions.py size.tcl size.log


