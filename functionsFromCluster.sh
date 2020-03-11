#!/bin/bash

function lsCount() {
  lsList=$(ls --color=none -x -1 $1)
  while IFS= read -r myDir ;
  do
    echo $myDir
    ls $myDir | wc -l
    echo
  done <<< "$lsList"
}

function cduneD() {
  if [ $# -lt 2 ]
  then
    echo 'Please provide a version and subversion number'
    echo 'The command should be of the form:'
    echo 'dune version subversion'
    echo 'Acceptable inputs could be:'
    echo 'dune 8 07'
    echo 'dune 10 02'
    echo 'dune 7 17'
    echo 'dune 8 05_01'
    exit
  fi

  if [ ${#1} -gt 1 ]
  then
    version=$1
  else
    version=0$1
  fi

  if [ ${#2} -gt 2 ]
  then
    subVersion=$2
  else
    subVersion=${2}_00
  fi

  compiler=19
  echo $compiler
  create=1

  mkdir /dune/data/users/jpillow/DUNE_v${version}_${subVersion}
  cd /dune/data/users/jpillow/DUNE_v${version}_${subVersion}
  wd=/dune/data/users/jpillow/DUNE_v${version}_${subVersion}
  echo source /dune/data/users/jpillow/bashScripts/setup_and_create.sh $version $subVersion $compiler $create;
  source /dune/data/users/jpillow/bashScripts/setup_and_create.sh $version $subVersion $compiler $create;

}


  # setup_and_create.sh
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup dunetpc v${1}_${2} -q e${3}:prof

if [ ${4} -eq 1 ]
then
  mrb newDev
  source ${wd}/localProducts_larsoft_v${1}_${2}_e${3}_prof/setup
  setup larbatch v01_51_10
else
  source ${wd}/localProducts_larsoft_v${1}_${2}_e${3}_prof/setup
  setup larbatch v01_51_10
  merbsetenv
fi

