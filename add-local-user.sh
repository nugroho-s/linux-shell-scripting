#!/bin/bash

# Create new account

if [[ "$UID" -ne "0" ]]
then
    echo 'need root access'
    exit 1
fi

read -p "enter username: " USERNAME
read -p "enter full name: " FULL_NAME
read -p "enter password: " PASSWORD

useradd -c "${FULL_NAME}" -m $USERNAME
if [[ "${?}" -ne "0" ]]
then
    echo "failed to create user $USERNAME"
    exit 1
else
    echo "user $USERNAME successfully created"
fi

echo $PASSWORD | passwd --stdin $USERNAME
passwd -e $USERNAME
if [[ "${?}" -ne "0" ]]
then
    echo "failed to change password $USERNAME"
    exit 1
else
    echo "user $USERNAME password changed"
fi

echo "username: $USERNAME"
echo "password: $PASSWORD"
echo "hostname: $(hostname)"