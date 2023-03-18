#!/bin/sh

# Set the default download directory
downloads_dir="${HOME}/Downloads/bw-export"

# Set the default name for the zip file to be created
zip_file="bw-auto-export-$(date +%Y-%m-%d).zip"

# Set the public GPG key ID to use for encryption
gpg_key="CHANGE IT"

# Check if required command dependencies are installed
check_dependency() {
  if ! command -v "$1" >/dev/null; then
    echo "$2 is not installed. Please install it first."
    exit 1
  fi
}

# Check if Bitwarden CLI is installed
check_dependency "bw" "Bitwarden CLI"

# Check if jq is installed
check_dependency "jq" "jq"

# Check if GPG is installed
check_dependency "gpg" "gpg"

# Check if ZIP is installed
check_dependency "zip" "zip"

# Check if the user is logged in to Bitwarden
status=$(bw status | jq -r '.status')
if [ "$status" != "unlocked" ]; then
  echo "Please log in to Bitwarden and unlock your vault before running this script."
  exit 1
fi

# Prepare temp path
random_string=$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 10 | head -n 1)
random_dir="$downloads_dir/bw_export_temp_$random_string"

# Export Bitwarden passwords
bw sync
echo "Exporting passwords to ${random_dir}/bitwarden_export.json..."
bw export --format json --output "${random_dir}/bitwarden_export.json"

# Get a list of all attachments
attachments=$(bw list items | jq -r '.[] | select(.attachments != null) | .id')

# Download all attachments
for attachment_id in $attachments; do

  item_name=$(bw get item "$attachment_id" | jq -r '.name')
  attachment_names=$(bw get item "$attachment_id" | jq -r '.attachments[].fileName')
    
  while IFS= read -r attachment_name; do
    output_path="${random_dir}/${item_name}/${attachment_name}"
    
    echo "Downloading attachment ${attachment_name} for item ${item_name} to ${output_path}..."
    bw get attachment "${attachment_name}" --itemid "$attachment_id" --output "$output_path"
  done <<< "$attachment_names"
done

echo "All passwords and attachments have been exported to ${downloads_dir}."

# Zip all files in the download folder
cd "$random_dir"
zip -r "$zip_file" .
echo "ZIP file created."

# Encrypt the zip file using GPG
gpg --recipient "$gpg_key" --encrypt "${random_dir}/${zip_file}"
echo "ZIP file has been encrypted."

# Move the encrypted file and delete the original files
mv "$random_dir/$zip_file.gpg" $downloads_dir
bw lock
rm -rf "$random_dir"
echo "All original files have been deleted."

echo "Bitwarden export completed."