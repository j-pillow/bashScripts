#!/bin/bash

theseTars=$(ls --color=none -x -1 *.tar)

if [ $# -eq 0 ]; then
  extractPythons=0
else
  extractPythons=$1
fi

echo $extractPythons

while IFS= read -r myFile ;
do
  echo $myFile

  # Set the directory that corresponds to this .tar
  dir=${myFile%_*}
  echo $dir
  echo
  # Count how many items are in this dir
  lsDirN=$(ls --color=none -x -1 ${dir} | wc -l)

  # If the dir isn't empty, we want to empty it (because we have a new .tar).
  if [ $lsDirN -gt 1 ]; 
  then
    # Double check $dir isn't empty
    toTest="rm -rf "${dir}"/*"
    if [ "${toTest}" == "rm -rf /*" ];
    then
      echo "Variable 'dir' is empty. Exiting to prevent rm -rf /*"
      exit
    else
      rm -rf ${dir}/*
    fi
  fi
  
  # Move the .tar to the dir and cd to it
  mv ${myFile} ${dir}
  cd ${dir}

  # Untar the file, then hadd the root files
  tar xf ${myFile}
  hadd ${dir}.root */*/pdAnaTree.root

  # If the extractPythons options is set we need to extract the python display files
  if [ $extractPythons -eq 1 ]; 
  then

    # Get a list of the directories extarcted from the .tar
    dirLS=$(ls --hide=*.root --hide=*.tar --hide=*.sh --color=none -x -1 .)

    # Go through this list
    while IFS= read -r line ;
    do
      # Get a list of the sub directories in the directories we're going through 
      subDirLS=$(ls --hide=*.list --hide=*_start --hide=*_stop --color=none -x -1 $line)

      # Go through this second list
      while IFS= read -r line2 ;
      do
        # Untar these log files that contain the python display files
        tar xf ${line}"/"${line2}"/log.tar" 
      done <<< "$subDirLS"
    done <<< "$dirLS"
  
    # Lets make a directory to store all this files in. Name it the same as the 
    # mother directory as we'll move it to the evtDisplay directory
    mkdir ${dir}
    #mv evt*.py ${dir}/
    find  . -maxdepth 1 -name "evt*.py"  -exec mv '{}' ${dir}/ \;
    
    # Remove all the other crap that was untared
    rm -f Stage0.fcl bad.list cfgStage0.fcl commandStage0.txt consumed_files.list cpid.txt debug.log emptydir.py env.txt events.list experiment_utilities.py experiment_utilities.pyc extractor_dict.py extractor_dict.pyc file_to_url.sh files.list filesana.list hostname.txt jobid.txt lar.stat larStage0.err larStage0.out larStage0.stat larbatch_posix.py larbatch_posix.pyc larbatch_utilities.py larbatch_utilities.pyc merge_json.py missing_files.list mkdir.py pdAnaTree.root.json project_utilities.py project_utilities.pyc root_metadata.py root_metadata.pyc runProtoDUNEAnaTree_mc.fcl sam_project.txt subruns.py validate.list validate_in_job.py work867e36e98ef9e703a0293cba82ca8df4.tar wrapper.fcl
  fi

  # Now we want to remove the jpillow* directories
  rm -rf jpillow_mcc11*

  # cd back down
  cd ../



done <<< "$theseTars"
#ct
