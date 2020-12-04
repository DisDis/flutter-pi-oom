#!/bin/sh
#./screenOn.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./

#debug
#./flutter-pi -d "192, 120"  --no-text-input ./flutter_assets/
#release
#./flutter-pi -d "192, 120"  --no-text-input --release ./flutter_assets/
#release
./flutter-pi  --release --no-text-input ./flutter_assets/

#while true
#do
#	echo "Press [CTRL+C] to stop.."
#	sleep 1
#        ./flutter-pi -d "192, 120"   --release --no-text-input ./flutter_assets/
#done

