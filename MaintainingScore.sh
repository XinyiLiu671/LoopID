###########################################################################################
# Calculating the maintaining score from IPMS data
###########################################################################################
# Maintaining score: the correlation between the presence of the protein in the looposome and the condensate-forming ability of JMJD2. A higher score indicated a higher likelihood of the protein being retained within the looposome by JMJD2 condensates.

# Experimental groups: 
# Ctrl: Oct4 E-P looposome in Jmjd2a/b/cfl/fl mESCs.
# TKO: Oct4 E-P looposome in Jmjd2a/b/c-/- mESCs.
# Mut: Oct4 E-P looposome in Jmjd2a/b/c-/- mESCs overexpressing condensate-incapable mutants of JMJD2.
# Mut-hIDR1: Oct4 E-P looposome in Jmjd2a/b/c-/- mESCs overexpressing condensate-rescue mutants of JMJD2.
# hIDR1: Oct4 E-P looposome in Jmjd2a/b/c-/- mESCs overexpressing hIDR1 for negative contrl.

# Input files:
# Data_xxx_vs_nonsgRNA.xls: The differential analysis results of looposome performed by SAINTexpress using default parameters.

# Output files:
# Network_xxx.csv: network file for Cytoscape.
# MaintainingScore_annotation.txt: annotation file of maintaining score for Cytoscape

###########################################
# Generating network files for Cytoscape
###########################################
#Mut
perl -e 'print "Source,Target,Weight\n"' > Network_Mut.csv
perl -lane '$Count_cf = 30; $P_cf = 1; $FC_cf = 3; if ($. != 1){$GN = $F[2]; ($sig1,$sig2) = split(/\|/,$F[3]); $AvgP = $F[8]; $MaxP = $F[9]; $FC = $F[14]; if ($sig1 >= $Count_cf && $sig2 >= $Count_cf && $AvgP >= $P_cf && $FC >= $FC_cf){$Name = uc($F[2]); print "Mut,$Name,1"}}' Data/Data_Mut_vs_nonsgRNA.xls >> Network_Mut.csv

#Mut-hIDR1
perl -e 'print "Source,Target,Weight\n"' > Network_Rescue.csv
perl -lane '$Count_cf = 30; $P_cf = 1; $FC_cf = 3; if ($. != 1){$GN = $F[2]; ($sig1,$sig2) = split(/\|/,$F[3]); $AvgP = $F[8]; $MaxP = $F[9]; $FC = $F[14]; if ($sig1 >= $Count_cf && $sig2 >= $Count_cf && $AvgP >= $P_cf && $FC >= $FC_cf){$Name = uc($F[2]); print "Mut-hIDR1,$Name,1"}}' Data/Data_Mut-hIDR1_vs_nonsgRNA.xls >> Network_Mut-hIDR1.csv

#IDR1
perl -e 'print "Source,Target,Weight\n"' > Network_hIDR1.csv
perl -lane '$Count_cf = 30; $P_cf = 1; $FC_cf = 3; if ($. != 1){$GN = $F[2]; ($sig1,$sig2) = split(/\|/,$F[3]); $AvgP = $F[8]; $MaxP = $F[9]; $FC = $F[14]; if ($sig1 >= $Count_cf && $sig2 >= $Count_cf && $AvgP >= $P_cf && $FC >= $FC_cf){$Name = uc($F[2]); print "hIDR1,$Name,1"}}'  Data/Data_hIDR1_vs_nonsgRNA.xls >> Network_hIDR1.csv

###########################################
# Calculating the maintaining score
###########################################
# PhaseRescue Score= log2FC(Mut-hIDR1/Mut) - log2FC(hIDR1 / Mut) / avg(log2FC(Ctrl/TKO) + log2FC(Ctrl/Mut))
# -log10 Pvalue = avg(-log10P(Mut-hIDR1/Mut) + -log10P(Ctrl/TKO) + -log10P(Ctrl/Mut))

cat Network* | perl -F"," -lane 'print $F[1]' | sort -u | grep -v 'Target' > tmp.All.ids

#TKO vs Ctrl
	perl -lane '$GN = uc($F[2]); $AvgP = $F[8]; $FC = $F[14]; if ($. != 1){print "$GN\t$AvgP\t$FC"}' Data/Data_Ctrl_vs_TKO.xls | sort -k 2 -r > tmp.TKOvsCtrl.anno
	perl -lane '$GN = uc($F[2]); $AvgP = $F[8]; $FC = $F[14]; if ($. != 1){print "$GN\t$AvgP\t$FC"}' Data/Data_TKO_vs_Ctrl.xls | sort -k 2 -r >> tmp.TKOvsCtrl.anno
#Mut-hIDR1 vs Mut
	perl -lane '$GN = uc($F[2]); $AvgP = $F[8]; $FC = $F[14]; if ($. != 1){print "$GN\t$AvgP\t$FC"}' Data/Data_Mut-hIDR1_vs_Mut.xls | sort -k 2 -r > tmp.MuthIDR1vsMut.anno
	perl -lane '$GN = uc($F[2]); $AvgP = $F[8]; $FC = $F[14]; if ($. != 1){print "$GN\t$AvgP\t$FC"}' Data/Data_Mut_vs_Mut-hIDR1.xls | sort -k 2 -r >> tmp.MuthIDR1vsMut.anno
#hIDR1 vs Mut
	perl -lane '$GN = uc($F[2]); $AvgP = $F[8]; $FC = $F[14]; if ($. != 1){print "$GN\t$AvgP\t$FC"}' Data/Data_hIDR1_vs_Mut.xls | sort -k 2 -r > tmp.hIDR1vsMut.anno
	perl -lane '$GN = uc($F[2]); $AvgP = $F[8]; $FC = $F[14]; if ($. != 1){print "$GN\t$AvgP\t$FC"}' Data/Data_Mut_vs_hIDR1.xls | sort -k 2 -r >> tmp.hIDR1vsMut.anno		
#Mut vs Ctrl
	perl -lane '$GN = uc($F[2]); $AvgP = $F[8]; $FC = $F[14]; if ($. != 1){print "$GN\t$AvgP\t$FC"}' Data/Data_Ctrl_vs_Mut.xls | sort -k 2 -r > tmp.MutvsCtrl.anno
	perl -lane '$GN = uc($F[2]); $AvgP = $F[8]; $FC = $F[14]; if ($. != 1){print "$GN\t$AvgP\t$FC"}' Data/Data_Mut_vs_Ctrl.xls | sort -k 2 -r >> tmp.MutvsCtrl.anno

perl MaintainingScore.pl

rm tmp*
