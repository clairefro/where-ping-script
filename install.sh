#!/bin/bash

# Set the destination directory
destination_dir="$HOME/.where"

# Create the destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Copy the contents of the current directory to the destination directory
cp -r * "$destination_dir"

echo "Contents copied to $destination_dir"