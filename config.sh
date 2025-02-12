#!/bin/bash

# Original string with a placeholder
original_string="REPLACE_STRING="static const char* process_to_filter = "[TARGET]";""

# Ask the user for the name
read -p "Enter name of process you want to hide: " user_input

# Use parameter expansion to replace only the [NAME] part
modified_string="${original_string//[TARGET]/$user_input}"

echo "File modified."
