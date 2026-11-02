#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#**************************************************************************************#
# a-ARM protocol                                                                       #
# Laura Pedraza-Gonzalez                                                               #
# la.pedrazagonzalez@student.unisi.it                                                  #
# PhD student | Laboratory for Computational Photochemistry and Photobiology           #
# University of Siena                                                                  #
# Reference: J. Chem. Theory Comput., 2019, 15, pp 3134-3152                           #
#**************************************************************************************#

import os
import sys
import shutil
import inspect
import numpy as np
from itertools import groupby


#_____________________________________________________________________________________#
# hetatm_list ::: contains the HETATM lipids, ions and waters which sould be excluded #
# during the chromophore search.                                                      #
#_____________________________________________________________________________________#
hetatm_list =sorted([ "ACE", "HG", "HOH", "ZN", "HTG", "HTO", "MAN", "NAG", "BMA", "SO4",
                      "BNG", "A", "CL", "NA", "BOG", "PLM", "TWT", "OLA", "PEE", "GLC",
                      "GAL", "L2P", "L3P", "EDT", "OLC", "PO4", "22B", "L4P", "SQL",
                      "LI1", "D10", "D12", "HEX", "OCT", "LFA", "PCA", "DD9", "R16", "CA"])

#_____________________________________________________________________________________#
# aa_essential_list ::: contains the 20 essential amino acids.                        #
#_____________________________________________________________________________________#
aa_essential_list=["ALA","ARG","ASN","ASP","CYS","GLU","GLN","GLY","HIS","ILE","LEU",
                   "LYS","MET","PHE","PRO","SER","THR","TRP","TYR","VAL"]

#_____________________________________________________________________________________#
# PDB standard format.                                                                #
#_____________________________________________________________________________________#
pdb_std_format = "%-6s%5d %s %-4s%3s %s%4d %3s%8.3f%8.3f%8.3f%6.2f%s%6.2f %11s" # Standard PDB format

#_____________________________________________________________________________________#
#exclude_list ::: contains the ATOMS and HETATM lipids, ions and waters which sould be#
# excluded during the chromophore search.                                             #
#_____________________________________________________________________________________#

exclude_list= (aa_essential_list+hetatm_list)

#_____________________________________________________________________________________#
#Labels of the LYS 
#_____________________________________________________________________________________#
lyt_to_lys_list = ['N', 'CA', 'C', 'O', 'CB', 'CG', 'CD', 'CE', 'NZ']

#_____________________________________________________________________________________#
#Labels of the RET for the conversion of LYR into RET
#_____________________________________________________________________________________#
lyr_to_ret_dic = {'C17': 'C1',
                  'C16': 'C2',
                  'C15': 'C3',
                  'C14': 'C4',
                  'C12': 'C5',
                  'C11': 'C6',
                  'C10': 'C7',
                  'C9' : 'C8',
                  'C80': 'C9',
                  'C7' : 'C10',
                  'C6' : 'C11',
                  'C5' : 'C12',
                  'C3' : 'C13',
                  'C2' : 'C14',
                  'C1' : 'C15',
                  'C18': 'C16',
                  'C19': 'C17',
                  'C13': 'C18',
                  'C8' : 'C19',
                  'C4' : 'C20'
                  }

#_____________________________________________________________________________________#
#Dictionary DOWSER/GROMACS
#_____________________________________________________________________________________#

dowser_ret_dic = { 'C16' : 'CT1',
                   'C17' : 'CT2',
                   'C18' : 'CT3', 
                   'C19' : 'CT4',
                   'C20' : 'CT5',
                   'HZ1' : 'HZ ' }

dowser_gromacs = { "ILE" : { "CD1" : "CD " }, 
                   "HIS" : { "HIS" : "HIP" },
                   "THR" : { "HG " : "HG1" },
                   "ASH" : { "HD " : "HD2" },
                   "ARG" : { "2HH2" : "HH22",
                             "2HH1" : "HH12",
                             "1HH1" : "HH11",
                             "1HH2" : "HH21" },
                   "ASN" : { " HD1 ASN" : "HD21 ASN",
                             " HD2 ASN" : "HD22 ASN" },
                   "GLN" : { " HE1 GLN" : "HE21 GLN",
                             " HE2 GLN" : "HE22 GLN" }
                   }

#_____________________________________________________________________________________#
# Dictionary GROMACS - TINKER
#_____________________________________________________________________________________#
lys_at_names = [ "N", "H", "CA", "HA", "CB", "HB1", "HB2", "CG", "HG1", "HG2",
                 "CD", "HD1", "HD2", "CE", "HE1", "HE2", "NZ", "HZ", "C", "O" ]

md_postproc = { "1HH3" : " H1 ",
                "2HH3" : " H2 ",
                "3HH3" : " H3 ",
                "1HH1" : "HH11",
                "1HH2" : "HH21",
                "2HH1" : "HH12",
                "2HH2" : "HH22",
                "1HD1" : "HD11",
                "2HD1" : "HD12",
                "3HD1" : "HD13",
                "1HD2" : "HD21",
                "2HD2" : "HD22",
                "3HD2" : "HD23",
                "1HE1" : "HE11",
                "2HE1" : "HE12",
                "3HE1" : "HE13",
                "1HE2" : "HE21",
                "2HE2" : "HE22",
                "3HE2" : "HE23",
                "1HG1" : "HG11",
                "2HG1" : "HG12",
                "3HG1" : "HG13",
                "1HG2" : "HG21",
                "2HG2" : "HG22",
                "3HG2" : "HG23",
                "OC1"  : "O  ",
                "OC2"  : "O2 "
                # " CT1" : " C16", # can be removed
                # " CT2" : " C17", # can be removed
                # " CT3" : " C18", # can be removed
                # " CT4" : " C19", # can be removed
                # " CT5" : " C20", # can be removed
                }

#_____________________________________________________________________________________#
#List of the ionizable residues for propka analysis
#_____________________________________________________________________________________#

neg_residue_list = ['ASP', 'GLU', 'C-', 'Oco', 'ACE']
pos_residue_list = ['ARG', 'LYS', 'HIS', 'N+']

ionizable_residues_list = neg_residue_list+pos_residue_list
ionizable_residues_mem_list = ['ASP', 'GLU', 'ARG', 'LYS', 'HIS', 'CYS', 'TYR']

#_____________________________________________________________________________________#
# List of the possible protonation states of HIS
#_____________________________________________________________________________________#
his_list = ["HIE", "HID", "HIP"]

protonation_states = {'ASP': 'ASH',
                      'LYS':'LYD',
                      'GLU':'GLH',
                      'ARG':'ARN'}

neutral_aa_list = ['ASH', 'LYD', 'HID', 'HIE', 'GLH']
#_____________________________________________________________________________________#
# propka modeled pKa
#_____________________________________________________________________________________#
modeled_pka = {'ASP': '3.80',
               'LYS':'10.5',
               'GLU':'4.50',
               'ARG':'12.5',
               'HIS': '6.50',
               'C-': '3.20',
               'N+': '8.00'}
#_____________________________________________________________________________________#
# Lists for putIon
#_____________________________________________________________________________________#
pos_aminoacid_list = ['ARG', 'LYS', 'HIS']
neg_aminoacid_list = ['ASP', 'GLU']
charged_aminoacid_list = pos_aminoacid_list + neg_aminoacid_list
ion_pos = ['K', 'NA']
ion_neg = ['CL']
ion_list = ion_pos + ion_neg

#_____________________________________________________________________________________#
# Dictionaries for format conversion in mutants generation
#_____________________________________________________________________________________#
aa_three_to_one_dic = {'CYS': 'C', 'ASP': 'D', 'SER': 'S', 'GLN': 'Q', 'LYS': 'K',
                       'ILE': 'I', 'PRO': 'P', 'THR': 'T', 'PHE': 'F', 'ASN': 'N',
                       'GLY': 'G', 'HIS': 'H', 'LEU': 'L', 'ARG': 'R', 'TRP': 'W',
                       'ALA': 'A', 'VAL': 'V', 'GLU': 'E', 'TYR': 'Y', 'MET': 'M', 
                       'UNK': '*'}

aa_one_to_three_dic = {}
for key in aa_three_to_one_dic:
    aa_one_to_three_dic[aa_three_to_one_dic.get(key)] = key

#__________________________________________________#
# List required by "arm_get_moldenlab_lb"
#__________________________________________________#
qm_lys_list = ["CE", "NZ", "HZ1", "HE2", "HE3", "HZ", "HE1"]


#___> FIXED BACKBONE
mm_lys_list = ["CB", "CG", "CD", "HB2", "HB3", "HG2", "HG3", "HD1", "HD2", "HD3", "HB1", "HG1"]
backbn_list = ["N", "CA", "C", "O", "H", "HA"]

# Tinker Lysine charges
lysine_chgs = { "N"   : -0.39805,
                "CA"  : -0.2400,
                "C"   :  0.68395,
                "O"   : -0.63955,
                "H"   :  0.22455,
                "HA"  :  0.1426,
                "CB"  : -0.0094,
                "CG"  :  0.0187,
                "CD"  :  0.0000,
                "CE"  :  0.0000,
                "NZ"  :  0.0000,
                "HB1" :  0.0362,
                "HB2" :  0.0362,
                "HG1" :  0.0103,
                "HG2" :  0.0103,
                "HD1" :  0.0621,
                "HD2" :  0.0621,
                "HE1" :  0.0000,
                "HE2" :  0.0000,
                "HZ"  :  0.0000
                }

#---> TEST RELAXED BACKBONE
#mm_lys_list = ["CB", "CG", "CD", "HB2", "HB3", "HG2", "HG3", "HD2", "HD3", "H", "HA", "CA","N", "C", "O"]
#backbn_list = []


#_____________________________________________________________________________________#
# Dictionary of chromophores
#_____________________________________________________________________________________#

chromophores_dic = { 'AT' : { 'charge' : 1,
                              'n_active' : 12, 
                              'n_inactive' : 76,
                              'ras_2' : 12 }, 
                     '11C' : { 'charge' : 1,
                               'n_active' : 12, 
                               'n_inactive' : 76,
                               'ras_2' : 12 }, 
                     '13C' : { 'charge' : 1,
                               'n_active' : 12, 
                               'n_inactive' : 76,
                               'ras_2' : 12 }, 
                     '7C' : { 'charge' : 1,
                              'n_active' : 12, 
                              'n_inactive' : 76,
                              'ras_2' : 12 },
                     '9C' : { 'charge' : 1,
                              'n_active' : 12, 
                              'n_inactive' : 76,
                              'ras_2' : 12 },  
                     'R5R' : { 'charge' : 1,
                               'n_active' : 12, 
                               'n_inactive' : 75,
                               'ras_2' : 12 },  
                     'R6R' : { 'charge' : 1,
                               'n_active' : 12, 
                               'n_inactive' : 79,
                               'ras_2' : 12 },  
                     'R7R' : { 'charge' : 1,
                               'n_active' : 12, 
                               'n_inactive' : 83,
                               'ras_2' : 12 },  
                     'R8R' : { 'charge' : 1,
                               'n_active' : 12, 
                               'n_inactive' : 87,
                               'ras_2' : 12 },  
                     'PHR' : { 'charge' : 1,
                               'n_active' : 12, 
                               'n_inactive' : 87,
                               'ras_2' : 12 },  
                 }


#_____________________________________________________________________#
# Dictionaries for pdb format conversion in initial conditions
#_____________________________________________________________________#
# pdb_2_tk_residues_dic = {'1HD1': 'HD11',
#                          '2HD1': 'HD12',
#                          '3HD1': 'HD13',
#                          '1HD2': 'HD21',
#                          '2HD2': 'HD22',
#                          '3HD2': 'HD23',
#                          '1HG1': 'HG11',
#                          '2HG1': 'HG12',
#                          '3HG1': 'HG13',
#                          '1HG2': 'HG21',
#                          '2HG2': 'HG22',
#                          '3HG2': 'HG23',
#                          '1HH3': ' H1 ',
#                          '2HH3': ' H2 ',
#                          '3HH3': ' H3 ',
#                          'OC1': 'O  ',
#                          'OC2': 'O2 '}

pdb_2_tk_wt_dic = {'ATOM  ': 'HETATM',
                   'SOL': 'HOH',
                   'OW': 'O ',
                   'HW1': 'H1 ',
                   'HW2': 'H2 '} 

pdb_2_tk_ions_list = ['CL', 'NA', 'ACI']

pdb_2_tk_ret_dic = {' CF ': ' C10',
                    ' CI ': ' C11',
                    ' CJ ': ' C12',
                    ' CK ': ' C14',
                    ' CM ': ' C15',
                    ' CO ': ' C16',
                    ' CP ': ' C17',
                    ' CQ ': ' C18',
                    ' CU ': ' C19',
                    ' CX ': ' C20'}

pdb_2_tk_lys_list_old = ['N  ', 'H  ', 'CA ', 'HA ', 'CB ', 'HB1', 'HB2', 
                         'CG ', 'HG1', 'HG2', 'CD ', 'HD1', 'HD2', 'CE ',
                         'HE1', 'HE2', 'NZ ', 'HZ1', 'C  ', 'O   '] 

pdb_2_tk_lys_dic = {'HB1': 'HB1',
                    'HB2': 'HB2',
                    'HG1': 'HG1',
                    'HG2': 'HG2',
                    'HD1': 'HD1',
                    'HD2': 'HD2',
                    'HE1': 'HE1',
                    'HE2': 'HE2',
                    'HZ1' : 'HZ '}

# pdb_2_tk_lys_dic = {'HB1': 'HB2',
#                     'HB2': 'HB3',
#                     'HG1': 'HG2',
#                     'HG2': 'HG3',
#                     'HD1': 'HD2',
#                     'HD2': 'HD3',
#                     'HE1': 'HE2',
#                     'HE2': 'HE3'}


pdb_2_tk_lys_list = ['N  ', 'H  ', 'CA ', 'HA ', 'CB ', 'CG ', 'CD ', 
                     'CE ', 'NZ ', 'HZ1', 'C  ', 'O   ']


def pdb_format_new(pdb_input, chromophore_name="RET"):
    '''
    Function to prepare the input to Tinker within the ARM protocol.

    Parameters
    ----------
    pdb_input: string.
        Name of the input pdb file.
    '''

    # Here we create a list of the lines of a pdb file for each residue type
    waters_pdb = []
    ions_pdb = []
    protein_pdb = []
    retinal_C_pdb = []
    retinal_H_pdb = []
    with open(pdb_input) as f:
        for line in f:

            line = line.rstrip()
            ls = line.split()

            try:
                for k, v in md_postproc.items():
                    line = line.replace(k, v)

                if ls[3] == "SOL":
                    line = line.replace("ATOM  ", "HETATM")
                    line = line.replace("SOL", "HOH")
                    line = line.replace("OW", "O ")
                    line = line.replace("HW1", "H1 ")
                    line = line.replace("HW2", "H2 ")
                    waters_pdb.append(line)

                elif ls[3] in ion_list or ls[3] == "ACI": 
                    line = line.replace("ATOM  ", "HETATM")
                    ions_pdb.append(line)

                elif ls[3] == chromophore_name:
                    if ls[2] in lys_at_names:
                        line = line.replace(chromophore_name, "LYS")
                        protein_pdb.append(line)
                    else:
                        line = line[:21] + "Z   1" + line[26:]
                        line = line.replace("ATOM  ", "HETATM")
                        if "C" in ls[2]:
                            retinal_C_pdb.append(line)
                        else:
                            line = line[:12] + "HR  " + line[16:]
                            retinal_H_pdb.append(line)
                else:
                    protein_pdb.append(line)

            except:
                pass

    retinal_pdb = retinal_C_pdb + retinal_H_pdb
    new_pdb_lines = protein_pdb + ions_pdb + retinal_pdb + waters_pdb + [ "END" ]
    final_pdb = 'final_'+os.path.split(pdb_input)[1]

    with open(final_pdb, "w") as f:
        for line in new_pdb_lines:
            f.write(line + "\n")

    return final_pdb

if __name__ == '__main__':
    pdb_format_new(sys.argv[1], sys.argv[2])
