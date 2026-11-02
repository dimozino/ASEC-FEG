#!/bin/bash

Project=`grep "Project" Infos.dat | awk '{ print $2 }'`
sourcedir=`grep "sourcedir" Infos.dat | awk '{ print $2 }'`


sed "s/YYY/${Project}/" $sourcedir/ex.tcl > ex.tcl 

i=1 
IFS=$'\n' 
  
file=$(cat list_before_ret.txt)  
 
for line in $file
do
	sed "s/XXX/${line}/" ex.tcl > extract.tcl
	vmd -dispdev text -e extract.tcl
	sed -i "s/ /\n/g" serials.dat
	sed "s/^/awk \'NR==/; s/$/{print \$0}\' field.pc >> number_${i}.pc /" serials.dat > extract
	chmod +x extract
	./extract  
        cp number_${i}.pc remove
        cp field.pc not_number_${i}.pc
        sed -i "s/^/sed -i \"\//; s/$/\/d\" not_number_${i}.pc /" remove
        chmod +x remove
        ./remove
        num=`wc -l number_${i}.pc | awk '{print $1}'`
        echo "$num" > number
        cat number_${i}.pc >> number
        mv number number_${i}.pc

        num1=`wc -l not_number_${i}.pc | awk '{print $1}'`
        echo "$num1" > number
        cat not_number_${i}.pc >> number
        mv number not_number_${i}.pc                             
        
        mkdir number_${i} not_number_${i} 
        cd number_${i}
        cp ../number_${i}.pc .
        cp ../protein.inp .
        cp ../d.gbw .
        sed -i "s/Grid4/Grid4 moread noiter/" protein.inp
        sed -i "s/field/number_${i}/" protein.inp
        sed -i "/%scf maxiter=999/i %moinp \".\/d.gbw\"" protein.inp 
        bash ~/bin/mORCA3 protein 
        cd ../        

        cd not_number_${i}
        cp ../not_number_${i}.pc .
        cp ../protein.inp .
        cp ../d.gbw .
        sed -i "s/Grid4/Grid4 moread noiter/" protein.inp
        sed -i "s/field/not_number_${i}/" protein.inp
        sed -i "/%scf maxiter=999/i %moinp \".\/d.gbw\"" protein.inp
        bash ~/bin/mORCA3 protein 
        cd ../        

	i=$(($i+1))
done

file=$(cat list_after_ret.txt)  
 
for line in $file
do
	sed "s/XXX/${line}/" ex.tcl > extract.tcl
	vmd -dispdev text -e extract.tcl
	sed -i "s/ /\n/g" serials.dat
        awk '{print $1-50}' serials.dat > serials1.dat 
	sed "s/^/awk \'NR==/; s/$/{print \$0}\' field.pc >> number_${i}.pc /" serials1.dat > extract
	chmod +x extract
	./extract  
        cp number_${i}.pc remove
        cp field.pc not_number_${i}.pc
        sed -i "s/^/sed -i \"\//; s/$/\/d\" not_number_${i}.pc /" remove
        chmod +x remove
        ./remove
        num=`wc -l number_${i}.pc | awk '{print $1}'`
        echo "$num" > number
        cat number_${i}.pc >> number
        mv number number_${i}.pc

        num1=`wc -l not_number_${i}.pc | awk '{print $1}'`
        echo "$num1" > number
        cat not_number_${i}.pc >> number
        mv number not_number_${i}.pc                             

        mkdir number_${i} not_number_${i} 
        cd number_${i}
        cp ../number_${i}.pc .
        cp ../protein.inp .
        cp ../d.gbw .
        sed -i "s/Grid4/Grid4 moread noiter/" protein.inp
        sed -i "s/field/number_${i}/" protein.inp
        sed -i "/%scf maxiter=999/i %moinp \".\/d.gbw\"" protein.inp 
        bash ~/bin/mORCA3 protein 
        cd ../        

        cd not_number_${i}
        cp ../not_number_${i}.pc .
        cp ../protein.inp .
        cp ../d.gbw .
        sed -i "s/Grid4/Grid4 moread noiter/" protein.inp
        sed -i "s/field/not_number_${i}/" protein.inp
        sed -i "/%scf maxiter=999/i %moinp \".\/d.gbw\"" protein.inp 
        bash ~/bin/mORCA3 protein 
        cd ../        

	i=$(($i+1))
done
