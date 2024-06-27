import os
import sys

i=0
while 1:
    if not os.path.isdir("roots/"+str(i)):
        os.makedirs("roots/"+str(i))
        os.system("tar -zxf ubuntu-focal-oci-amd64-root.tar.gz -C roots/"+str(i))
        rt = "roots/"+str(i)
        break
    else:
        i=i+1

hn = str(sys.argv[1])
os.system("unshare --fork --pid --mount-proc --uts --net bash -c  \"hostname " + hn + " && /bin/bash\"")
os.system("rm -r " + rt)