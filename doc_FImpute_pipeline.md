# Imputation Pipeline using [FImpute][5932b779] and [SNPipeline](https://github.com/cbkmephisto/SNPipeline)

Hailin Su (hailins@iastate.edu), 225A Kildee, IASTATE, Ames, IA

Created some times ago, recent updated [Mon Nov 14 16:22:43 CST 2016]

## <font color=blue>Folder Structure Requirement</font>
    0-pooled                                 stores the output AB-Genotype files from the SNPipeline
    0-pooled/zzz-0-BOS1-2-100k.sh            used to convert AffyBOS1(600k) ABG file to Illumina 100k
    1-maps                                   stores the map file
    1-maps/zzz-0-map-maps.sh                 used to link neccessary map files according to pooled_ABG files

    xxx-func3-split-by-chip-breed.sh
    zzz-1-get_pooled_info_count_breed.sh
    zzz-2-get_SNP_IDs.sh
    zzz-3-split-by-chip-breed_MULTICORE.sh
    zzz-4-get-sample-IDs.sh
    zzz-5-excluding.sh
    zzz-6-trimDownGenotypes.sh
    zzz-7-abg2FImpute.sh
    zzz-8-FImputeMac.sh
    zzz-9-free-space-after-FImpute.sh
    zzz-a-fout2abg.sh
    zzz-b-fout2haplotype.sh
    zzz-c-zip-imputed.sh
    zzz-z-23456.sh

## <font color=blue>Executable/Binary Requirement</font>
- SNPipeline
    - SNPipeline.trimDown2Map
    - SNPipeline.mergingAB
    - SNPipeline.abgExcl
- libHailins
    - ggrep
    - mapUniter
    - testInRefCounter
    - abg2FImpute
    - fout2abg
    - fout2haplotype
    - abg2bin
    - binaryGenotypeFileIndexer
- shell script
    - waitMulti.sh
- [FImputeMac][5932b779]

  [5932b779]: http://www.aps.uoguelph.ca/%7Emsargol/fimpute/ "FImpute"

## <font color=blue>Preparations</font>

### 0. make links to pooled_$CHIP to 0-pooled/

#### <font color=green>Requires</font>

 - pooled AB-Genotype file from the SNPipeline

#### <font color=purple>Example</font>

```
$ ln -sf /Volumes/data/genotypes/pooled_ABG_20150114/pooled_* 0-pooled/
$ ls 0-pooled
pooled_50k pooled_9k pooled_GGPHD pooled_HD pooled_SuperLD zzz-0-BOS1-2-100k.sh
```

#### <font color=orange>Result</font>

- pooled AB genotype files exist in 0-pooled

### 1. If pooled_BOS1 exists, cd into 0-pooled and run zzz-0-BOS1-2-100k.sh to convert it to pooled_100k

####  <font color=green>Requires</font>

 - xref file of BOS1 to 100k [/Volumes/data/m-maps/affy_ilmnhd_markers.csv]
 - map file for 100k [/Volumes/data/m-maps/map.100k]
 - SNPipeline.trimDown2Map
 - SNPipeline.mergingAB

####  <font color=purple>Example</font>

```
$ cd 0-pooled
$ ./zzz-0-BOS1-2-100k.sh
making map.tdm.100k.affy
trimming BOS1 to 100k.affy
renaming SNP_IDs by SNPipeline.mergingAB                              
 + 10:34:16 | Parameters parsed.
 + 10:34:16 |   - [Output file Name ] :  pooled_100k
 + 10:34:16 |   - [SNPxref file Name] :  SNPxref.100k
 + 10:34:16 |   - [Input files list ] :
 + 10:34:16 |     - abg_pooled_100k.affy
 + 10:34:16 | Reading the SNPxref File
 + 10:34:16 | Reading input files to check SNP_IDs and duplicated sample IDs
 + 10:34:16 |   - reading abg_pooled_100k.affy
 + 10:34:17 | Start merging                                           
 + 10:34:17 |   - Writing out the headerLine (#SNP_IDs#)
 + 10:34:17 |   - Entering inputFileName loop
 + 10:34:17 |     - Processing abg_pooled_100k.affy
 + 10:34:17 | Done.
$ cd ..
```

#### <font color=orange>Result</font>

- pooled_100k generated
- pooled_BOS1 deleted

### 2. Link map files according to pooled AB-Genotype files

####  <font color=green>Requires</font>

 - 0-pooled/pooled-ABG-files
 - map files according to 0-pooled/ABG files [/Volumes/data/m-maps/map.\*]

#### <font color=purple>Example</font>

```
$ cd 1-maps
$ ./zzz-0-map-maps.sh
linking map file for ../0-pooled/pooled_100k
linking map file for ../0-pooled/pooled_50k
linking map file for ../0-pooled/pooled_9k
linking map file for ../0-pooled/pooled_GGPHD
linking map file for ../0-pooled/pooled_HD
linking map file for ../0-pooled/pooled_SuperLD
$ cd ..
```

#### <font color=orange>Result</font>

- map files exist in 1-maps

## <font color=blue>Going through the Pipeline</font>

### [OPTIONAL] zzz-1-get_pooled_info_count_breed.sh
generates rrr-1-breed-population

#### <font color=purple>Example</font>

```
# ======= 0-pooled/pooled_100k =======
 415 GVH
 476 HER
 461 LIM
1602 SIM
# ======= 0-pooled/pooled_SuperLD =======
1253 AAN
 888 GVH
2959 HER
 730 LIM
3082 RAN
8635 SIM
```

### zzz-2-get_SNP_IDs.sh

#### <font color=green>Requires</font>

 - ggrep
 - waitMulti.sh
 - mapUniter

#### <font color=orange>Result</font>

- rrr-2-SNP_IDs-$CHIP generated: all SNP_IDs from pooled file, used for trim-down
- 1-maps/snp_info.txt generated: [FImpute][5932b779] map input file, also used to trim-down ABG files
- valid new map files extracted from snp_info.txt (si.map.\*) generated

### zzz-3-split-by-chip-breed_MULTICORE.sh

#### <font color=green>Requires</font>

 - xxx-func3-split-by-chip-breed.sh
 - waitMulti.sh

#### <font color=red>TODO</font>

 - modify the shell script code to specify the breeds needed to be imputed, defaults are
 >BRG AAN HER LIM SIM RAN GVH CHA BSH RDP NEL
 - modify the shell script code to specify the number of jobs for waitMulti.sh parallel computing, default is
 >4

#### <font color=orange>Result</font>

- directories job.$breed generated

### zzz-4-get-sample-IDs.sh

#### <font color=green>Requires</font>

 - testInRefCounter
 - waitMulti.sh


#### <font color=red>TODO</font>

 - modify the shell script code to specify the number of jobs for waitMulti.sh parallel computing, default is
 >6

#### <font color=orange>Result</font>

- job.$breed/IDs.$chip.IDs generated, used for excluding duplicated animal IDs from lower density ABG file(s)

### zzz-5-excluding.sh
excludes animalIDs in the lower density panels that are in common with higher density ones

#### <font color=green>Requires</font>

 - testInRefCounter
 - waitMulti.sh
 - SNPipeline.abgExcl

#### <font color=red>TODO</font>

 - modify the shell script code to specify the chip array, ordered from higher density to lower ones, default is
 >vecChips=(HD 100k GGPHD 50k SuperLD 9k)
 - modify the excluding strategy, so that not all the lower density SNPs were dropped

#### <font color=orange>Result</font>

- job.$breed/pooled\_${lower}\_$breed.nodup generated, used for trimming down SNPs according to snp_info.txt map file

### zzz-6-trimDownGenotypes.sh
trims genotype files according to si.map.* to make them in consistent with snp_info.txt

#### <font color=green>Requires</font>

 - SNPipeline.trimDown2Map
 - waitMulti.sh

#### <font color=red>TODO</font>

 - modify the shell script code to specify the chip array, ordered from higher density to lower ones, default is
 >vecChips=(HD 100k GGPHD 50k SuperLD 9k)
 - modify the excluding strategy, so that not all the lower density SNPs were dropped

#### <font color=orange>Result</font>

- job.$breed/tdmout.\* generated, used for merging into [FImpute][5932b779] genotype file

### zzz-7-abg2FImpute.sh
generate genotypes.txt for [FImpute][5932b779] from snp_info.txt and trimDownOutput genotype files

#### <font color=green>Requires</font>

 - abg2FImpute
 - waitMulti.sh

#### <font color=red>TODO</font>

 - modify the shell script code to specify the number of jobs for waitMulti.sh parallel computing, default is
 >4

#### <font color=orange>Result</font>

- job.$breed/genotypes.txt generated, [FImpute][5932b779] input: genotype file
- job.$breed/dummy.ctr generated, [FImpute][5932b779] input: config file

### zzz-8-FImputeMac.sh
do the imputation

#### <font color=green>Requires</font>

 - [FImputeMac][5932b779]

#### <font color=red>TODO</font>

 - modify job.$breed/dummy.ctr config file to specify number of cores used in imputing, default is
 >8
 - modify the shell script code to specify the breeds needed to be imputed, defaults are
 >for dir in job.HER job.SIM job.AAN job.RDP job.RAN job.GVH job.LIM job.CHA job.BRG job.BSH job.NEL


#### <font color=orange>Result</font>

- job.$breed/optDummy/snp_info.txt generated, same as [FImpute][5932b779] input: map file
- job.$breed/optDummy/genotypes_imp.txt generated, [FImpute][5932b779] output: imputed genotype file

### zzz-9-free-space-after-FImpute.sh
clean out the working space, deleting useless files

### zzz-a-fout2abg.sh
convert imputed [FImpute][5932b779] output genotype file to AB-Genotype file format, and make newbin binary genotype file

#### <font color=green>Requires</font>

 - fout2abg
 - waitMulti.sh
 - binaryGenotypeFileIndexer

#### <font color=orange>Result</font>

- ./ab-genotype-${chip}-$breed generated, ab-genotype file
- ./ab-genotype-${chip}-$breed.newbin generated, binary genotype file
- ./ab-genotype-${chip}-$breed.newbin.ndx generated, index file for binary genotype file, all animalIDs in 1st column
