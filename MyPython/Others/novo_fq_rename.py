import re,sys,glob,os

def rename_fq(fq_dir,target_dir="./"):
	fq_dir = os.path.abspath(fq_dir)
	target_dir = os.path.abspath(target_dir)
	for i in glob.glob(os.path.join(fq_dir,"*.fq.gz")):	
		rd,l,r=re.search("(RD\d+|PM\d+).*_L(\d+)_(\d+).fq.gz",os.path.split(i)[1]).groups()
		new_name="{0}_S4_L{1:0>3}_R{2}_001.fastq.gz".format(rd,l,r)
		if not os.path.isdir(target_dir):
			os.makedirs(target_dir)
		link_name = os.path.join(target_dir,new_name)
		new_link_name = os.path.join(target_dir,new_name)
		os.symlink(i,link_name)
		os.rename(link_name,new_link_name)
		print i+" was linked and renamed as "+new_link_name 	

if len(sys.argv) == 2:
	rename_fq(sys.argv[1])
elif len(sys.argv) == 3:
	rename_fq(sys.argv[1],sys.argv[2])
else:
	print "python novo_fq_rename.py <novofastq_dir> <target_dir>"


