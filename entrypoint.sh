#!/bin/bash

# Script to call onshape-to-robot on the document passed as parameter
# Usage: ./entrypoint.sh [options] <URL>
# Options:
#   -h, --help            Show help message and exit
#   -a, --assembly NAME   Specify the assembly name
#   -f, --isaac-fix       Apply Isaac fix to the URDF file

show_help() {
  echo "Usage: $0 [options] <URL>"
  echo ""
  echo "Options:"
  echo "  -h, --help            Show this help message and exit"
  echo "  -a, --assembly NAME   Specify the assembly name"
  echo "  -f, --isaac-fix       Apply Isaac fix to the URDF file"
}

assemblyName=""
isaacFix=false

# Parse CLI arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -h|--help) show_help; exit 0 ;;
    -a|--assembly) assemblyName="$2"; shift ;;
    -f|--isaac-fix) isaacFix=true ;;
    *) url="$1" ;;
  esac
  shift
done

if [ -z "$url" ]; then
  echo "Error: URL is required"
  show_help
  exit 1
fi

# Function to create config file
create_config() {
  documentId=$(echo ${url} | sed 's/.*documents\///' | sed 's/\/.*//')
  echo "documentId: ${documentId}"

  config="{
    \"documentId\": \"${documentId}\",
    \"outputFormat\": \"urdf\",
    \"addDummyBaseLink\": true"
  if [ -n "$assemblyName" ]; then
    config+=",\n  \"assemblyName\": \"${assemblyName}\""
  fi
  config+="\n}"

  echo -e $config > robot/config.json
}

# Check if robot/config.json exists
if [ -f robot/config.json ]; then
  echo "robot/ already exists. Do you want to overwrite it? This will clear all files into it. (y/n)"
  read answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Overwriting robot/"
    rm -rf robot
    mkdir -p robot
    create_config
  else
    echo "Reusing existing config file..."
  fi
else
  mkdir -p robot
  create_config
fi

# Call onshape-to-robot
echo "Running onshape-to-robot..."
onshape-to-robot robot

# Apply Isaac fix if requested
if [ "$isaacFix" = true ]; then
  echo "Applying Isaac fix..."
  sed -i 's|package:///|package://|g' robot/robot.urdf
fi
