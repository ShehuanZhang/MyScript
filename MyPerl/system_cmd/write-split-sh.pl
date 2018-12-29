#!/usr/bin/perl

#*****************************************************************************
# FileName: write-split-sh.pl
# Creator: Zhang Shehuan
# Description: This code is write split shell file.
# Create Time: 2018-12-28
# CopyRight: Copyright (c) Zhang Shehuan.
# Revision: V1.0
#*****************************************************************************
use strict;
use warnings;
use File::Basename qw(basename dirname);
use Cwd 'abs_path';
use Encode;
use utf8;

if (@ARGV!=2) {
	die "\tUsage: $0 <datalis> <out>\n";
}
my $datalis=shift;
my $out=shift;
unless (-d $out) {
	system "mkdir $out";
}
$out=abs_path $out;
$datalis=abs_path $datalis;

open IN,"$datalis" || die "Can't open '$datalis': $!\n";
while (my $line=<IN>) {
	#/gpfs/share/nextseq500data/nextseqcn500data-01/181207_NB501130_0226_AHGLWTBGX9	/gpfs/home/zhangshehuan/RunOut/QCreport/20181207-SampleSheet.csv
	chomp $line;
	my ($data,$sheet)=(split/\s+/,$line)[0,1];
	$data=abs_path $data;
	$sheet=abs_path $sheet;
	my $name=basename $data;
	my $fq_out="$out/$name\_fq";
	unless (-d $fq_out) {
		system "mkdir $fq_out";
	}
	open OUT,">$out/$name.sh" or die "Can't open '$out/$name.sh': $!\n";
	my $cmd="DATAPATH=$data\n"
			."bcl2fastq --barcode-mismatches 0 -R \$DATAPATH -o $fq_out "
			."--sample-sheet $sheet 2>$out/$name.log\n";
	print OUT $cmd;
	close OUT;
}
close IN;
