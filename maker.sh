#!/bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

echo "--------------------------------------------------------------"
echo -e "$BCyan kryptofranc Maker: version 1.0"
echo -e "$BBlue maker unix/win64/win32/mac"
echo -e "$BGreen  win       compile for Windows os "
echo -e "  unix      compile for Unix (default)"
echo -e "  win64      compile for windows 64 bits"
echo -e "  win32      compile for windows 32 bits"
echo -e "  mac      compile for MAC"
echo
echo -e "$BYellow example: ./maker.sh unix"
echo "  ->will compile for unix"
echo "--------------------------------------------------------------"
echo -e $Color_Off


# initialize the internal variables
OS="unix"

# test the number max of options
if [ "$#" = 0 ] ; then
   	echo -e "$BRed no option selected: exiting..."
	echo -e $Color_Off
        exit;
fi
if [ "$#" -ge 5 ]  ; then
	echo -e "$BRed Error: too many parameters (5 max)"
	echo -e $Color_Off
	exit
fi

ALL="no"
INSTALL="no"

# loop through all the options and set the corresponding variables
while [ "$1" != "" ]; do
	case $1 in
	    install)
            INSTALL="yes"
        ;;
        all)
            ALL="yes"
        ;;
		unix)
			OS="unix"
	    ;;
	    win64)
	    	OS="win64"
	    ;;
	    win32)
	    	OS="win32"
	    ;;
	    help)
	    	exit
	    ;;
	esac
	shift
done

$MOD="-u"

echo -e "$BYellow --------------------------------------------------"
echo " *** EXECUTING SCRIPT WITH OPTIONS ***"
echo
echo "OS option $OS"
echo "INSTALL option $INSTALL"
echo "ALL option $ALL"
echo "--------------------------------------------------"
echo -e $Color_Off


if [ $OS = "unix" ]; then

	if [ $INSTALL = "yes" ]; then
		sudo apt-get install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
		sudo apt-get install libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev 
		
		sudo apt-get install software-properties-common
		sudo add-apt-repository ppa:bitcoin/bitcoin
		sudo apt-get update
		sudo apt-get install libdb4.8-dev libdb4.8++-dev
		
		sudo apt-get install libminiupnpc-dev
		sudo apt-get install libzmq3-dev
		sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
    fi
    if [ $ALL = "yes" ]; then
        cd kryptofranccore
        ./autogen.sh
        ./configure --disable-tests --disable-bench
        cd ..
    fi
    cd kryptofranccore
    make
    cd ..
	echo -e "$BYellow --------------------------------------------------"
	echo -e "$BGreen PACKAGING will install all in binaries folder"
	echo -e $Color_Off
	
	sudo mkdir binaries
	sudo mkdir binaries/unix
	sudo mv kryptofranccore/src/qt/bitcoin-qt kryptofranccore/src/qt/kyf-qt
	sudo cp assets/android-icon-192x192.png binaries/unix/kryptofranc.png
	sudo cp assets/android-icon-192x192.png /usr/share/app-install/icons/kryptofranc.png
	sudo cp assets/kyf-qt.desktop binaries/unix/kyf-qt.desktop
	sudo cp kryptofranccore/src/kyfd binaries/unix/kyfd	
	sudo cp kryptofranccore/src/kyf-tx binaries/unix/kyf-tx
	sudo cp kryptofranccore/src/kyf-cli binaries/unix/kyf-cli
	sudo cp kryptofranccore/src/qt/kyf-qt binaries/unix/kyf-qt
	sudo cp kryptofranccore/src/qt/kyf-qt /usr/bin/kyf-qt
fi

if [ $OS = "win64" ]; then

	if [ $INSTALL = "yes" ]; then
		sudo apt update
		sudo apt upgrade
		sudo apt install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl git
		sudo apt install nsis
		sudo apt install g++-mingw-w64-x86-64
		echo -e "$BGreen select (1) Posix "
		echo -e $Color_Off
		sudo update-alternatives --config x86_64-w64-mingw32-g++
		PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g') # strip out problematic Windows %PATH% imported var
		sudo chmod -R 777 kryptofranccore
		cd kryptofranccore
		cd depends
		#secret to insure the compilation will work 
		PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
		# -i or it will stop compiling
		make HOST=x86_64-w64-mingw32 -i
		cd ..
		cd ..
		
    fi
    if [ $ALL = "yes" ]; then
        cd kryptofranccore
		./autogen.sh
		CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/ --disable-tests --disable-bench
		cd ..
	fi
	echo -e "$BYellow --------------------------------------------------"
	echo -e "$BGreen PACKAGING will install all in d:/kryptofranc"
	echo -e $Color_Off
	cd kryptofranccore
	# option -i or it will stop compiling
	make install DESTDIR=/binaries/win64/ -i
    cd ..
	echo -e "$BYellow --------------------------------------------------"
	echo -e "$BGreen PACKAGING will install all in binaries folder"
	echo -e $Color_Off
	sudo mkdir binaries
	sudo mkdir binaries/win64
	sudo mv 'kryptofranccore/src/qt/bitcoin-qt.exe' 'kryptofranccore/src/kyf-qt.exe'
	sudo cp 'kryptofranccore/src/kyfd.exe' 'binaries/win64/kyfd.exe'
	sudo cp 'kryptofranccore/src/kyf-tx.exe' 'binaries/win64/kyf-tx.exe'
	sudo cp 'kryptofranccore/src/kyf-cli.exe' 'binaries/win64/kyf-cli.exe'
	sudo cp 'kryptofranccore/src/qt/kyf-qt.exe' 'binaries/win64/kyf-qt.exe'
	
	
	cd ..
fi




