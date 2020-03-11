dataset=$1
nJobs=$2
memory=$3
lifetime=$4

echo "<?xml version=\"1.0\"?>

<!-- Production Project -->

<!DOCTYPE project [
    <!ENTITY relana \"v08_40_00\">
    <!ENTITY file_type \"mc\">
    <!ENTITY run_type \"physics\">
    <!ENTITY name \"protodata\">
    <!ENTITY tag \"ana\">
    ]>

<job>

<project name=\"&name;\">

<!-- Group -->
<group>dune</group>

<!-- Make sure we keep a 1-to-1 mapping with the SAM files -->
<!-- Number of events large enough that we always process all events -->
<numevents>100000</numevents>
<maxfilesperjob>1</maxfilesperjob>

<!-- Operating System -->
<os>SL7</os>

<!-- Batch resources -->
<resource>DEDICATED,OPPORTUNISTIC</resource>

<!-- Larsoft information -->
<larsoft>
  <tag>&relana;</tag>
  <qual>e17:prof</qual>
  <local>/pnfs/dune/resilient/users/jpillow/DUNE_v08_40_00/DUNE_08_40_00.tar</local>
</larsoft>

<check>1</check>

<stage name = \"AnaTree\">
    <fcl>/dune/data/users/jpillow/DUNE_v08_40_00/eles/runProtoDUNEAnaTree_mc.fcl</fcl>
    <inputdef>${dataset}</inputdef>
    <outdir>/pnfs/dune/scratch/users/jpillow/${dataset}</outdir>
    <workdir>/pnfs/dune/resilient/users/jpillow/${dataset}</workdir>
    <numjobs>${nJobs}</numjobs>
    <datatier>full-reconstructed</datatier>
    <jobsub>--memory=${memory} --expected-lifetime=${lifetime} -f /pnfs/dune/resilient/users/jpillow/sceCorrectionStuff/Xcalo_sce.root -f /pnfs/dune/resilient/users/jpillow/sceCorrectionStuff/YZcalo_sce.root -f /pnfs/dune/resilient/users/jpillow/sceCorrectionStuff/SCE_DataDriven_180kV_v3.root</jobsub>
</stage>

</project>
</job>" > /dune/data/users/jpillow/DUNE_v08_40_00/eles/${dataset}.xml
