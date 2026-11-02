#!/bin/bash

# The script will prepare the .ndx file with the GroupDyna listing the fixed atoms in the end
# For protein cavity ASEC, the list of fixed atoms includes 
# All atoms of residues outside the cavity
# Backbone atoms of residues inside the cavity
# All chromophore atoms

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`
chromo=`grep "chromo" Infos.dat | awk '{ print $2 }'`
cavsize=`grep "cavsize" Infos.dat | awk '{ print $2 }'`
filecav=`grep "filecav" Infos.dat | awk '{ print $2 }'`

module add gromacs/2019.4/gcc
export OMPI_MCA_btl_openib_allow_ib=1
export OMPI_MCA_btl_openib_if_include="mlx5_0:1"



if [[ $filecav == y ]]; then

        # Here we generate the list of atomid for water molecules inside the cavity
	sed "s/XXX/${Project}/; s/YY/${cavsize}/; s/MMM/${chromo}/" $sourcedir/water_list_cavity.tcl > water_list_cavity.tcl 
	vmd -dispdev text -e water_list_cavity.tcl
	
	# Here we generate the list of atomid of residues inside the cavity
	# The backbone atoms are fixed for all residues

        echo "resid" > tempfile
        cat tempfile cavity > cavitysel
        residline=`tr '\n' ' ' < cavitysel`
	rm tempfile cavitysel 

        sed "s/XXX/${Project}/g; s/OOO/${residline}/g; s/MMM/${chromo}/g" $sourcedir/cavity_from_list.tcl > cavity_from_list.tcl 
	vmd -dispdev text -e cavity_from_list.tcl
	
	# Here we generate the list of atomid (a column) that will be MOVING during simulation

	cat serials_protein.dat >> serials_moving
        echo ""  >> serials_moving
        cat serials_water.dat >> serials_moving

	# Now we need to generate the list of atomid that will be fixed 
	# These atomid will be listed in the ndx file in the GroupDyna
	# To do this we generate the list of all atomid, and then remove the ones from serials.dat

	awk '{print $3}' ${Project}.gro > tempfile
        tail -n+3 tempfile > tempfile1
        head -n -1 tempfile1 > allatoms
        sed -i "s/^/ /g" allatoms 
        sed -i "s/$/ /g" allatoms
	rm tempfile tempfile1

	# Creating the serials_moving as a script that removes that lines containg atomid of moving atoms
	# From "allatoms" file creating the "fixedatoms" file 
        cp allatoms fixedatoms 
	sed -i "s/ /\n/g" serials_moving
	sed -i "s/^/sed -i \'\/ /g" serials_moving
        sed -i "s/$/ \/d\' fixedatoms /g" serials_moving
	chmod +x serials_moving
	./serials_moving 

	# Now we prepare the .ndx file with GroupDyna containing the atomid of atoms that are fixed
	# First lets prepare the fixedatoms in the format used in the .ndx file 

        awk 'BEGIN { ORS = " " } { print }' fixedatoms > fixedatoms1
	mv fixedatoms1 fixedatoms
	sed -i "s/   / /g" fixedatoms
	sed -i "s/  / /g" fixedatoms
	echo ":set tw=75" > shiftline.vim
	echo ":normal gqw" >> shiftline.vim
	echo ":x" >> shiftline.vim
	vim -es fixedatoms < shiftline.vim
	rm shiftline.vim

	# Now lets prepare the .ndx file 
	# Generating basic ndx file for protein
	
	gmx make_ndx -f ${Project}.gro -o ${Project}.ndx << EOF
	q
EOF
	
	# Creating GroupDyna in the end of .ndx file
	# It contains atomid of the fixed atoms (all atoms except cavity sidechains, chromo is also fixed)
	echo "[ GroupDyna ]" > tempfile
	cat tempfile fixedatoms >> ${Project}.ndx
	rm tempfile*

else
	
	# Here is an option when you do not have the list of residues in the cavity 

        # Here we generate the list of atomid for water molecules inside the cavity

        sed "s/XXX/${Project}/; s/YY/${cavsize}/; s/MMM/${chromo}/" $sourcedir/water_list_cavity.tcl > water_list_cavity.tcl 
        vmd -dispdev text -e water_list_cavity.tcl
        
        # Here we generate the list of atomid of residues inside the cavity
        # The backbone atoms are fixed for all residues 
	
	sed "s/XXX/${Project}/g; s/YY/${cavsize}/g; s/MMM/${chromo}/g" $sourcedir/cavity_from_size.tcl > cavity_from_size.tcl 
        vmd -dispdev text -e cavity_from_size.tcl
        
        # Here we generate the list of atomid (a column) that will be MOVING during simulation
                                                                                                                                
        cat serials_protein.dat >> serials_moving
        echo ""  >> serials_moving
        cat serials_water.dat >> serials_moving                                                                                                                               
        # Now we need to generate the list of atomid that will be fixed 
        # These atomid will be listed in the ndx file in the GroupDyna
        # To do this we generate the list of all atomid, and then remove the ones from serials.dat
                                                                                                                
        awk '{print $3}' ${Project}.gro > tempfile
        tail -n+3 tempfile > tempfile1
        head -n -1 tempfile1 > allatoms
        sed -i "s/^/ /g" allatoms 
        sed -i "s/$/ /g" allatoms
        rm tempfile tempfile1
                                                                                                                                  
        # Creating the serials_moving as a script that removes that lines containg atomid of moving atoms
        # From "allatoms" file creating the "fixedatoms" file 

	cp allatoms fixedatoms
	sed -i "s/ /\n/g" serials_moving
        sed -i "s/^/sed -i \'\/ /g" serials_moving
        sed -i "s/$/ \/d\' fixedatoms/g" serials_moving
        chmod +x serials_moving
        ./serials_moving 
                                                                                                                                  
        # Now we prepare the .ndx file with GroupDyna containing the atomid of atoms that are fixed
        # First lets prepare the fixedatoms in the format used in the .ndx file 
                                                                                                                                  
        awk 'BEGIN { ORS = " " } { print }' fixedatoms > fixedatoms1
	mv fixedatoms1 fixedatoms
        sed -i "s/   / /g" fixedatoms
        sed -i "s/  / /g" fixedatoms
        echo ":set tw=75" > shiftline.vim
        echo ":normal gqw" >> shiftline.vim
        echo ":x" >> shiftline.vim
        vim -es fixedatoms < shiftline.vim
        rm shiftline.vim
                                                                                                                                  
        # Now lets prepare the .ndx file 
        # Generating basic ndx file for protein
        
        gmx make_ndx -f ${Project}.gro -o ${Project}.ndx << EOF
        q     
EOF
	
        # Creating GroupDyna in the end of .ndx file
        # It contains atomid of the fixed atoms (all atoms except cavity sidechains, chromo is also fixed)

        echo "[ GroupDyna ]" > tempfile
        cat tempfile fixedatoms >> ${Project}.ndx                                                                                                 
	# Creating file named 'cavity' we will use later                                                                                    
        sed -i "s/ /\n/g" residues_protein.dat 
        awk '!seen[$1]++' residues_protein.dat > cavity
        
        rm tempfile*

fi 
