#!/bin/bash

#sed -i 's/\r//' filename
#set Hosts Inventory
#export ANSIBLE_INVENTORY=$PWD/uat_hosts_ansible
export ANSIBLE_INVENTORY=$PWD/inventory/sample-inventory
#source $(dirname "${BASH_SOURCE[0]}")/set.sh
#example
#ansible-playbook playbooks/release.yml --extra-vars "hosts=vipers user=starbuck"

#to Avoid adding the hosts to known hosts
export ANSIBLE_HOST_KEY_CHECKING=False

#ssh-keyscan fqdn/ip/shortname >> ~/.ssh/known_hosts

usage_help(){
	echo "Usage: for this script"
	echo "####### Get Help Usage#########"
	echo "     "
	echo "bootstrap.sh --help"
	echo "     "
	echo "####### List of Available Tags to Run #########"
	echo "     "
	echo "bootstrap.sh --list-tags"
	echo "     "
	echo "####### Listing all Tasks for all Plays/all tags #########"
	echo "     "
	echo "bootstrap.sh --list-tasks"
	echo "     "
	echo "####### Dry Run for Given Tags #########"
	echo "     "
	echo "bootstrap.sh tagname1,tagname2,...,tagnamen --check"
	echo "     "
	echo "####### Actual Install Run for Given Tags #########"
	echo "     "
	echo "bootstrap.sh tagname1,tagname2,...,tagnamen"
	echo "or"
	echo "bootstrap.sh tagname1,tagname2,...,tagnamen --run"
	echo "     "
	exit 0
}

if [ $# -eq 0 ] || [ $1 == "--help" ] || [ $1 == "help" ] || [ $1 == "-h" ] || [ $1 == "-help" ]
then
	usage_help
fi


if [ $1 == "--list-tags" ] || [ $1 == "--list-tasks" ];then
	if [ $1 == "--list-tags" ];then
		echo "##########################################################################"
		echo "################### List of Available Tags to Run ########################"
		echo "##########################################################################"
		ansible-playbook playbooks/validate-nodes.yml --list-tags --extra-vars "user=ec2-user"
		exit 0
	elif [ $1 == "--list-tasks" ];then
		echo "##########################################################################"
		echo "########## Listing all Tasks for all Plays/all tags     ##################"
		echo "##########################################################################"
		ansible-playbook playbooks/validate-nodes.yml --extra-vars "user=ec2-user" --list-tasks
		exit 0
	fi
elif [[ $1 == "--check" ]]; then
	usage_help
elif [[ $2 == "--list-tasks" ]]; then
	echo "##########################################################################"
	echo "####################### Listing all Tasks for Given Tag###################"
	echo "##########################################################################"
	ansible-playbook validate-nodes.yml --extra-vars "user=ec2-user" --tags $1 --list-tasks
elif [[ $2 == "--check" ]]; then
	echo "##########################################################################"
	echo "####################### Dry Run for Given Tags      ######################"
	echo "##########################################################################"
	ansible-playbook playbooks/validate-nodes.yml --extra-vars "user=ec2-user" --tags $1 --check
elif [[ $1 != "--check" ]] && [[ $2 != "--check" ]]; then
	echo "##########################################################################"
	echo "########### Actual Install Run for Given Tags ############################"
	echo "##########################################################################"
	ansible-playbook playbooks/validate-nodes.yml --extra-vars "user=ec2-user" --tags $1
else
	usage_help
fi