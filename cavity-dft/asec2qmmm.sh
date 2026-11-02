#!/bin/bash

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`

module add gromacs/2019.4/gcc
export OMPI_MCA_btl_openib_allow_ib=1
export OMPI_MCA_btl_openib_if_include="mlx5_0:1"

gmx editconf -f ${Project}.gro -o ${Project}_wi.pdb -label A


sed -i "s/ H1 / HT1/; s/ H2 / HT2/; s/ H3 / HT3/; s/1HG2/HG21/; s/2HG2/HG22/; s/3HG2/HG23/; s/1HH1 ARG/HH11 ARG/; s/2HH1 ARG/HH12 ARG/; s/1HH2 ARG/HH21 ARG/; s/2HH2 ARG/HH22 ARG/; s/1HG1/HG11/; s/2HG1/HG12/; s/3HG1/HG13/; s/HIE/HSE/; s/HID/HSD/; s/HIP/HSP/; s/GLH/GLU/; s/ASH/ASP/; s/HG  SER/HG1 SER/; s/1HD2/HD21/; s/2HD2/HD22/; s/3HD2/HD23/; s/1HE2/HE21/; s/2HE2/HE22/; s/1HD1/HD11/; s/2HD1/HD12/; s/3HD1/HD13/" ${Project}_wi.pdb
sed -i "s/ H / HN/g" ${Project}_wi.pdb
sed -i "s/OC1/OT1/; s/OC2/OT2/" ${Project}_wi.pdb 
sed -i "s/OW /OH2/; s/HW1/H1 /; s/HW2/H2 /; s/SOL A/TIP3W/" ${Project}_wi.pdb
sed -i "s/H7  RET/H71 RET/; s/H8  RET/H81 RET/; s/ H10 RET/H101 RET/; s/ H11 RET/H111 RET/; s/ H12 RET/H121 RET/; s/ H14 RET/H141 RET/; s/ H15 RET/H151 RET/; s/HZ  RET/HZ1 RET/; s/CT1/C16/; s/1HT1/H161/; s/2HT1/H162/; s/3HT1/H163/; s/CT2/C17/; s/1HT2/H171/; s/2HT2/H172/; s/3HT2/H173/; s/CT3/C18/; s/1HT3/H181/; s/2HT3/H182/; s/3HT3/H183/; s/CT4/C19/; s/1HT4/H191/; s/2HT4/H192/; s/3HT4/H193/; s/CT5/C20/; s/1HT5/H201/; s/2HT5/H202/; s/3HT5/H203/; s/RET/REL/" ${Project}_wi.pdb
sed -i "s/HG  CYS/HG1 CYS/" ${Project}_wi.pdb

