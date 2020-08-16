#!/data/data/com.termux/files/usr/bin/bash

#
# HOW TO INSTALL
#
# Run this command in Termux:
#
# curl https://gist.githubusercontent.com/simonesestito/89bb66e6e08b8662a40fc42b822090e6/raw/setup.sh | bash
#

WORKDIR=`mktemp -d`
LAUNCHDIR=`pwd`

status(){
	echo -e "\033[1;32m// $*...\033[0m"
}

stop(){
	echo -e "\033[1;37;41m(!) $*\033[0m"
	clean
	exit 1
}

clean(){
	rm -rf $WORKDIR
}

# Checking files
if [ $# -eq 0 ]; then
	stop Usage: java FILES
fi

for f in $*; {
	if [ ! -f $f ]; then
		stop File $f is missing
	fi
}

status Compiling
ecj $* -d $WORKDIR || stop Compilation error

# Building dex file
cd $WORKDIR
classes=`find * -type f -name '*.class'`
dx --dex --output out.dex $classes \
    2> /dev/null || \
	stop Error building dex file for DalvikVM
cd $LAUNCHDIR

# Startinf
executed=0
exec 5>&1
for f in $classes; {
    clear
    main=`echo $f | cut -f 1 -d '.'`
    output=`dalvikvm -cp $WORKDIR/out.dex $main 2>&1 | tee /dev/fd/5`

    if ! echo "$output" | grep 'Unable to find static main(String' > /dev/null; then
        executed=1
        break
    fi
}
if [ $executed -eq 0 ]; then
    stop "Execution error. Please check that
    - 1 class has a correct main() method
    - it doesn't throw an exception in main()"
fi

clean
