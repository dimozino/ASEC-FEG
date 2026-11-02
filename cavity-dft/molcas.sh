#!/bin/bash

export MOLCAS=/home/ibsbnicigt/ryazantsev_m/7.8.dev_prev
export MOLCASMEM=10000MB
export MOLCAS_MOLDEN=ON
export MOLCAS_PRINT=normal
export MOLCAS_LICENSE=/home/ibsbnicigt/ryazantsev_m/7.8.dev_prev
export TINKER=/home/ibsbnicigt/ryazantsev_m/7.8.dev_prev/tinker/bin_qmmm

export Project=XXX
export InpDir=$PWD
export WorkDir=/tmp/molcas$RANDOM
mkdir -p $WorkDir

module add compiler/gcc/5

~/bin/molcas $InpDir/$Project.input >$InpDir/$Project.out 2>$InpDir/$Project.err 

rm -rf $WorkDir

