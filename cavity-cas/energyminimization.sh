#!/bin/bash

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`
module add gromacs/2019.4/gcc
export OMPI_MCA_btl_openib_allow_ib=1
export OMPI_MCA_btl_openib_if_include="mlx5_0:1"


cp $sourcedir/min.mdp .
gmx grompp -f min.mdp -n ${Project}.ndx -c ${Project}_box.gro -p topol.top -o em.tpr -maxwarn 8
gmx mdrun -deffnm em -v 
mv em.gro ${Project}_box_opt.gro 
rm em*

