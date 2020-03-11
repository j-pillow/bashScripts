#!/bin/bash

jobCompletionTest () {
  echo Checking completion of ${1}
  echo '' 
  testVal=0
  while [ $testVal ]
  do
    bjobs=$(jobsub_q --user jpillow)
    nLines=$(echo "$bjobs" | wc -l)

    if [ $nLines -gt 1 ];
    then
       
      held=${bjobs%%held*}
      held=${held##*running, }
      
      running=${bjobs%%running*}
      running=${running##*idle, }
      
      idle=${bjobs%%idle*}
      idle=${idle##*removed, }

      printf "\033[1A"
      printf "\033[K"
      echo 'running:' ${running} '| held:' ${held} '| idle:' ${idle}

      if [ $running -eq 1 ] && [ $held -gt 0 ] && [ $idle -eq 0 ]
      then 
        echo Held jobs are preventing job from finishing. Killing ${1}.
        echo 'jobsub_rm --constraint' '(JobStatus=?=5)&&(Owner=?="jpillow")'

        echo ${1} had ${held} of ${2} jobs held, which were then killed. >> jobCompletionStat_${3}.txt
        while IFS= read -r line ;
        do
          echo ${line} >> jobCompletionStat_${3}.txt 
        done <<< "$bjobs"
        echo '' >> jobCompletionStat_${3}.txt
        echo '================================================================================================' >> jobCompletionStat_${3}.txt
        echo '' >> jobCompletionStat_${3}.txt

        jobsub_rm --constraint '(JobStatus=?=5)&&(Owner=?="jpillow")'
        return 0
      fi

    else
      echo ${1} completed fine.
      echo ${1} completed fine. >> jobCompletionStat_${3}.txt
      echo '' >> jobCompletionStat_${3}.txt
      echo '================================================================================================' >> jobCompletionStat_${3}.txt
      echo '' >> jobCompletionStat_${3}.txt
      return 0
    fi

    sleep 60s

  done

}

dataset=$1
memory=$2
lifetime=$3

while read -r line;
do
  
  if [ -d "/pnfs/dune/scratch/users/jpillow/$line" ]
  then
    rm -rf /pnfs/dune/scratch/users/jpillow/$line
    mkdir /pnfs/dune/scratch/users/jpillow/$line
  else
    mkdir /pnfs/dune/scratch/users/jpillow/$line
  fi
  
  if [ -d "/pnfs/dune/resilient/users/jpillow/$line" ]
  then
    rm -rf /pnfs/dune/resilient/users/jpillow/$line
    mkdir /pnfs/dune/resilient/users/jpillow/$line
  else
    mkdir /pnfs/dune/resilient/users/jpillow/$line
  fi

  samOut=$(samweb list-definition-files $line --summary)
  samOut=${samOut%%Total*}
  samOut=${samOut##*count:}

  source xmlMaker.sh $line $samOut $memory $lifetime

  xmlName=${line}.xml

  samweb prestage-dataset --defname=$line
  project.py --xml $xmlName --stage AnaTree --submit > project_py_output.txt

  # Test if the project.py submission worked
  ppOutTest=$( tail -n 1 project_py_output.txt )

  # If the sub didn't work, then we try again, but only 5 times max.
  counter=0
  while [ "${ppOutTest}" != "jobsub_submit finished." -a $counter -lt 5 ]
  do
    sleep 120s
    echo "Attempt" $counter
    project.py --xml $xmlName --stage AnaTree --submit > project_py_output.txt
    ppOutTest=$( tail -n 1 project_py_output.txt )
    counter=$[$counter+1]
  done

  # Print the output to terminal  
  cat project_py_output.txt
  

  timeNow=$(date +%H:%M:%S)
  echo $line "submitted at" $timeNow >> jobCompletionStat_${4}.txt 
  echo '' >> jobCompletionStat_${4}.txt
  echo '================================================================================================' >> jobCompletionStat_${4}.txt
  echo '' >> jobCompletionStat_${4}.txt

  rm -f $xmlName

  sleep 60s
  #jobCompletionTest $line $samOut $4

  echo ''
  echo '======================================================================================'
  echo ''

done < $dataset
