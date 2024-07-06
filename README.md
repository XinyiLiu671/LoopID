###########################################################################################
# Calculating the maintaining score from IPMS data
###########################################################################################
Maintaining score: the correlation between the presence of the protein in the looposome and the condensate-forming ability of JMJD2. A higher score indicated a higher likelihood of the protein being retained within the looposome by JMJD2 condensates.

Experimental groups: 
Ctrl: Oct4 E-P looposome in Jmjd2a/b/cfl/fl mESCs.
TKO: Oct4 E-P looposome in Jmjd2a/b/c-/- mESCs.
Mut: Oct4 E-P looposome in Jmjd2a/b/c-/- mESCs overexpressing condensate-incapable mutants of JMJD2.
Mut-hIDR1: Oct4 E-P looposome in Jmjd2a/b/c-/- mESCs overexpressing condensate-rescue mutants of JMJD2.
hIDR1: Oct4 E-P looposome in Jmjd2a/b/c-/- mESCs overexpressing hIDR1 for negative contrl.

Input files:
Data_xxx_vs_nonsgRNA.xls: The differential analysis results of looposome performed by SAINTexpress using default parameters.

Output files:
Network_xxx.csv: network file for Cytoscape.
MaintainingScore_annotation.txt: annotation file of maintaining score for Cytoscape
