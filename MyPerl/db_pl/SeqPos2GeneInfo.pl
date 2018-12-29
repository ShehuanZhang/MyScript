#!/usr/bin/perl

#*****************************************************************************
# FileName: SeqPos2GeneInfo.pl
# Creator: Zhang Shehuan
# Description: This code is to get gene info from given position of certain RefSeq.
# Create Time: 2018-12-24
# CopyRight: Copyright (c) Zhang Shehuan.
# Revision: V1.0
#*****************************************************************************
use strict;
use warnings;
use File::Basename qw(basename dirname);
use Encode;
use utf8;

if (@ARGV!=3) {
	die "\tUsage: $0 <poslis> <refGene.txt> <out>\n";
}
my $poslis=shift;
my $refGene=shift;
my $out=shift;

my (%pos);
open IN,"$poslis" || die "Can't open '$poslis': $!\n";
while (my $line=<IN>) {
	#2	29432682	29432682
	if ($line=~/^\s+$/ or $line=~/^chrom/) {
		next;
	}
	chomp $line;
	my ($chr,$begin,$end)=(split/\s+/,$line)[0,1,2];
	$chr=~s/^chr//;
	$pos{$chr}{$begin}=1;
	$pos{$chr}{$end}=1;
}
close IN;


my %geneInfo;
open IN,"$refGene" || die "Can't open '$refGene': $!\n";
while (my $line=<IN>) {
	#125     NM_005228       chr7    +       55086713        55275773        55086970        55273310        28      55086713,55209978,55210997,55214298,55218986,55220238,55221703,55223522,55224225,55224451,55225355,55227831,55229191,55231425,55232972,55238867,55240675,55241613,55242414,55248985,55259411,55260458,55266409,55268008,55268880,55269427,55270209,55272948,    55087058,55210130,55211181,55214433,55219055,55220357,55221845,55223639,55224352,55224525,55225446,55228031,55229324,55231516,55233130,55238906,55240817,55241736,55242513,55249171,55259567,55260534,55266556,55268106,55269048,55269475,55270318,55275773,    0       EGFR    cmpl    cmpl    0,1,0,1,1,1,0,1,1,2,1,2,1,2,0,2,2,0,0,0,0,0,1,1,0,0,0,1,
	chomp $line;
	my ($refseq,$chr,$strand,$start,$stop,$exonStart,$exonStop,$gene)=(split/\s+/,$line)[1..5,9,10,12];
	$refseq=~s/\.\d+$//;
	$chr=~s/^chr//;
	if (exists $pos{$chr}) {
		foreach my $site (keys %{$pos{$chr}}) {
			if ($start<=$site && $site<=$stop) {
				my @origin_starts=split/,/,$exonStart;
				my @origin_stops=split/,/,$exonStop;
				my @starts=@origin_starts;
				my @stops=@origin_stops;
				if ($strand eq "-") {
					@starts=@origin_stops;
					@stops=@origin_starts;
					@starts=reverse @starts;
					@stops=reverse @stops;
				}
				foreach my $i (0..$#starts) {
					if (($starts[$i]<=$site && $site<=$stops[$i]) || ($stops[$i]<=$site && $site<=$starts[$i])) {
						my $extronNUM=$i+1;
						$geneInfo{$chr}{$site}="$refseq:$strand:$gene:Extron$extronNUM,";
						last;
					}
					#if ($i==$#starts) {
					#	last;
					#}
					if (($stops[$i]<=$site && $site<=$starts[$i+1]) || ($starts[$i+1]<=$site && $site<=$stops[$i])) {
						my $intronNUM=$i+1;
						$geneInfo{$chr}{$site}="$refseq:$strand:$gene:Intron$intronNUM,";
						last;
					}
				}
			}
		}
	}
}
close IN;


open OUT,">$out" or die "Can't open '$out': $!\n";
open IN,"$poslis" || die "Can't open '$poslis': $!\n";
while (my $line=<IN>) {
	#2	29432682	29432682
	if ($line=~/^\s+$/ or $line=~/^chrom/) {
		next;
	}
	chomp $line;
	my ($chr,$begin,$end)=(split/\s+/,$line)[0,1,2];
	$chr=~s/^chr//;
	my $beginInfo="NULL";
	my $endInfo="NULL";
	if (exists $geneInfo{$chr}{$begin}) {
		$beginInfo=$geneInfo{$chr}{$begin};
		$beginInfo=~s/,$//;
	}
	if (exists $geneInfo{$chr}{$end}) {
		$endInfo=$geneInfo{$chr}{$end};
		$endInfo=~s/,$//;
	}
	print OUT "$line\t$beginInfo\t$endInfo\n";
}
close IN;
close OUT;
