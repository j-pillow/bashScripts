#!/bin/bash

energy=$1
testSet=$2
nSets=$3

if [ $testSet -eq 1 ];
then
  #source datasetXMLSubber.sh datasetDefs/PDSPProd2_${energy}GeV_sce_setTest.txt 3000 30m sce
  while read -r line;
  do
      echo "source indvDatasetXMLSubber.sh" $line "3000 90m &"
      source indvDatasetXMLSubber.sh $line 3000 90m &
  done < datasetDefs/PDSPProd2_${energy}GeV_sce_setTest.txt

else

  datasets=$(ls --color=none -x -1 datasetDefs/PDSPProd2_${energy}GeV_sce_set*.txt)
  datasets=$(echo "$datasets" | sed '$d')

    # Counter for the number of files to process
  counter=1

    # Go over the list of the files containing the datasets
  while IFS= read -r set ;
  do

      # Go through the datasets listed in the file above
    while read -r line ;
    do
      echo "source indvDatasetXMLSubber.sh" $line "3000 90m &"
      source indvDatasetXMLSubber.sh $line 3000 90m &
      sleep 30s
    done < $set

      # Check if the max number of files has been reached
    if [ $counter -eq $nSets ];
    then
      break
    fi
    counter=$((counter+1))
    
  done <<< "$datasets"

fi
