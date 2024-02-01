#!/bin/sh

mkdir /tpm/emulated_tpm
swtpm_setup --tpm2 --create-config-files overwrite,root
swtpm_setup --tpm2 --config ~/.config/swtpm_setup.conf --tpm-state /tpm/emulated_tpm --overwrite --create-ek-cert --create-platform-cert --write-ek-cert-files /tpm/emulated_tpm
swtpm socket --tpm2 --flags not-need-init --tpmstate dir=/tpm/emulated_tpm --server type=tcp,port=2321 --ctrl type=tcp,port=2322 &
sleep 5

export DBUS_SESSION_BUS_ADDRESS=`dbus-daemon --session --print-address --fork`
tpm2-abrmd --allow-root --session --tcti=swtpm:host=127.0.0.1,port=2321 &

export TPM2TOOLS_TCTI="tabrmd:bus_name=com.intel.tss2.Tabrmd,bus_type=session"
export TPM2OPENSSL_TCTI="tabrmd:bus_name=com.intel.tss2.Tabrmd,bus_type=session"

/bin/bash