mol new YYY.pdb 
set babbeo [ atomselect top "XXX"]
set nogo [$babbeo get serial]
set fileser serials.dat
set file2Id [open $fileser "w"]
puts -nonewline $file2Id $nogo
close $file2Id
exit
