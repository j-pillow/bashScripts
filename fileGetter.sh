#!/bin/bash
if [ $# -lt 2 ];
then
  echo 'Please provide the run number and the event number'
  echo 'fileGetter.sh runNumber eventNumber'
  return
fi

runNumber=$1
evtNumber=$2

theFile=$(getfile.py ${runNumber} ${evtNumber})

skip=${theFile##*-}

dlNumber=${theFile%%.root*}
dlNumber=${dlNumber#*run00${runNumber}_}

samOut=$(samweb list-files "run_number ${runNumber}" | grep "reco" | grep "$dlNumber")

nLines=$(echo "$samOut" | wc -l )

if [ $nLines -gt 1 ]
then
  while IFS= read -r line ;
    do
      artVersion=$(samweb get-metadata $line)
      artVersion=${artVersion#*art reco}
      artVersion=${artVersion%Event Count*}
      echo $artVersion
      location=$(samweb locate-file $line)
      location=${location#*enstore:}
      location=${location%(*}
      echo ${location}'/'$line '--'$skip;
      echo
    done <<< "$samOut"

else
  artVersion=$(samweb get-metadata $samOut)
  artVersion=${artVersion#*art reco}
  artVersion=${artVersion%Event Count*}
  echo $artVersion
  location=$(samweb locate-file $samOut)
  location=${location#*enstore:}
  location=${location%(*}
  echo ${location}'/'$samOut '--'$skip
fi

