#------------
# this code is designed to generate the material file for vampire
#------------
# defining a class system so far for variables in each material in the material file 
class Materials:    #need to add a doc string 
    def __init__(self, damping, spin, anisotropy):
        self.damping = damping 
        self.spin = spin
        self.anisotropy = anisotropy
        pass
    def damping_const(self):    #damping
        return f'damping-constant={self.damping}'  
    def spin_moment(self):      #spin-moment 
        return f'atomic-spin-moment={self.spin}'
    def uniaxial_anisotriopy(self):     #only uniaxial atm but need to build others in- if statement? seperate classes from anisotropty?
        return f'uniaxial-anisotropy-constant{self.anisotropy}'
#this part of the code will learn about what the person wants to make- asking questions about the material 
question_1 = input("What material do you wish to simulate?")
question_2 = int(input("How many materials do you want to simulate? If you are simulating a compound count each element in the compound."))
    
# dictionary of materials 
magnetic_materials = {      
    "Mn" : "M",
    "Ir" : "NM",
    "Pt" : "NM",
    "Co" : "M",
    "Gd" : "M",
    "Fe" : "M",
}

total = []
NM_materials = []           #stores the non-magnetic materials in a list so that we can put the NM at the bottom of the material file
M_materials = []           #stored magnetic materials as a list for the exchnage constant generation
if question_2 > 1 :
    for i in range (1,question_2+1):
        material_name = input(f"what is the {i} element?")
        if material_name in magnetic_materials:
            if magnetic_materials.get(material_name) == "M":
                if i == 1:                  #have to check if it is the first material for counting purposes 
                    num_mat = 4
                    M_materials.append(material_name)           #appends the list of magnetic materials for the exchange generation                   
                    total.append(num_mat)                       #appends total list with the number of materials for this element 
                    counting = sum(total)                       #counts how many material sections have been generated 
                    for magnetic_material in range (counting-num_mat+1, counting+1):
                        print(f"material[{magnetic_material}]:'{material_name}'")
                else:                                               #same as above but for not the first material 
                    num_mat = 4
                    M_materials.append(material_name)
                    total.append(num_mat)
                    counting = sum(total)
                    for magnetic_material in range (counting-num_mat, counting):
                        print(f"material[{magnetic_material}]:'{material_name}'")
            else:                       #if the material is NM adds to the counter of number of materials but does not print statements
                num_mat = 1
                NM_materials.append(material_name)              #appends NM list with the name of the material for generation of material later
                total.append(num_mat)
                counting = sum(total)

num_materials = sum(total)              #saves the sum of the total as num_materials 
print(f'material:num-materials={num_materials}')   # gives the number of elements needed to be simulated in the form needed for vampire
print(f'the stored list is {total}')

# this section of the code generates the material section for the NM section (want it to be at the end to make the exchange constant generation easier)
non_magnetic = total.count(1)               #counts how many times "1" appears in the total list as this indicates a NM   
for n in range (0,non_magnetic):                        #loops through the number of NM materials and prints material file statement
    print(f"material[{num_materials-n}]:'{NM_materials[n]}'")

#exchange constant section
number_magnetic_materials = num_materials-non_magnetic          #works out how many materials in the material file are magnetic 
loop_value = len(M_materials)                                   #loops through the magnetic list to give the number of Magnetic materials (IrMn would be 1)

for n in reversed(range(0,loop_value)):                     #loops through the number of magnetic materials to 0 to get the exchange values from the user 
    for z in reversed(range(0,n+1)):                        #loops from n+1 to 0 to get the exchange constant for each interation (eg 2-2, 2-1, 2-0, 1-1, 1-0, 0-0)
       exchange_value = float(input(f'what is the exchange constant of {M_materials[n]} and {M_materials[z]}? '))
       #keeps n constant and changes z and then changes n to repeate 