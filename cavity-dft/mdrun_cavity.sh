#!/bin/bash

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`
step=`grep "Step" Infos.dat | awk '{ print $2 }'`

module add gromacs/2019.4/gcc
export OMPI_MCA_btl_openib_allow_ib=1
export OMPI_MCA_btl_openib_if_include="mlx5_0:1"


## Running MD to generate the ASEC environment by extracting 100 snapshots from the last 5000 steps 
## First 3000 steps are the equilibration 

cd Dynamic

# For Step_0 the files are copied from the files folder, otherwise they are copied by another script (go2nextstep.sh)

if [[ $step -eq 0 ]]; then
       cp ../../files/${Project}_box_opt.gro ${Project}_new.gro
       cp ../../files/topol.top .
       cp ../../files/${Project}.ndx .
       cp ../../files/*.itp .
       cp $sourcedir/mdrun.mdp . 
       cp -r ../../files/*.ff .
       gmx grompp -f mdrun.mdp -n ${Project}.ndx -c ${Project}_new.gro -p topol.top -o ${Project}.tpr -maxwarn 8
       mpiexec --bind-to none mdrun_gpu_mpi -v -s ${Project}.tpr -x ${Project}.xtc -e ${Project}.edr -c ${Project}.gro -g ${Project}.log -cpo ${Project}.cpt 
 
else 

       gmx grompp -f mdrun.mdp -n ${Project}.ndx -c ${Project}_new.gro -p topol.top -o ${Project}.tpr -maxwarn 8                    
       mpiexec --bind-to none mdrun_gpu_mpi -v -s ${Project}.tpr -x ${Project}.xtc -e ${Project}.edr -c ${Project}.gro -g ${Project}.log -cpo ${Project}.cpt  

fi       

cd ../
