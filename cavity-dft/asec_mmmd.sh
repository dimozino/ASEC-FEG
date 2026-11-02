#!/bin/bash

# Path to the folder with scripts 
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`


# Collect the information and generate initial gromacs files
cp $sourcedir/residuetypes.dat .
$sourcedir/start_asec.sh

# Generate the simulation box for Gromacs 
$sourcedir/gen_simbox.sh

# Generate .ndx file containing list of fixed atoms (not cavity atoms; backbone atoms; chromophore atoms) named GroupDyna
$sourcedir/ndx_cavity.sh

# Perform quick optimization in the force field of yours 
$sourcedir/energyminimization.sh
$sourcedir/prepare_files.sh 

# Go to Step 0 
$sourcedir/gen_step0.sh 
cd ../Step_0

# Run MD Step 0
$sourcedir/mdrun_mmmd.sh
