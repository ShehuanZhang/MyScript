#!/usr/bin/perl

#*****************************************************************************
# FileName: after.js.namelis2info.pl
# Creator: Zhang Shehuan <zhangshehuan@celloud.cn>
# Create Time: 2017-7-19
# Description: This code is to get info based on given namelis.
# CopyRight: Copyright (c) CelLoud, All rights reserved.
# Revision: V1.0.0
# ModifyList:
#    Revision: V1.0.1
#    Modifier: Zhanshehuan
#    ModifyTime: 2017-8-3
#    ModifyReason: debug:$temp[$i]=~/$e/ instead of $temp[$i]=~/$hash{$e}/
#*****************************************************************************

use strict;
use warnings;

if (@ARGV!=3) {
	die "\tUsage: $0 <namelis> <info> <out>\n";
	exit;
}

my $namelis=shift;
my $info=shift;
my $out=shift;

my %hash;
open IN, "$namelis" or die "Can't open '$namelis': $!";
while (my $line=<IN>) {
	#Complete TCGA ID
	#TCGA-A2-A0T2
	chomp $line;
	if ($line=~/^Complete/) {
		next;
	}else{
		#print "$line\n";
		$hash{$line}=1;
	}
}
close IN;

my (%pos,%info);
open IN, "$info" or die "Can't open '$info': $!";
while (my $line=<IN>) {
	#id      TCGA-BH-A18S-11A-43R-A12D-07    TCGA-BH-A0BS-11A-11R-A12P-07    TCGA-E9-A1RI-11A-41R-A169-07    TCGA-BH-A18L-11A-42R-A12D-07    TCGA-BH-A0AZ-11A-22R-A12P-07    TCGA-BH-A0DT-11A-12R-A12D-07    TCGA-A7-A13G-11A-51R-A13Q-07    TCGA-AC-A2FF-11A-13R-A17B-07    TCGA-BH-A0BM-11A-12R-A089-07    TCGA-E2-A1LH-11A-22R-A14D-07    TCGA-BH-A18R-11A-42R-A12D-07    TCGA-A7-A0DB-11A-33R-A089-07    TCGA-BH-A1EU-11A-23R-A137-07    TCGA-BH-A0H9-11A-22R-A466-07    TCGA-BH-A0BV-11A-31R-A089-07    TCGA-BH-A204-11A-53R-A157-07    TCGA-BH-A0BA-11A-22R-A19E-07    TCGA-A7-A0CE-11A-21R-A089-07    TCGA-BH-A0B5-11A-23R-A12P-07    TCGA-BH-A0DP-11A-12R-A089-07    TCGA-BH-A1FR-11B-42R-A13Q-07    TCGA-BH-A1F2-11A-32R-A13Q-07    TCGA-BH-A209-11A-42R-A157-07    TCGA-BH-A0DL-11A-13R-A115-07    TCGA-BH-A0DD-11A-23R-A12P-07    TCGA-BH-A1EO-11A-31R-A137-07    TCGA-E9-A1N6-11A-32R-A144-07    TCGA-BH-A1FC-11A-32R-A13Q-07    TCGA-BH-A208-11A-51R-A157-07    TCGA-BH-A1EV-11A-24R-A137-07    TCGA-BH-A0BQ-11A-33R-A115-07    TCGA-A7-A0CH-11A-32R-A089-07    TCGA-E2-A1BC-11A-32R-A12P-07    TCGA-E9-A1NF-11A-73R-A14D-07    TCGA-BH-A18K-11A-13R-A12D-07    TCGA-E2-A1LS-11A-32R-A157-07    TCGA-BH-A1F0-11B-23R-A137-07    TCGA-BH-A0H5-11A-62R-A115-07    TCGA-E2-A1LB-11A-22R-A144-07    TCGA-BH-A1FG-11B-12R-A13Q-07    TCGA-BH-A0DV-11A-22R-A12P-07    TCGA-BH-A0B3-11B-21R-A089-07    TCGA-BH-A1F8-11B-21R-A13Q-07    TCGA-BH-A0HK-11A-11R-A089-07    TCGA-A7-A13E-11A-61R-A12P-07    TCGA-BH-A18M-11A-33R-A12D-07    TCGA-E2-A153-11A-31R-A12D-07    TCGA-E9-A1ND-11A-43R-A144-07    TCGA-BH-A18V-11A-52R-A12D-07    TCGA-BH-A0BW-11A-12R-A115-07    TCGA-E9-A1N5-11A-41R-A14D-07    TCGA-BH-A1EN-11A-23R-A13Q-07    TCGA-BH-A18P-11A-43R-A12D-07    TCGA-AC-A23H-11A-12R-A157-07    TCGA-BH-A0AY-11A-23R-A089-07    TCGA-BH-A0BJ-11A-23R-A089-07    TCGA-GI-A2C8-11A-22R-A16F-07    TCGA-AC-A2FB-11A-13R-A17B-07    TCGA-E2-A15I-11A-32R-A137-07    TCGA-E9-A1N9-11A-71R-A14D-07    TCGA-E9-A1RC-11A-33R-A157-07    TCGA-A7-A0D9-11A-53R-A089-07    TCGA-BH-A1FE-11B-14R-A13Q-07    TCGA-BH-A1FD-11B-21R-A13Q-07    TCGA-BH-A1FB-11A-33R-A13Q-07    TCGA-BH-A0H7-11A-13R-A089-07    TCGA-BH-A0BZ-11A-61R-A12P-07    TCGA-E9-A1RB-11A-33R-A157-07    TCGA-AC-A2FM-11B-32R-A19W-07    TCGA-E9-A1NG-11A-52R-A14M-07    TCGA-BH-A1FN-11A-34R-A13Q-07    TCGA-BH-A0DQ-11A-12R-A089-07    TCGA-BH-A1EW-11B-33R-A137-07    TCGA-BH-A0C0-11A-21R-A089-07    TCGA-BH-A0HA-11A-31R-A12P-07    TCGA-E2-A1L7-11A-33R-A144-07    TCGA-E9-A1N4-11A-33R-A14M-07    TCGA-E9-A1NA-11A-33R-A144-07    TCGA-BH-A18J-11A-31R-A12D-07    TCGA-BH-A0DK-11A-13R-A089-07    TCGA-E9-A1R7-11A-42R-A14M-07    TCGA-BH-A1FM-11B-23R-A13Q-07    TCGA-BH-A1FU-11A-23R-A14D-07    TCGA-BH-A0BT-11A-21R-A12P-07    TCGA-BH-A0C3-11A-23R-A12P-07    TCGA-E9-A1RH-11A-34R-A169-07    TCGA-BH-A0AU-11A-11R-A12P-07    TCGA-GI-A2C9-11A-22R-A21T-07    TCGA-BH-A0B8-11A-41R-A089-07    TCGA-A7-A0DC-11A-41R-A089-07    TCGA-BH-A0DO-11A-22R-A12D-07    TCGA-E9-A1RD-11A-33R-A157-07    TCGA-E9-A1RF-11A-32R-A157-07    TCGA-BH-A18Q-11A-34R-A12D-07    TCGA-BH-A1FH-11B-42R-A13Q-07    TCGA-BH-A0DH-11A-31R-A089-07    TCGA-BH-A0DG-11A-43R-A12P-07    TCGA-E2-A15M-11A-22R-A12D-07    TCGA-A7-A13F-11A-42R-A12P-07    TCGA-BH-A0DZ-11A-22R-A089-07    TCGA-BH-A1FJ-11B-42R-A13Q-07    TCGA-BH-A0B7-11A-34R-A115-07    TCGA-BH-A0BC-11A-22R-A089-07    TCGA-E2-A158-11A-22R-A12D-07    TCGA-BH-A1ET-11B-23R-A137-07    TCGA-BH-A0E1-11A-13R-A089-07    TCGA-BH-A0E0-11A-13R-A089-07    TCGA-BH-A18U-11A-23R-A12D-07    TCGA-E2-A15K-11A-13R-A12P-07    TCGA-E2-A1IG-11A-22R-A144-07    TCGA-BH-A203-11A-42R-A169-07    TCGA-BH-A1F6-11B-94R-A13Q-07    TCGA-BH-A18N-11A-43R-A12D-07    TCGA-D8-A1XD-01A-11R-A14D-07    TCGA-B6-A0X5-01A-21R-A109-07    TCGA-D8-A27P-01A-11R-A16F-07    TCGA-AR-A0TP-01A-11R-A084-07    TCGA-D8-A27I-01A-11R-A16F-07    TCGA-BH-A1ET-01A-11R-A137-07    TCGA-AN-A049-01A-21R-A00Z-07    TCGA-BH-A5J0-01A-11R-A27Q-07    TCGA-PE-A5DC-01A-12R-A27Q-07    TCGA-D8-A1X6-01A-11R-A14M-07    TCGA-AR-A250-01A-31R-A169-07    TCGA-A2-A0CX-01A-21R-A00Z-07    TCGA-E2-A1IH-01A-11R-A13Q-07    TCGA-A8-A086-01A-11R-A00Z-07    TCGA-S3-AA14-01A-11R-A41B-07    TCGA-AO-A0JL-01A-11R-A056-07    TCGA-D8-A27K-01A-11R-A16F-07    TCGA-A8-A076-01A-21R-A00Z-07    TCGA-A1-A0SI-01A-11R-A144-07    TCGA-AN-A0FW-01A-11R-A034-07    TCGA-BH-A0E2-01A-11R-A056-07    TCGA-C8-A275-01A-21R-A16F-07    TCGA-C8-A12T-01A-11R-A115-07    TCGA-OL-A5RU-01A-11R-A28M-07    TCGA-AC-A6IX-01A-12R-A32P-07    TCGA-E2-A155-01A-11R-A12D-07    TCGA-D8-A27M-01A-11R-A16F-07    TCGA-AR-A1AN-01A-11R-A12P-07    TCG
	#TRPM4|ENSG00000130529|protein_coding    2487    2764    483     2331    3073    3213    653     3634    2248    3337    2463    981     1120    1342    5680    1010    1756    3855    937     3915    1898    2155    1632    3465    1374    1706    2197    1307    2923    1948    2349    3388    407     1310    1699    739     2367    2934    3242    542     3334    2543    1516    2552    1071    1840    3841    2510    2668    2093    2098    2188    1306    1664    2187    3284    1039    2402    400     4740    1647    823     1189    1345    1861    2894    2253    1064    3385    1144    1689    4185    3209    3623    2925    3147    5638    2570    1713    5343    1205    2279    1837    2395    2056    1098    3172    2652    1069    2082    3177    2090    722     2693    1822    1784    3288    1527    1731    4018    1262    2573    2200    893     3288    2551    3811    1860    2841    1500    1544    1662    3567    10293   2756    4481    1471    3372    5166    3366    6287    2172    2315    10128   3167    2586    2467    5554    1706    5178    4818    6149    5614    4411    3781    7486    8601    4545    7105    1914    2459    6183    5396    1226    2287    4907    3019    6813    5584    1888    5284    5297    1176    2881    4066    5560    3348    1615    788     2221    1502    2301    4563    7230    3635    1933    3032    4859    7142    2400    10242   5043    1868    2418    3062    2558    1698    3196    1880    5096    6492    200     5051    1610    3571    4883    3958    4214    2781    3098    1903    2726    8177    3842    2528    5995    6293    1983    5776    3254    4952    2947    4684    1311    974     3250    4386    4805    4348    2208    1236    6936    8801    2211    5654    430     1821    3331    1384    4761    9396    4420    4787    3317    2968    8945    4247    2222    4960    1749    2827    3193    3640    1913    3469    1189    11580   3934    10998   3882    6165    4314    1550    1321    3925    4775    5953    4484    10371   3958    1469    297     3587    2491    800     4334    3675    2361    6548    3172    3974    4473    2964    2035    1640    4550    1121    902     3417    1730    1360    5375    866     2046    1530    4222    5934    2287    1190    4191    308     490     2931    2469    2325    2843    2205    7269    2058    1696    4804    9555    3319    5250    4289    3678    5197    3178    4079    1737    5617    5618    2681    570     1295    6361    8007    2495    1737    643     1096    3288    6008    8227    2702    5962    753     1415    3042    3161    604     6541    3445    3667    2237    3352    1863    2271    4873    5574    5380    3183    6237    2459    5253    8165    2022    4787    7403    3203    6197    7494    8518    1936    2852    1906    8212    7785    6799    2068    1973    3477    18423   1935    2310    3165    2965    3817    1703    4475    4696    1900    3844    3119    1717    6244    2763    4748    2942    3155    1983    2393    4149    10245   4244    7599    17381   4342    3616    3477    1507    3538    11190   3131    3616    2898    8484    1956    3958    5866    2631    2689    3940    2555    4491    6906    1429    5786    2319    1874    5878    863     4232    8335    2750    1870    2898    608     3590    3068    1172    2893    7405    2739    1641    6109    1351    6196    2079    3292    681     3534    4182    1906    2106    3755    6142    2015    2498    7049    7240    4130    5314    1775    3472    2301    9940    1968    7733    11581   2714    3898    2731    4462    3160    1042    3900    2837    7867    3056    3870    3930    6287    4547    4986    1940    2473    5064    1971    3189    9183    2574    6062    4781    10751   4041    5325    2019    2067    5242    3155    3435    7281    6583    2592    3741    3369    2031    1361    5041    3514    3578    722     7554    4053    6378    3186    3625    1862    3397    4502    5709    1075    8932    4104    6820    3040    5588    1750    5964    2665    1175    2158    5266    5157    2710    7332    7082    3287    1975    4794    5695    2264    5504    966     2465    3417    3149    2736    1903    7811    2904    3520    5571    2241    4208    3517    6431    7547    12294   2703    2678    3304    2867    9901    2082    3678    3072    931     1874    6686    3014    3587    2782    2724    3425    10341   7411    2011    2963    1424    7156    4719    3550    3171    7504    1189    4749    1855    5213    3914    5477    992     5633    1487    5111    2421    1824    4217    3887    5047    1928    3807    3970    8473    4324    3321    3174    2634    2264    3346    3820    4911    1552    1715    4063    1531    5570    4588    843     4001    4555    2783    3009    9111    5277    1751    4318    6645    6096    2045    4780    8049    1767    4773    2165    9720    2972    2010    5784    3180    11091   3901    2119    6133    2474    11450   3859    4872    2792    3782    6626    7563    5400    1838    2091    2112    1767    7884    1629    2701    7493    8456    881     4835    3171    1837    3216    1461    3734    4493    860     2752    1421    2115    2966    3361    3344    7664    7388    6439    3050    4034    6796    7518    3698    804     6093    5268    4253    5541    1328    2822    5653    8619    7336    3596    3108    2111    2923    5313    3432    3510    4011    8100    5805    1125    3025    8266    5848    2359    3488    1698    2661    4728    5600    4301    1519    2166    1453    3172    4330    1436    1676    1681    3081    2314    4079    4219    786     7107    3728    6333    1385    2661    3551    7209    6519    1415    7218    1358    3863    7689    1514    1994    3771    23574   4387    3661    5179    2819    1223    6297    886     5999    3099    1527    1331    3376    3030    6370    3585    4957    2656    5808    2470    4554    11758   5377    4497    4222    4697    1654    5229    2934    850     1061    5148    4142    3819    2955    687     1786    4590    1895    2311    5561    3535    4577    1067    4145    5726    4144    2721    1572    3893    3862    3020    2624    2186    3464    7641    4833    3034    1788    2951    910     10400   1715    4197    2838    3766    1581    1269    2691    5537    2900    4989    6840    1324    4202    115     3223    10844   3938    1113    4687    2678    758     1248    3327    1206    1027    1154    4713    5632    4611    6545    3414    2630    9508    2365    1212    1484    753     5862    18
	my @temp=split/\s+/,$line;
	if ($line=~/^id/) {
		foreach my $i (0..$#temp) {
			#print "$i\t";
			foreach my $e (keys %hash) {
				if ($temp[$i]=~/$e/) {
					$pos{$temp[$i]}=$i;
					#print "$temp[$i]=~/$e/\n";
					last;
				}
			}
		}
	}else {
		foreach my $item (keys %pos) {
			$info{$temp[0]}{$item}=$temp[$pos{$item}];
		}
	}
}
close IN;
my @arr=keys %pos;
open OUT, ">$out" or die "Can't open '$out': $!";
print OUT "id\t".join("\t",@arr)."\n";
foreach my $item (keys %info) {
	print OUT "$item\t";
	foreach my $entry (@arr) {
		print OUT "$info{$item}{$entry}\t";
	}
	print OUT "\n";
}
close OUT;

