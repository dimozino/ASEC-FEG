import numpy as np
f0 = open('Xdim', 'w')
f1 = open('Ydim', 'w')
f2 = open('Zdim', 'w')

a = float(QQQ)
b = float(WWW)
c = float(EEE)

a1 = a / 10
b1 = b / 10 
c1 = c / 10

f0.write(str(a1))
f1.write(str(b1))
f2.write(str(c1))

f0.close()
f1.close()
f2.close()
