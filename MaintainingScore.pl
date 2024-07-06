#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use List::Util qw/max min/; 

###########################################################################################
# Reading
###########################################################################################
my %data;
my @Names;

open( DATA, "< tmp.All.ids" ) or die "$!";
while(<DATA>){
    chomp;

    my @F = split /\s+/;
    my $ID = $F[0];
    push @Names, $ID;
}
close DATA;

open( DATA, "< tmp.TKOvsCtrl.anno" ) or die "$!";
while(<DATA>){
    chomp;

    my @F = split /\s+/;
    my $ID = $F[0];
    my $AvgP = $F[1];
    my $FC = $F[2];
    
    if ($data{$ID}{AvgP}{TKOvsCtrl}){
    }else{
        $data{$ID}{AvgP}{TKOvsCtrl} = $AvgP;
    }

    if ($data{$ID}{FC}{TKOvsCtrl}){
    }else{
        $data{$ID}{FC}{TKOvsCtrl} = $FC;
    }
}
close DATA;

open( DATA, "< tmp.MuthIDR1vsMut.anno" ) or die "$!";
while(<DATA>){
    chomp;

    my @F = split /\s+/;
    my $ID = $F[0];
    my $AvgP = $F[1];
    my $FC = $F[2];
    
    if ($data{$ID}{AvgP}{MuthIDR1vsMut}){
    }else{
        $data{$ID}{AvgP}{MuthIDR1vsMut} = $AvgP;
    }

    if ($data{$ID}{FC}{MuthIDR1vsMut}){
    }else{
        $data{$ID}{FC}{MuthIDR1vsMut} = $FC;
    }
}
close DATA;

open( DATA, "< tmp.hIDR1vsMut.anno" ) or die "$!";
while(<DATA>){
    chomp;

    my @F = split /\s+/;
    my $ID = $F[0];
    my $AvgP = $F[1];
    my $FC = $F[2];
    
    if ($data{$ID}{AvgP}{hIDR1vsMut}){
    }else{
        $data{$ID}{AvgP}{hIDR1vsMut} = $AvgP;
    }

    if ($data{$ID}{FC}{hIDR1vsMut}){
    }else{
        $data{$ID}{FC}{hIDR1vsMut} = $FC;
    }
}
close DATA;

open( DATA, "< tmp.MutvsCtrl.anno" ) or die "$!";
while(<DATA>){
    chomp;

    my @F = split /\s+/;
    my $ID = $F[0];
    my $AvgP = $F[1];
    my $FC = $F[2];
    
    if ($data{$ID}{AvgP}{MutvsCtrl}){
    }else{
        $data{$ID}{AvgP}{MutvsCtrl} = $AvgP;
    }

    if ($data{$ID}{FC}{MutvsCtrl}){
    }else{
        $data{$ID}{FC}{MutvsCtrl} = $FC;
    }
}
close DATA;

###########################################################################################
# Combining
###########################################################################################
open( OUT, ">", "MaintainingScore_annotation.txt" )or die "$!";

print OUT  "name\tPvalue\tMaintainingScore\n";

foreach my $ID (sort @Names){
    my $AvgP_TKOvsCtrl;
    my $AvgP_MuthIDR1vsMut;
    my $AvgP_MutvsCtrl;


    if ($data{$ID}{AvgP}{TKOvsCtrl}){
        $AvgP_TKOvsCtrl = $data{$ID}{AvgP}{TKOvsCtrl};       
    }else{
        $AvgP_TKOvsCtrl = 0;
    }

    if ($data{$ID}{AvgP}{MuthIDR1vsMut}){
        $AvgP_MuthIDR1vsMut = $data{$ID}{AvgP}{MuthIDR1vsMut};       
    }else{
        $AvgP_MuthIDR1vsMut = 0;
    }

    if ($data{$ID}{AvgP}{MutvsCtrl}){
        $AvgP_MutvsCtrl = $data{$ID}{AvgP}{MutvsCtrl};       
    }else{
        $AvgP_MutvsCtrl = 0;
    }

    my $FC_TKOvsCtrl;
    my $FC_MuthIDR1vsMut;
    my $FC_hIDR1vsMut;
    my $FC_MutvsCtrl;


    my $logFC_TKOvsCtrl;
    my $logFC_MuthIDR1vsMut;
    my $logFC_hIDR1vsMut;
    my $logFC_MutvsCtrl;


    if ($data{$ID}{FC}{TKOvsCtrl}){
        $FC_TKOvsCtrl = $data{$ID}{FC}{TKOvsCtrl};
    }else{
        $FC_TKOvsCtrl = 0;
    }
    if ($FC_TKOvsCtrl == 0){
        $logFC_TKOvsCtrl = 0;
    }else{
        $logFC_TKOvsCtrl = log($FC_TKOvsCtrl) / log(2);
    }

    if ($data{$ID}{FC}{MuthIDR1vsMut}){
        $FC_MuthIDR1vsMut = $data{$ID}{FC}{MuthIDR1vsMut};       
    }else{
        $FC_MuthIDR1vsMut = 0;
    }
    if ($FC_MuthIDR1vsMut == 0){
        $logFC_MuthIDR1vsMut = 0;
    }else{
        $logFC_MuthIDR1vsMut = log($FC_MuthIDR1vsMut) / log(2);
    }

    if ($data{$ID}{FC}{hIDR1vsMut}){
        $FC_hIDR1vsMut = $data{$ID}{FC}{hIDR1vsMut};       
    }else{
        $FC_hIDR1vsMut = 0;
    }
    if ($FC_hIDR1vsMut == 0){
        $logFC_hIDR1vsMut = 0;
    }else{
        $logFC_hIDR1vsMut = log($FC_hIDR1vsMut) / log(2);
    }

    if ($data{$ID}{FC}{MutvsCtrl}){
        $FC_MutvsCtrl = $data{$ID}{FC}{MutvsCtrl};       
    }else{
        $FC_MutvsCtrl = 0;
    }
    if ($FC_MutvsCtrl == 0){
        $logFC_MutvsCtrl = 0;
    }else{
        $logFC_MutvsCtrl = log($FC_MutvsCtrl) / log(2);
    }

    my $Pvalue = $AvgP_MuthIDR1vsMut;

    my $MaintainingScore;
    if ($logFC_TKOvsCtrl + $logFC_MutvsCtrl == 0){
        $MaintainingScore = 0;
    }else{
        $MaintainingScore = ($logFC_MuthIDR1vsMut - $logFC_hIDR1vsMut) /  (0.5 * ($logFC_TKOvsCtrl + $logFC_MutvsCtrl));
    }

    my $logP;
  
    if ($Pvalue == 1){
        $logP = 2.5;
    }else{
        $logP = 0 - (log(1-$Pvalue)/log(10));
    }

    print OUT "$ID\t$logP\t$MaintainingScore\n";

}

close OUT;

