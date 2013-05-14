#!/bin/bash
# script to edit the enctypted password file
FILE=${1:-passwords.enc}
tmpfile=$$

if [ ! -e $FILE ]
then
  echo "$FILE doesn't exist"
  exit 1
fi
echo "checking were up to date"
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
openssl aes-256-cbc -d -a -in $FILE -k $password -out $tmpfile.decrypt
cp $tmpfile.decrypt $tmpfile.decrypt.orig
$EDITOR $tmpfile.decrypt
if diff -qs $tmpfile.decrypt $tmpfile.decrypt.orig
then
  echo "no changes detected"
else
  openssl aes-256-cbc -a -salt -in $tmpfile.decrypt -out $FILE -k $password
  if [ -e .svn ]
  then
    svn ci $FILE
  fi
  if [ -e .git ]
  then
    git commit $FILE
  fi
fi

rm $tmpfile.de*
