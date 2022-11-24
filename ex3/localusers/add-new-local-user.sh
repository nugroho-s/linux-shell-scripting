#!/bin/bash

# Create new account

if [[ "$UID" -ne "0" ]]
then
    echo 'need root access'
    exit 1
fi

if [[ $# -lt 1 ]]
then
    echo 'usage: add-new-local-user.sh username [comment]'
    exit 1
fi

USERNAME=$1
shift
FULL_NAME=$@
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c47)

SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -c1)
PASSWORD=$PASSWORD$SPECIAL_CHARACTER
echo $PASSWORD

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
