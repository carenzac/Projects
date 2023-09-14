#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------
# This bash script generates directories for damping, size and temperature for FePt, with the according variables
# altered in the material and input file, allowing the effect of each variable to be investigated. The user can change
# the ranges in this script and then run the script in viking.
# Tree: Run/Damping/Size/Temp/Randomseed
# FILES: FePtCS.mat, input, vampire-parallel 
# Author: Carenza Cronshaw (cec561@york.ac.uk)
# The Uinversity of York, UK
#-----------------------------------------------------------------------------------------------------------------------

#setting intital and final damping/ size/ temps and increment size

#damping
damping_initial=0.01
damping_final=0.01
damping_step=0.01
#size
size_initial=4.5
size_final=4.5
size_step=0.5
#temperature
temperature_initial=300
temperature_final=800
temperature_step=20

#for array job but make better
start=1
step=1
end=1
#setting start andend of array values for viking: these vaues must be the same as the random seed numbers

mkdir 45
cd 45
for damping in `seq $damping_initial $damping_step $damping_final`  #loops through all damping values
do
damping_folder=$damping

mkdir $damping_folder
cd $damping_folder
cp ../../FePtCS.mat .

sed 's/DAMPING/'"$damping"'/' FePtCS.mat > FePtCS_$damping.mat  #replaces DAMPING in FePtCS.mat with damping value
mv FePtCS_$damping.mat FePtCS.mat

for size in `seq $size_initial $size_step $size_final`
do
size_folder=$size

mkdir $size_folder
cd $size_folder
cp ../../../input .  #copies only input file as this is the only file that needs changing

####
# this one needs changing for system size and dimension size of particle 
####
#preparing and replacing Z (z size), XY (x and y size) and DIM (dimension) values
z_dim=`echo $size_folder | awk '{print ($1*1.5+1)}'` #`` saves to variable

#var_xy=`echo $size_folder | awk '{print ($1+0.1)}'`   #creates sizes (do math in awk in bash)
#var_dim=`echo $size_folder | awk '{print ($1*0.5)}'`  #check this for decimals
#var_dim=`echo $size_folder | awk '{print ($1)}'`

#particle spacing, particle size, system size 

sed 's/PART/'"$size_folder"'/' input > input_$size  #replaces XY, Z and dimension siz in input file
sed 's/Z/'"$z_dim"'/' input_$size > input
rm input_$size

for temperature in `seq $temperature_initial $temperature_step $temperature_final`
do
temperature_folder=$temperature

mkdir $temperature_folder
cd $temperature_folder
cp ../input .  #copies the edited input file from above

sed 's/TEMP/'"$temperature"'/' input > input_$temperature
mv input_$temperature input
cp ../../FePtCS.mat .
cp ../../../../vampire-cuda .
cd ../
done    #random seeds

#===================================================
# Submission script params
#===================================================

#----VARIABLES DFINED IN SUBMISSION SCRIPT

job_name="${temperature}seed${randomseed}"    #name that appear on viking
email="cec561@york.ac.uk" # email on job end commented out by default
output_file="output_log"
account="PHYS-VAMPIRE-2019"
#max_time="24:00:00"

echo '#!/bin/bash
#SBATCH --job-name=vampire-cuda                 # Job name
#SBATCH --mail-type=END,FAIL                   # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=carenza.cronshaws@york.ac.uk          # Where to send mail
#SBATCH --ntasks=40                             # Run a single task 
#SBATCH --cpus-per-task=1                      # Number of CPU cores per task
#SBATCH --mem=128gb                            # Job memory request
#SBATCH --time=48:00:00                        # Time limit hrs:min:sec
#SBATCH --partition=gpu                        # select the gpu nodes
#SBATCH --array='${temperature_initial}'-'${temperature_final}':'${temperature_step}'
#SBATCH --gres=gpu:1

echo My working directory is `pwd`
echo Running array job index $SLURM_ARRAY_TASK_ID, on host:
echo -e '\t'`hostname` at `date`
echo

module load toolchain/fosscuda/2020a
module load toolchain/fosscuda/2020b

module load toolchain/gcccuda/2020a
module load toolchain/gcccuda/2020b
module load compiler/GCCcore/10.3.0

cd $SLURM_ARRAY_TASK_ID/

./vampire-cuda

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
