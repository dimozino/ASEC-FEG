mol new XXX.gro
mol delrep 0 top
set babbeo [ atomselect top "(OOO and sidechain) and not resname MMM"]
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
