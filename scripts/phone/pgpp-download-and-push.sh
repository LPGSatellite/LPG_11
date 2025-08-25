# Download all executables.

scp \
My-cloud-server:/root/projects/SatLPG/pgpp/rust-blind-rsa-signatures-master/target/aarch64-linux-android/release/deps/blind_rsa_signatures-30ee9c19c39ff043 \
./android/
scp \
My-cloud-server:/root/projects/SatLPG/pgpp/rust-blind-rsa-signatures-master/target/aarch64-linux-android/release/deps/speed_test-e78c73d13e2fde86 \
./android/

# Push all scripts to the phone.

adb push ./android/blind_rsa_signatures-30ee9c19c39ff043 /data/local/tmp/bin
adb push ./android/speed_test-e78c73d13e2fde86 /data/local/tmp/bin

# On the phone, run the following commands:
# /data/local/tmp/bin/speed_test-e78c73d13e2fde86 --bench
# /data/local/tmp/bin/blind_rsa_signatures-30ee9c19c39ff043 --bench