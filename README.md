# bw-export-tool

While Bitwarden does offer built-in export functionality, it currently does not provide a quick solution to export all your attachments.
This script will help you export your passwords and attachments from your Bitwarden vault and store them in a compressed and GPG-encrypted ZIP file.

## Requirements

 - Bitwarden CLI: Bitwarden command-line interface for interacting with
   your Bitwarden vault and data.    
 - jq: Command-line JSON processor for parsing and manipulating JSON
   data.
 - GPG: GNU Privacy Guard for encrypting and decrypting data.
 - ZIP: Command-line utility for archiving files 

## Installation

**CLI**

To use this script, you will need to have Bitwarden CLI installed on your system. You can download the CLI from [Bitwarden](https://bitwarden.com/help/cli/).

For macOS users, you can install the Bitwarden CLI using [Homebrew](https://brew.sh/) by running the following command:
```
brew install bitwarden-cli
```
**JQ**

You can install `jq` using by running the following command in your terminal:
```
brew install jq
```
**GPG**

MacOS users can install GPG Suite from the [official GPG Tools website](https://gpgtools.org/). 

## Configuration

The following variables can be configured in the script:

-   `downloads_dir`: The directory where the exported files will be stored. The default value is `${HOME}/Downloads/bw-export`. 

Choose the path carefully and ensure the script doesn't delete important files by mistake. The script will create a temporary directory to store exported files before zipping and encrypting them.
-   `zip_file`: The name of the ZIP file that will be created. The default value is `bw-auto-export + date.zip`.
-   `gpg_key`: The public GPG key ID to use for encryption.

Note: To use this script, you must have a GPG key pair generated and the public key imported into your system's keyring. It is also advisable to set the _Ownertrust_ of your key to the maximum level in the Key Details in GPG Tools. Otherwise, you may receive a warning when the encryption part of the script begins.

## Exporting Data Securely
Before using this script, remember that deleted unencrypted files may still be recoverable from your hard drive. It's best to export your passwords to a secure location such as a [VeraCrypt](https://www.veracrypt.fr/en/Home.html) container or [Cryptomator](https://cryptomator.org/) folder if your system doesn't have full disk encryption (like FileVault on macOS). These tools allow you to create encrypted volumes that function like normal folders, but with strong encryption to protect their contents.

Please note that the export tool does not provide any additional security measures beyond standard file deletion. It's your responsibility to set up a secure location where you can safely store sensitive files.

## How to use

1.  Install Bitwarden CLI, jq, and GPG on your system.
2.  Clone or download the repository.
3.  Open the `bw-export-tool.sh` file and modify the default values for `downloads_dir`, `zip_file`, and `gpg_key`.
4.  Log in to your Bitwarden vault from the BW CLI (see instructions [here](https://bitwarden.com/help/cli/#using-email-and-password)).
5.  Unlock your Bitwarden vault (see instructions [here](https://bitwarden.com/help/cli/#unlock)) and remember to export your session key to the `BW_SESSION` environment variable.
6.  Run the `bw-export-tool.sh` script in your terminal in the directory where the script is located: `./bw-export-tool.sh`.
7.  The script will export your passwords to a JSON file and download any attachments associated with your passwords. All files will be compressed into a ZIP file and then encrypted using GPG. The original files will be deleted, and only the compressed and encrypted ZIP file will remain in the specified download directory.

## Disclaimer
The script is provided as is and was made for personal use. Always remember to check backups made by the script and save exported data on safe media.
