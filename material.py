# this code is designed to generate the material file for vampire
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
    
# have a dictionary of materials here 
magnetic_materials = {      #dictionary of materials- needs expanding 
    "Mn" : "M",
    "Ir" : "NM",
    "Pt" : "NM",
    "Co" : "M",
    "Gd" : "M",
    "Fe" : "M",
}
total = []
if question_2 > 1 :
    for i in range (1,question_2+1):
        material_name = input(f"what is the {i} element?")
        damping_val = float(input(f"what is the damping constant of material {i}: "))    #asks the user what the values are for each of the materials 
        spin_val = float(input(f"what is the atomic spin moment of material {i}: "))
        anisotropy_val = float(input(f"what is the anisotropy constant of material {i}: "))
        if material_name in magnetic_materials:
            if magnetic_materials.get(material_name) == "M":
                num_mat = 4
                total.append(num_mat)
                counting = sum(total)
                #add here code to write the files?
                for magnetic_material in range (1, counting+1):
                    print(f"material[{magnetic_material}]:'{material_name}'")
                    material_generation = Materials(damping_val,spin_val,anisotropy_val)        #feeds inputed values through the defined class structure 
                    print(f"material[{magnetic_material}]:{material_generation.damping_const()}")       #prints lines to screen, want to eventually feed this to a .mat file 
                    print(f"material[{magnetic_material}]:{material_generation.spin_moment()}")
                    print(f"material[{magnetic_material}]:{material_generation.uniaxial_anisotriopy()}")
            else:
                num_mat = 1
                total.append(num_mat)
                counting = sum(total)
                for magnetic_material in range (1, counting+1):
                    print(f"material[{magnetic_material}]:'{material_name}'")
                    material_generation = Materials(damping_val,spin_val,anisotropy_val)        #feeds inputed values through the defined class structure 
                    print(f"material[{magnetic_material}]:{material_generation.damping_const()}")       #prints lines to screen, want to eventually feed this to a .mat file 
                    print(f"material[{magnetic_material}]:{material_generation.spin_moment()}")
                    print(f"material[{magnetic_material}]:{material_generation.uniaxial_anisotriopy()}")
        else:
            not_defined = input("Is your material magnetic, M, or not magnetic, NM?")
            if not_defined == "M":
                num_mat = 4
                total.append(num_mat)
            else:
                num_mat = 1
                total.append(num_mat)
print(sum(total))   # gives the number of elements needed to be simulated 





#maybe it is here in this loop that we begin to populate the material file, calling classes here 



'''
#material = input("what material are you generating? ")
num_materials = int(input("enter the number of materials in your system: "))

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


for n in range (1,num_materials+1):     #looping through all materials in the material file 
    damping_val = float(input(f"what is the damping constant of material {n}: "))    #asks the user what the values are for each of the materials 
    spin_val = float(input(f"what is the atomic spin moment of material {n}: "))
    anisotropy_val = float(input(f"what is the anisotropy constant of material {n}: "))
    material_generation = Materials(damping_val,spin_val,anisotropy_val)        #feeds inputed values through the defined class structure 
    print(f"material[{n}]:{material_generation.damping_const()}")       #prints lines to screen, want to eventually feed this to a .mat file 
    print(f"material[{n}]:{material_generation.spin_moment()}")
    print(f"material[{n}]:{material_generation.uniaxial_anisotriopy()}")
'''






#final part (?) is the generation of the material file, need to work out how to store results from above to put into .mat file 
'''
with open(
    "material.txt",
    mode = "w+",
    encoding  = "utf-8"
            ) as file:
    file.writelines([
        "#---------------------------" "\n"
        "# Number of materials" "\n"
        "#---------------------------" "\n"
        f"material:num-materials={num_materials}""\n"
        "#---------------------------" "\n"
        f"# " "\n"

    ]) # write lines to files \n is the new-line operator  
'''

#next step: look at how to generate exchnage constants in a logial way- class system for this 