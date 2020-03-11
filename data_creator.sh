#!/bin/bash

file=$1
run=$2

counter=0
subCounter=0

energy=${file%%GeV*}
energy=${energy##*sce_}
echo $energy

echo "${energy}GeV_new" >> samweb_datasets_runs.txt


while read -r line ;
  do
    echo -n $line >> ${file%%.txt}_${counter}_temp.txt
    echo -n ", " >> ${file%%.txt}_${counter}_temp.txt
    subCounter=$((subCounter+1))
    if [ $subCounter -eq 200 ]
    then
      counter=$((counter+1))
      subCounter=0
    fi 
done < $file

newCounter=0

while [ $newCounter -le $counter ];
do
  tempFile="${file%%.txt}_${newCounter}_temp.txt"
  line=$(head -n 1 $tempFile)
  line=${line%?}
  line=${line%?}
  echo -n "samweb create-definition jpillow_run_${run}_${energy}GeV_set${newCounter} \"file_name " >> ${file%%.txt}_${newCounter}.sh
  echo -n $line >> ${file%%.txt}_${newCounter}.sh
  echo -n "\"" >> ${file%%.txt}_${newCounter}.sh

  fileToSource="${file%%.txt}_${newCounter}.sh"
  source $fileToSource

  echo "jpillow_run_${run}_${energy}GeV_set${newCounter}" >> samweb_datasets_runs.txt

  rm -f $fileToSource
  rm -f $tempFile

  newCounter=$((newCounter+1))
done

echo " " >> samweb_datasets_runs.txt 
echo "===========================================" >> samweb_datasets_runs.txt 
echo " " >> samweb_datasets_runs.txt 
