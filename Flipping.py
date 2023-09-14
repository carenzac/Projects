#!/usr/bin/env python
# coding: utf-8

#-----------------------------------------------------------------------------------------------------------------------
# This Python script opens the probability.txt file fenerated in the bash scrip and works out the probability of moments
# flipping. The probability is then saved to a txt file sample.txt for each temperature to greate a graph of
# flipping probability vs temperature for each grain size and damping.
# Author: Carenza Cronshaw (cec561@york.ac.uk)
# The Uinversity of York, UK
#-----------------------------------------------------------------------------------------------------------------------

with open('Probability.txt') as infile:     #opens .txt file
    list=[]
    for line in infile:
        #print(line.split()[3])
        list.append(line.split()[3])           #appends list with results in column 4 PYTHON COUNTS FROM 0
    #print(list)

# Using list comprehension
float_list = [float(x) for x in list]        #turns string list (elements in list have'' around them) into float list

# Printing output
#print(float_list)

total_sims=len(float_list)   # gives the total number of entries in the float_list
#print(number)
pos_count, neg_count = 0, 0

# iterating each number in list
for num in float_list:

    # checking condition
    if num >= 0:
        pos_count += 1

    else:
        neg_count += 1

#percentages
negative_percentage=float(neg_count/total_sims)*100
positive_percentage=float(pos_count/total_sims)*100

#idea = positive_percentage, negative_percentage
#print(idea)

#print("The percentage of simulations that did not flip ", positive_percentage)
#print("The percentage of simulations that flipped ", negative_percentage)
#print(positive_percentage, negative_percentage)

#idea = positive_percentage, negative_percentage
#output_file = open("test.txt", "w")
#output_file.str(negative_percentage)

flipping = open("flippingprobability.txt", "w")
flipping.write(str(negative_percentage))
flipping.close()
