
#-----------------------------------------------------------------------------------------------------------------------
# This bash script analyses the results from the submission script. Starting in the intial Run directory it deletes
# undeeded files in each directory and then takes the random seed value and tail of each output to determine Switching
# probability to then plot a final graph of switching probability vs temperature called
# Probability_${size}_${damping}.epsfile which can then be copied into the home direcotry to render image. 
# Tree: Run/Damping/Size/Temp/Randomseed
# FILES NEEDED IN PARENT DIRECTORY: Flipping.py, gnuplot.sh, nature.journal and bluegold-sI.colour
# Author: Carenza Cronshaw (cec561@york.ac.uk)
# The Uinversity of York, UK
#-----------------------------------------------------------------------------------------------------------------------

#Loading gnuplot
module load vis/gnuplot/5.2.2-foss-2018b

#THESE VALUES MUST BE THE SAME AS THOSE IN THE SUBMISSION SCRIPT!
#damping
damping_initial=0.1
damping_final=0.2
damping_step=0.1
#size
size_initial=4.0
size_final=5.0
size_step=1.0
#temperature
temperature_initial=500
temperature_final=800
temperature_step=50

cd Run #enetering same directory as the submission script

#this section removes files needed for analysis
for damping in `seq $damping_initial $damping_step $damping_final`  #enters damping directories
do
damping_folder=$damping
cd $damping_folder
rm FePtCS.mat

for size in `seq $size_initial $size_step $size_final`
do
size_folder=$size
cd $size_folder
rm input
#rm TP.txt

for temperature in `seq $temperature_initial $temperature_step $temperature_final`
do
temperature_folder=$temperature
cd $temperature_folder
rm input

cd Run
rm output_log  run_vampire_array.sh    #removing all files that are not a random seed directory

vals=`ls`                #sets directory names as a list
#echo $vals
for i in $vals           #loops through all random seed directories
do
cd $i
echo $i >> ../../Seed.txt             #saves the random seed number to a directory called Seed.txt
file="output"
cat $file | awk  '{print $1,$2,$3,$4,$5,$6,$7}' > test.txt   #enters output and saves first 7 columns as test.txt
newfile="test.txt"
tail -n 1 $newfile >> ../../lastline.txt     #saves last line of the output file to a file called lastline.txt in the temperature directory
cd ../
done

cd ../  #enters temp directory

paste Seed.txt lastline.txt >> Final.txt  #creats .txt file of ranomd seed number and the last line
cat Final.txt | awk '{print $1*10000,$4*$7, $5*$7, $6*$7}' >> Probability.txt    #saves the seed value and normalised x, y and z magnetisation as a .txt file
rm Final.txt Seed.txt lastline.txt

cp ../../../../Flipping.py .
python3 Flipping.py  #runs Flipping.py which creates a .txt file called flippingprobability.txt

cd ../  #enters size directory
done

temps=`ls`                #saves a list of temperatures
#echo $temps
for i in $temps           #loops through all temps
do
cd $i
echo $i >> ../temp.txt             #saves the temperature values to a file called temp.txt in the size directory
file="flippingprobability.txt"
cat $file | awk  '{print $1}' >> ../probs.txt  #creates a .txt file of all switching probabilities in the size directory
#newfile="probs.txt"
cd ../
done
paste temp.txt probs.txt >> TP.txt  #combines temperature and switching probabilities into TP.txt for plotting
rm temp.txt probs.txt

#graph plotting section
#copies files needed to plot
cp ../../../nature.journal .
cp ../../../bluegold-sl.colour .
cp ../../../gnuplot.sh .
gnuplot gnuplot.sh
cp Probability.eps Probability_${size}.eps  #renames graph by the size name so can be copied into home directory easily

#DO NOT CHANGE THIS OR FILES END UP IN STRANGE PLACES YOU HAVE MADE THIS MISTAKE BEFORE
#size directory
cd ../
#damping directory
done
cd ../
done
