#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------
# This bash script generates directories for damping, size and temperature for FePt, with the according variables
# altered in the material and input file, allowing the effect of each variable to be investigated. The user can change
# the ranges in this script and then run the script in viking.
# Tree: Run/Damping/Size/Temp/Randomseed
# FILES NEEDED IN PARENT DIRECTORY: FePtCS.mat, input, vampire-parallel
# Author: Carenza Cronshaw (cec561@york.ac.uk)
# The Uinversity of York, UK
#-----------------------------------------------------------------------------------------------------------------------

# loading modules needed
module_1=mpi/OpenMPI/2.0.2-GCC-7.3.0-2.30 				#OpenMPI
module_2=toolchain/foss/2019a						        #Vampire
module_3=vis/gnuplot/5.2.2-foss-2018b					#Gnuplot
module_4=lang/Python/3.7.0-foss-2018b				#Python

#setting intital and final damping/ size/ temps and increment size

#damping
damping_initial=0.1
damping_final=0.2
damping_step=0.1
#size
size_initial=4.0
size_final=5.0
size_step=1.0
#temperature
temperature_initial=700
temperature_final=710
temperature_step=10

#setting start andend of array values for viking: these vaues must be the same as the random seed numbers
start=1
end=2
increment=1

#it might be nice here to add conditions: that the files are there?

#make directory called Run where all directories are stored (THIS MUST BE THE SAME AS IN ANALYSIS.SH)
mkdir Run
cd Run

for damping in `seq $damping_initial $damping_step $damping_final`  #loops through all damping values
do
damping_folder=$damping

mkdir $damping_folder
cd $damping_folder
cp ../../FePtCS.mat .
sed 's/DAMPING/'"$damping"'/' FePtCS.mat > FePtCS_$damping.mat  #replaces DAMPING in FePtCS.mat with damping value
cp FePtCS_$damping.mat FePtCS.mat
rm FePtCS_$damping.mat

for size in `seq $size_initial $size_step $size_final`
do
size_folder=$size

mkdir $size_folder
cd $size_folder
cp ../../../input .  #copies only input file as this is the only file that needs changing

#preparing and replacing Z (z size), XY (x and y size) and DIM (dimension) values
var_z=`echo $size_folder | awk '{print ($1*1.5+0.1)}'` #`` saves to variable
var_xy=`echo $size_folder | awk '{print ($1+0.1)}'`   #creates sizes (do math in awk in bash)
var_dim=`echo $size_folder | awk '{print ($1*0.5)}'`  #check this for decimals

sed 's/Z/'"$var_z"'/' input > input_$size  #replaces XY, Z and dimension siz in input file
sed 's/XY/'"$var_xy"'/' input_$size > input2_$size
sed 's/DIM/'"$var_dim"'/' input2_$size > input
rm input_$size input2_$size

for temperature in `seq $temperature_initial $temperature_step $temperature_final`
do
temperature_folder=$temperature

mkdir $temperature_folder
cd $temperature_folder
cp ../input .  #copies the edited input file from above

sed 's/TEMP/'"$temperature"'/' input > input_$temperature
cp input_$temperature input
rm input_$temperature

mkdir Run #where simulations will run, needed for analysis
cd Run

for randomseed in $(seq 1 1 2)  #112 is right start, increment, final value
do
  mkdir "${randomseed}"
  cd "${randomseed}"
  cp ../../input .
  cp ../../../../FePtCS.mat .
  cp ../../../../../../vampire-parallel .  #copies from original directory
    seedvalue=$(( 10000*$randomseed ))
    #echo "$seedvalue"
  sed 's/RANDOMSEED/'"$seedvalue"'/' input > input_$seedvalue
  cp input_$seedvalue input
  rm input_$seedvalue
  #mpirun -np 2 ~/vampire/vampire-parallel  #for local running this runs vampire parallel
  #rm input FePtCS.mat

cd ../
done    #random seeds

#===================================================
# Submission script params
#===================================================

#----VARIABLES DFINED IN SUBMISSION SCRIPT

job_name="${temperature}seed{$randomseed}"    #name that appear on viking
email="cec561@york.ac.uk" # email on job end commented out by default
output_file="output_log"
account="PHYS-VAMPIRE-2019"
max_time="24:00:00"

echo '#!/bin/bash
#SBATCH --job-name='${job_name}'
#SBATCH --mail-type=END,FAIL
##SBATCH --mail-user='${email}'
#SBATCH --ntasks=1
#SBATCH --time='${max_time}'
#SBATCH --output='${output_file}'
#SBATCH --account='${account}'
#SBATCH --array='${start}'-'${end}':'${increment}'

echo My working directory is `pwd`
echo Running array job index $SLURM_ARRAY_TASK_ID, on host:
echo -e '\t'`hostname` at `date`
echo

module load toolchain/foss/2019a
JOBID1=$(sbatch --parsable <other_options> <submission_script>)

cd $SLURM_ARRAY_TASK_ID/

./vampire-parallel

cd ../

echo
echo Job completed at `date`
' >> run_vampire_array.sh

#cd '${i}' enters the i direcotry to then run vampire then ../out of it once completed

# run submission script (this is what runs)
sbatch run_vampire_array.sh

#jid=$(sbatch --parsable --array=1-2 run_vampire_array.sh)
#sbatch --dependency=afterok:${jid} analysis.sh
#sbatch --dependency=afterok:$job_name analysis.sh

#run directory
cd ../
#temperature
cd ../
done
#size
cd ../
done
#damping
cd ../
done    #damping
