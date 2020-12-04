# Flutter Pi, out of memory test.

Host:
1. clone fapp1
2. copy gen_snapshot_linux_x64 to project root
# Build release version
3. ./build_linux.sh && ./build_aot.sh


RaPi:
0. create fapp1 folder and fapp1/images
1. copy flutter-pi, icudtl.dat, libflutter_engine.so.debug, libflutter_engine.so.release to fapp1/
4. copy fapp1/build/flutter_assets to RaPi fapp1/flutter_assets
5. extract images.7z all files to fapp1/images
6. delete images.7z
7. exec ./run.sh or flutter in release mode
8. wait 10min, OOM :)