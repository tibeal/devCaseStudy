# !/bin/bash

# If receives an argument create a new scract org with that name, for example InitScratchOrg.sh FL-XXXX
while getopts ":n:" opt; do
  case $opt in
    n) n_inp="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# If receives an argument create a new scract org with that name, for example InitScratchOrg.sh FL-XXXX
if [ $n_inp ]
then
    echo "Creating scratch org" &&
    timestamp=$(gdate +%s%N) &&
    org_id=$(printf "%x" ${timestamp}) &&
    sf org create scratch -f config/project-scratch-def.json --duration-days 15 -a $n_inp --name="scratchOrg" --target-dev-hub tleal-dev-hub --description="devCaseStudy: $n_inp" --username="so_$org_id@$n_inp.org" --async -w 60 -d &&
    echo "Waiting for org" && sleep 40 &&
    sf org resume scratch --use-most-recent &&
    echo "Generating Password" &&
    sf org generate password -o $n_inp &&
    echo "Saving Credentials" &&
    sf org display user --target-org $n_inp > .local/currentOrg.txt &&
    code -r .local/currentOrg.txt
fi &&

# Push code to Org
sf project deploy start -c -w 60;

# Assign Permission Set to user
sf org assign permset --name devCaseStudyPS;