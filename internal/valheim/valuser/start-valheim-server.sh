#!/bin/sh 
export templdpath=$LD_LIBRARY_PATH  
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH  
export SteamAppID=892970

echo "Starting server PRESS CTRL-C to exit"  
./valheim_server.x86_64 -name "NamonesDedicatedValheimServer" -port 2456 -nographics -batchmode -world "DedicatedWorld" -password "Valheimpass4500" -savedir "/games/save-data/Valheim" -public 1  
export LD_LIBRARY_PATH=$templdpath
