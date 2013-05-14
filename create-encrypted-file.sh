#!/bin/bash
# script to create an encrypted file
FILE=$1
tmpfile=$$

# bail out if the file already exists. 
if [ -e $FILE ]
then
echo "File already exists. Chickening out of changing it."
exit
fi

$EDITOR $tmpfile.decrypt
openssl aes-256-cbc -a -salt -in $tmpfile.decrypt -out $FILE
if [ -e .svn ]
then
svn add $FILE
svn ci $FILE
fi
if [ -e .git ]
then
git add $FILE
git commit $FILE
fi
rm $tmpfile.de* 
