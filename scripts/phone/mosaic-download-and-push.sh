# Download all executables.

scp \
My-cloud-server:/root/projects/SatLPG/untraceable/brands-rs/target/aarch64-linux-android/release/deps/brands-c8fac6c736810c1f \
./android/
scp \
My-cloud-server:/root/projects/SatLPG/untraceable/brands-rs/target/aarch64-linux-android/release/deps/bench-a628a107b3687e88 \
./android/

# Push all scripts to the phone.

adb push ./android/brands-c8fac6c736810c1f /data/local/tmp/bin
adb push ./android/bench-a628a107b3687e88 /data/local/tmp/bin

# On the phone, run the following commands:
# /data/local/tmp/bin/brands-c8fac6c736810c1f --bench
# /data/local/tmp/bin/bench-a628a107b3687e88 --bench