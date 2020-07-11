import math

file = open("data.txt","r")    
num_lines = sum(1 for line in file)
print(num_lines)
file.close()
content = []
for line in open("data.txt") :
    content.append(line.strip())


for i in range (len(content)):
    content[i] = int(content[i])

print(content)

x = -2500
f = open("cor_data.xyz","w")    
f.close()
for j in range(math.ceil(num_lines/8)):
    x+= 2500
    if(j%2 != 0):
        n = (1*math.pi/4)
        for i in range(8):
            n += (-1*math.pi/4)
            y = (content[i+j*8]*math.sin(n))
            z = (content[i+j*8]*math.cos(n))
            f = open("cor_data.xyz","+a")    
            f.write(str(x))
            f.write(" ")
            f.write(str(y))
            f.write(" ")
            f.write(str(z))
            f.write("\n")           
            f.close()
    if(j%2 == 0):
        array = []
        n = (-1*math.pi/4)
        for i in range(8):
            n += (1*math.pi/4)
            y = (content[i+j*8]*math.sin(n))
            z = (content[i+j*8]*math.cos(n))
            if (i == 0):
                f = open("cor_data.xyz","+a")    
                f.write(str(x))
                f.write(" ")
                f.write(str(y))
                f.write(" ")
                f.write(str(z))
                f.write("\n")           
                f.close()
                continue
            array.append(str(x) + " " + str(y) + " " + str(z)+ "\n")
        for i in range(7):
            f = open("cor_data.xyz","+a")
            f.write(array[6-i])
            f.close()
