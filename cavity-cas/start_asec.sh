#!/bin/bash

# Initialization of Gromacs
module add gromacs/2019.4/gcc
export OMPI_MCA_btl_openib_allow_ib=1
export OMPI_MCA_btl_openib_if_include="mlx5_0:1"
module load python/3.8

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
chromo=`grep "chromo" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`

echo "Step 0" >> Infos.dat
cp -r $sourcedir/amber99sb_lipid.ff .

## Below we perform renamings for the standard cases that can occur in pdb

sed -i "s/ X / A /g; s/SOL/HOH/g" $Project.pdb
sed -i "s/HG1 SER/ HG SER/g; s/HG1 CYS/ HG CYS/g; s/OT1/OC1/g; s/OT2/OC2/g; s/HSD/HID/g; s/HSE/HIE/g; s/HSP/HIP/g" ${Project}.pdb
sed -i "s/O   HOH/OW  HOH/g" ${Project}.pdb
sed -i "s/H1  HOH/HW1 HOH/g" ${Project}.pdb
sed -i "s/H2  HOH/HW2 HOH/g" ${Project}.pdb

# Generating gromacs files 
# We use the force field folder that is located in the workdir

gmx pdb2gmx -f ${Project}.pdb -o ${Project}.gro << EOF
1
1
EOF

# Modifying the topology file
python3 $sourcedir/correct_top.py -i topol.top -r $chromo

$sourcedir/prepare_files.sh

