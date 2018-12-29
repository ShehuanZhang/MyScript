#!/usr/bin/perl

#*****************************************************************************
# FileName: SeqPos2GeneInfo.pl
# Creator: Zhang Shehuan
# Description: This code is to get gene info from given position of certain RefSeq.
# Create Time: 2018-12-26
# CopyRight: Copyright (c) Zhang Shehuan.
# Revision: V3.0
#*****************************************************************************
use strict;
use warnings;
use File::Basename qw(basename dirname);
use Encode;
use utf8;

if (@ARGV!=4) {
	die "\tUsage: $0 <poslis> <transcript> <anno.bed> <out>\n";
}
my $poslis=shift;
my $transcript=shift;
my $annoBED=shift;
my $out=shift;

my (%pos);
open IN,"$poslis" || die "Can't open '$poslis': $!\n";
while (my $line=<IN>) {
	#chr2	29432682	29432682
	if ($line=~/^\s+$/ or $line=~/^chrom/) {
		next;
	}
	chomp $line;
	my ($chr,$begin,$end)=(split/\s+/,$line)[0,1,2];
	$chr=~s/^chr//;
	if ($begin>$end) {
		($begin,$end)=($end,$begin);
	}
	my $siteInfo="$begin\t$end";
	my $len=abs ($end-$begin)+1;
	$pos{$chr}{$siteInfo}=$len;
}
close IN;


my (%trans);
open IN,"$transcript" || die "Can't open '$transcript': $!\n";
while (my $line=<IN>) {
	#Gene_symbol     primary_transcript.refseqID
	#YWHAG   NM_012479.3
	if ($line=~/^\s+$/ or $line=~/^Gene_symbol/) {
		next;
	}
	chomp $line;
	my ($gene,$refseq)=(split/\s+/,$line)[0,1];
	$refseq=~s/\.\d+$//;
	$trans{$gene}=$refseq;
}
close IN;


my (%geneOnly);
open IN,"$annoBED" || die "Can't open '$annoBED': $!\n";
while (my $line=<IN>) {
	#chr1    12080   12251   DDX11L1
	chomp $line;
	my ($chr,$start,$stop,$gene)=(split/\s+/,$line)[0..3];
	my $refseq="NULL";
	if (exists $trans{$gene}) {
		$refseq=$trans{$gene};
	}
	$chr=~s/^chr//;
	if (exists $pos{$chr}) {
		foreach my $site (keys %{$pos{$chr}}) {
			my ($siteBegin,$siteEnd)=(split/\t/,$site)[0,1];
			my $overlap=0;
			if ($siteBegin<=$start && $start<$siteEnd && $siteEnd<=$stop) {
				$overlap=abs($siteEnd-$start)+1;
			}elsif ($start<=$siteBegin && $siteEnd<=$stop) {
				$overlap=abs($siteEnd-$siteBegin)+1;
			}elsif ($start<$siteBegin && $siteBegin<=$stop && $stop<=$siteEnd) {
				$overlap=abs($stop-$siteBegin)+1;
			}
			my $ratio=$overlap/$pos{$chr}{$site};
			if ($ratio>0) {
				if (!exists $geneOnly{"$chr\t$site"}) {
					$geneOnly{"$chr\t$site"}="$refseq:$gene:$ratio,";
				}elsif ($geneOnly{"$chr\t$site"}!~/$gene/) {
					$geneOnly{"$chr\t$site"}.="$refseq:$gene:$ratio,";
				}elsif ($geneOnly{"$chr\t$site"}=~/$gene:(\d+.\d+),/) {
					my $p=$ratio+$1;
					$geneOnly{"$chr\t$site"}=~s/^(.*)$gene:\d+.\d+,(.*)$/$1$gene:$p,$2/;
				}
			}
		}
	}
}
close IN;


open OUT,">$out" or die "Can't open '$out': $!\n";
open OUT2,">$out.2" or die "Can't open '$out.2': $!\n";
open IN,"$poslis" || die "Can't open '$poslis': $!\n";
while (my $line=<IN>) {
	#2	29432682	29432682
	if ($line=~/^\s+$/ or $line=~/^chrom/) {
		next;
	}
	chomp $line;
	my ($chr,$begin,$end)=(split/\s+/,$line)[0,1,2];
	$chr=~s/^chr//;
	if ($begin>$end) {
		($begin,$end)=($end,$begin);
	}
	my $info="NULL";
	my $geneSum=0;
	if (exists $geneOnly{"$chr\t$begin\t$end"}) {
		$info=$geneOnly{"$chr\t$begin\t$end"};
		$info=~s/,$//;
		my @genes=split/,/,$info;
		$geneSum=@genes;
	}
	print OUT "$line\t$info\t$geneSum\n";
	if ($geneSum>=2) {
		print OUT2 "$line\t$info\t$geneSum\n";
	}
}
close IN;
close OUT;
