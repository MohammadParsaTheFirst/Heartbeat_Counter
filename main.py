def round(x):
    if(x-int(x))>=0.5:
        return int(x)+1
    return int(x)-1

def to_seven_bit(y):
    z = 8- len(y)
    t ='0'*z
    return(t+y)

file = open("data.txt", "x")
for i in range(0,272):
    file.write("00000000\n")
for i in range(273,2000):
    y = 60000/i
    z = format(int(round(y)),'b')
    h = str(z)
    zz = to_seven_bit(h)
    file.write(zz+str("\n"))


