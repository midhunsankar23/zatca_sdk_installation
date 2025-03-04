#!/bin/zsh

# # Clear previous configurations
# unset FATOORA_HOME
# unset SDK_CONFIG

# Set SDK root directory (where install.sh is located)
export FATOORA_HOME=$(cd "$(dirname "$0")" && pwd -P)

# Configure shell
user_shell=$(basename "$SHELL")
case $user_shell in
  zsh)  config_file=~/.zshrc ;;
  bash) config_file=~/.bashrc ;;
  *)    config_file=~/.bash_profile ;;
esac

# Add paths only if not already present
path_entry="export PATH=\$PATH:$FATOORA_HOME/Apps"
if ! grep -qF "$path_entry" "$config_file"; then
  echo "$path_entry" >> "$config_file"
fi

echo "export FATOORA_HOME=$FATOORA_HOME" >> "$config_file"
echo "export SDK_CONFIG=$FATOORA_HOME/Configuration/config.json" >> "$config_file"

# Source updated config
source "$config_file"

# Generate config.json with correct paths
cd "$FATOORA_HOME/Configuration" || exit 1

jq -n '{
  "xsdPath": $one,
  "enSchematron": $two,
  "zatcaSchematron": $thr,
  "certPath": $fou,
  "privateKeyPath": $fiv,
  "pihPath": $six,
  "inputPath": $sev,
  "usagePathFile": $eight
}' \
--arg one "$FATOORA_HOME/Data/Schemas/xsds/UBL2.1/xsd/maindoc/UBL-Invoice-2.1.xsd" \
--arg two "$FATOORA_HOME/Data/Rules/schematrons/CEN-EN16931-UBL.xsl" \
--arg thr "$FATOORA_HOME/Data/Rules/schematrons/20210819_ZATCA_E-invoice_Validation_Rules.xsl" \
--arg fou "$FATOORA_HOME/Data/Certificates/cert.pem" \
--arg fiv "$FATOORA_HOME/Data/Certificates/ec-secp256k1-priv-key.pem" \
--arg six "$FATOORA_HOME/Data/PIH/pih.txt" \
--arg sev "$FATOORA_HOME/Data/Input" \
--arg eight "$FATOORA_HOME/Configuration/usage.txt" > config.json

cd ..

echo "Installation complete. Verify with:"
echo "java -jar Apps/zatca-einvoicing-sdk-238-R3.4.0.jar --version"
