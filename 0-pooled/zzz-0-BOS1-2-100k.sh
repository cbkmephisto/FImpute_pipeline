#!/bin/bash

[ ! -f pooled_BOS1 ] && echo A file named pooled_BOS1 needed. && exit

xrf=/Volumes/data/m-maps/affy_ilmnhd_markers.csv
map=/Volumes/data/m-maps/map.100k

#umd30_bta,umd30_pos,axiom_id,hd_marker_name
#19,51706770,21951473,BovineHD1900014433


####### trimDown2map
# make map
afm=map.tdm.100k.affy
echo making $afm
echo "SNP_IDs umd30_chr umd30_pos" >  $afm
awk -F, 'FNR>1{print "AX-" $3, $1, $2}' $xrf >> $afm

echo trimming BOS1 to 100k.affy
SNPipeline.trimDown2Map $afm pooled_BOS1
a1a=abg_pooled_100k.affy
mv tdmout.$afm.pooled_BOS1 $a1a

####### rename SNP_IDs
echo renaming SNP_IDs by SNPipeline.mergingAB
sxr=SNPxref.100k
awk -F, 'FNR>1{print "AX-" $3, $4}' $xrf > $sxr
opt=pooled_100k
SNPipeline.mergingAB -x $sxr -o $opt -i abg_pooled_100k.affy -v

rm $sxr $afm $a1a $opt.ID2Path pooled_BOS1
