#! /bin/bash

# use to call onshape-to-robot on the document passed as parameter
# when called this will create the below config file in robot/config.json:
# {
#  "documentId": "URL ARG",
#  "outputFormat": "urdf",
#  "addDummyBaseLink": true,
# }
# then, this will call `onshape-to-robot robot` to generate the URDF file
#
# for the URL https://cad.onshape.com/documents/XXX/w/YYY/e/ZZZ,
# the document id is the XXX

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

documentId=$(echo ${1} | sed 's/.*documents\///' | sed 's/\/.*//')
echo "documentId: ${documentId}"
echo "workspaceId: ${workspaceId}"

# Create the config file
echo "{
  \"documentId\": \"${documentId}\",
  \"outputFormat\": \"urdf\",
  \"addDummyBaseLink\": true,
}" > robot/config.json

# Call onshape-to-robot
echo "Running onshape-to-robot..."
onshape-to-robot robot