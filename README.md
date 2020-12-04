# Flutter Pi, out of memory test.

## Host:
1. clone flutter-pi-oom
2. copy gen_snapshot_linux_x64 to project root
3. Build release version ./build_linux.sh && ./build_aot.sh


## RaPi:
0. create flutter-pi-oom folder and flutter-pi-oom/images
1. copy flutter-pi, icudtl.dat, libflutter_engine.so.debug, libflutter_engine.so.release to flutter-pi-oom/
4. copy flutter-pi-oom/build/flutter_assets to RaPi flutter-pi-oom/flutter_assets
5. extract images.7z all files to flutter-pi-oom/images
6. delete images.7z
7. exec ./run.sh or flutter in release mode
8. wait 10min, OOM :)