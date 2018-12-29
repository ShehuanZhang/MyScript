#!/usr/bin/perl

#*****************************************************************************
# FileName: addTransID2gene.pl
# Creator: Zhang Shehuan
# Description: This code is to add transcriptID to given gene.
# Create Time: 2018-12-27
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

my (%hash);
open IN,"$poslis" || die "Can't open '$poslis': $!\n";
while (my $line=<IN>) {
	#chr1    12080   12251   172     chr1:12080-12251        0.494186        0       0       0       0       0       0       1       0       NULL:DDX11L1:1  1
	if ($line=~/^\s+$/ or $line=~/^chrom/) {
		next;
	}
	chomp $line;
	my ($chr,$info)=(split/\s+/,$line)[0,-2];
	$chr=~s/^chr//;
	if ($info=~/^NULL/) {
		my $gene=(split/:/,$info)[1];
		if ($gene ne ".") {
			$hash{$gene}=$chr;
		}
	}
}
close IN;


my (%transOnly);
open IN,"$refGene" || die "Can't open '$refGene': $!\n";
while (my $line=<IN>) {
	#125     NM_005228       chr7    +       55086713        55275773        55086970        55273310        28      55086713,55209978,55210997,55214298,55218986,55220238,55221703,55223522,55224225,55224451,55225355,55227831,55229191,55231425,55232972,55238867,55240675,55241613,55242414,55248985,55259411,55260458,55266409,55268008,55268880,55269427,55270209,55272948,    55087058,55210130,55211181,55214433,55219055,55220357,55221845,55223639,55224352,55224525,55225446,55228031,55229324,55231516,55233130,55238906,55240817,55241736,55242513,55249171,55259567,55260534,55266556,55268106,55269048,55269475,55270318,55275773,    0       EGFR    cmpl    cmpl    0,1,0,1,1,1,0,1,1,2,1,2,1,2,0,2,2,0,0,0,0,0,1,1,0,0,0,1,
	chomp $line;
	my ($refseq,$chr,$strand,$start,$stop,$exonStart,$exonStop,$gene)=(split/\s+/,$line)[1..5,9,10,12];
	$refseq=~s/\.\d+$//;
	$chr=~s/^chr//;
	if (exists $hash{$gene} && $hash{$gene} eq $chr) {
		if (exists $transOnly{$gene} && $transOnly{$gene}!~/$refseq/) {
			$transOnly{$gene}.="$refseq,";
		}else {
			$transOnly{$gene}="$refseq,";
		}
	}
}
close IN;


open OUT,">$out" or die "Can't open '$out': $!\n";
open OUT2,">$out.2" or die "Can't open '$out.2': $!\n";
open IN,"$poslis" || die "Can't open '$poslis': $!\n";
while (my $line=<IN>) {
	#chr1    12080   12251   172     chr1:12080-12251        0.494186        0       0       0       0       0       0       1       0       NULL:DDX11L1:1  1
	if ($line=~/^\s+$/ or $line=~/^chrom/) {
		next;
	}
	chomp $line;
	my @temp=split/\s+/,$line;
	my $info=$temp[-2];
	if ($info=~/^NULL/ && $info!~/:\.:/) {
		my ($trans,$gene,$ratio)=(split/:/,$info)[0,1,2];
		if (exists $transOnly{$gene}) {
			$trans=$transOnly{$gene};
			$trans=~s/,$//;
		}
		$info="$trans:$gene:$ratio";
		$temp[-2]=$info;
		if ($info=~/^NULL/ && $info!~/:\.:/) {
			print OUT2 (join "\t",@temp)."\n";
		}
	}
	print OUT (join "\t",@temp)."\n";
}
close IN;
close OUT;

=cut
#!/usr/bin/perl

#*****************************************************************************
# FileName: addTransID2gene.pl
# Creator: Zhang Shehuan
# Description: This code is to add transcriptID to given gene.
# Create Time: 2018-12-27
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

my (%hash);
open IN,"$poslis" || die "Can't open '$poslis': $!\n";
while (my $line=<IN>) {
	#chr1    12080   12251   172     chr1:12080-12251        0.494186        0       0       0       0       0       0       1       0       NULL:DDX11L1:1  1
	if ($line=~/^\s+$/ or $line=~/^chrom/) {
		next;
	}
	chomp $line;
	my $info=(split/\s+/,$line)[-2];
	if ($info=~/^NULL/) {
		my $gene=(split/:/,$info)[1];
		if ($gene ne ".") {
			$hash{$gene}=0;
		}
	}
}
close IN;


my (%transOnly);
open IN,"$refGene" || die "Can't open '$refGene': $!\n";
while (my $line=<IN>) {
	#125     NM_005228       chr7    +       55086713        55275773        55086970        55273310        28      55086713,55209978,55210997,55214298,55218986,55220238,55221703,55223522,55224225,55224451,55225355,55227831,55229191,55231425,55232972,55238867,55240675,55241613,55242414,55248985,55259411,55260458,55266409,55268008,55268880,55269427,55270209,55272948,    55087058,55210130,55211181,55214433,55219055,55220357,55221845,55223639,55224352,55224525,55225446,55228031,55229324,55231516,55233130,55238906,55240817,55241736,55242513,55249171,55259567,55260534,55266556,55268106,55269048,55269475,55270318,55275773,    0       EGFR    cmpl    cmpl    0,1,0,1,1,1,0,1,1,2,1,2,1,2,0,2,2,0,0,0,0,0,1,1,0,0,0,1,
	chomp $line;
	my ($refseq,$chr,$strand,$start,$stop,$exonStart,$exonStop,$gene)=(split/\s+/,$line)[1..5,9,10,12];
	$refseq=~s/\.\d+$//;
	$chr=~s/^chr//;
	if (exists $hash{$gene}) {
		if (exists $transOnly{$gene} && $transOnly{$gene}!~/$refseq/) {
			$transOnly{$gene}.="$refseq,";
			$hash{$gene}++;
		}else {
			$transOnly{$gene}="$refseq,";
			$hash{$gene}++;
		}
	}
}
close IN;


open OUT,">$out" or die "Can't open '$out': $!\n";
open OUT2,">$out.2" or die "Can't open '$out.2': $!\n";
open IN,"$poslis" || die "Can't open '$poslis': $!\n";
while (my $line=<IN>) {
	#chr1    12080   12251   172     chr1:12080-12251        0.494186        0       0       0       0       0       0       1       0       NULL:DDX11L1:1  1
	if ($line=~/^\s+$/ or $line=~/^chrom/) {
		next;
	}
	chomp $line;
	my @temp=split/\s+/,$line;
	my $info=$temp[-2];
	if ($info=~/^NULL/ && $info!~/:\.:/) {
		my ($trans,$gene,$ratio)=(split/:/,$info)[0,1,2];
		if (exists $transOnly{$gene}) {
			$trans=$transOnly{$gene};
			$trans=~s/,$//;
		}
		$info="$trans:$gene:$ratio";
		$temp[-2]=$info;
		if ($info=~/^NULL/ && $info!~/:\.:/) {
			print OUT2 (join "\t",@temp)."\n";
		}
	}
	print OUT (join "\t",@temp)."\n";
}
close IN;
close OUT;
