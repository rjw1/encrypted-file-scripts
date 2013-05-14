#!/bin/bash
# script to view an encrypted file
FILE=${1:-passwords.enc}
if [ ! -e $FILE ]
then
  echo "$FILE doesn't exist"
  exit 1
fi
echo "checking we are up to date"
if [ -e .svn ]
then
  svn st
  svn up
fi
if [ -e .git ]
then
  git status
  git pull
fi
echo -n "enter the password:"
read -s password
echo ""
openssl aes-256-cbc -d -a -in $FILE -k $password |more


