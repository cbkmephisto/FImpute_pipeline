# FImpute_pipeline

Scripts processing **ab-genotype** to [FImpute][3436ed9e] to **ab-genotype**/haplotype, using tools from `SNPipeline`.

  [3436ed9e]: http://www.aps.uoguelph.ca/~msargol/fimpute/ "FImpute"

0. make links to `pooled_*` to `0-pooled/`

1. `cd 0-pooled`; and run `./zzz-0-*` to convert `pooled_BOS1` to `pooled_100k` if exists. And then cd back `cd ..`

2. `cd 1-maps`;   and run `./zzz-0-*` to link map files according to `pooled_*` files

3. other scripts in the current folder

  - `zzz-1-get_pooled_info_count_breed.sh`
	generates `rrr-1-breed-population`

  - `zzz-2-get_SNP_IDs.sh`
	generates `rrr-2-SNP_IDs-$chip`, make `snp_info.txt` from them, and make new map files with `snp_info.txt` (si.map.*)

  - `zzz-3-split-by-chip-breed_MULTICORE.sh`
	generates `job.$breed`

  - `zzz-4-get-sample-IDs.sh`
	generates `job.$breed/IDs.$chip.IDs` for excluding

  - `zzz-5-excluding.sh`
	excludes animalIDs in the lower density panels that are in common with higher density ones

  - `zzz-6-trimDownGenotypes.sh`
	trims genotype files according to `si.map.*` to make them in consistent with `snp_info.txt`

  - `zzz-7-abg2FImpute.sh`
	generates `genotypes.txt` for [FImpute][3436ed9e] from `snp_info.txt` and trimDownOutput genotype files

  - `zzz-8-FImputeMac.sh`
	does the imputation

  - `zzz-9-free-space-after-FImpute.sh`
	cleans out the working space, deleting useless files
