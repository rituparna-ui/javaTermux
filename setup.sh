#!/data/data/com.termux/files/usr/bin/bash

#
# Setup script
# You shouldn't run this script manually
#

GIST_URL=https://gist.githubusercontent.com/simonesestito/89bb66e6e08b8662a40fc42b822090e6/raw/java.sh
SH_LOCAT=~/.java.sh

echo Downloading files...
curl $GIST_URL \
    > $SH_LOCAT \
    2> /dev/null
chmod +x $SH_LOCAT

ALIAS_STR="alias java=$SH_LOCAT"
if grep -E "^$ALIAS_STR$" ~/.bashrc > /dev/null; then
    echo Alias set skipped.
else
    echo Settings Bash alias...
    echo "alias java=$SH_LOCAT" >> ~/.bashrc
fi

echo Installing packages...
pkg install -y \
    ecj \
    dx \
    > /dev/null \
    2>&1

# DONE
echo
echo "----------"
echo
echo "Java Termux script installed"
echo -e "\033[1mRestart Termux to use it.\033[0m"
echo
echo -e "\033[1mUsage: java <file list>\033[0m"
echo "Example: java Main.java ClassA.java"
echo
echo "----------"
echo
