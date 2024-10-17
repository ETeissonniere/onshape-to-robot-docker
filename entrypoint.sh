#! /bin/bash

# use to call onshape-to-robot on the document passed as parameter
# if --help or -h show help
# if --assembly NAME or -a NAME, then assemblyName = NAME
#
# when called this will create the below config file in robot/config.json:
# {
#  "documentId": "URL ARG",
#  "outputFormat": "urdf",
#  "addDummyBaseLink": true,
#  "assemblyName": "assemblyName" # only if --assembly NAME or -a NAME is passed
# }
# then, this will call `onshape-to-robot robot` to generate the URDF file
#
# for the URL https://cad.onshape.com/documents/XXX/w/YYY/e/ZZZ,
# the document id is the XXX

show_help() {
  echo "Usage: $0 [options] <URL>"
  echo ""
  echo "Options:"
  echo "  -h, --help            Show this help message and exit"
  echo "  -a, --assembly NAME   Specify the assembly name"
}

assemblyName=""

# Parse CLI arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -h|--help) show_help; exit 0 ;;
    -a|--assembly) assemblyName="$2"; shift ;;
    *) url="$1" ;;
  esac
  shift
done

if [ -z "$url" ]; then
  echo "Error: URL is required"
  show_help
  exit 1
fi

# If robot/config.json already exists, ask the user if they want to continue
if [ -f robot/config.json ]; then
  echo "robot/ already exists. Do you want to overwrite it? This will clear all files into it. (y/n)"
  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "Overwriting robot/"
  else
    echo "Exiting..."
    exit 1
  fi
fi

rm -rf robot
mkdir -p robot

echo "Downloading the robot description from Onshape..."

documentId=$(echo ${url} | sed 's/.*documents\///' | sed 's/\/.*//')
echo "documentId: ${documentId}"

# Create the config file
config="{
  \"documentId\": \"${documentId}\",
  \"outputFormat\": \"urdf\",
  \"addDummyBaseLink\": true"
if [ -n "$assemblyName" ]; then
  config+=",\n  \"assemblyName\": \"${assemblyName}\""
fi
config+="\n}"

echo -e $config > robot/config.json

# Call onshape-to-robot
echo "Running onshape-to-robot..."
onshape-to-robot robot