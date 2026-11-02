mol new XXX.gro
mol delrep 0 top
set babbeo [ atomselect top "((same residue as within YY of (resname MMM and not name CD HD1 HD2 CG HG1 HG2 CB HB1 HB2 CA HA N H C O)) and sidechain) and not resname MMM"]
set noah [$babbeo get resid]
set nogo [$babbeo get serial]
set filename residues_protein.dat
set fileser serials_protein.dat
set fileId [open $filename "w"]
set file2Id [open $fileser "w"]
puts -nonewline $fileId $noah
close $fileId
puts -nonewline $file2Id $nogo
close $file2Id
exit
