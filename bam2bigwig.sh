#!/usr/bin/env bash

#step 1
input_directory=$1
output_directory=$2
mkdir $output_directory
cp $input_directory/*.bam $output_directory
cd $output_directory
input_files=$(ls ${output_directory})

#step 4 add logging
log=log.txt

#step 2 Conda
mamba create --yes --name bam2bigwig deeptools samtools
source /mbshome/mrattingen/mambaforge/etc/profile.d/conda.sh
#source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh 
conda activate bam2bigwig

#step 3 
for file in ${input_files[@]}; do
  input=$file
  echo  $input >> $log
  file_without_suffix=${file::-4}

  nice samtools index -b $input  >> $log 2>&1
  nice bamCoverage -b $input -o "$file_without_suffix".bw >> $log 2>&1
 
done
#step 6 wrapping up
rm *.bam
rm *.bai
echo "Maaike van Rattingen"
