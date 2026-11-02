mol new XXX.gro
set e [atomselect top all]
measure minmax $e
measure center $e
exit
