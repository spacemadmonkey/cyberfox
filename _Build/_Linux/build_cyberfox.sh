# Cyberfox quick build script
# Version: 1.2
# Release channel

#!/bin/bash

# Set working directory default is ~/Documents
WORKDIR=~/Documents

command -v git >/dev/null 2>&1 || { 
    echo "I require git but it's not installed would you like to install it now!."
    select yn in "Yes" "No"; do
	case $yn in
	    Yes )
	      xterm -e sudo apt-get install git
	    break;;
	    No ) echo "I require git but it's not installed type 'sudo apt-get install git' to manually install it then run me again!." && exit;;
	esac
    done   
 }

cd $WORKDIR

if [ -d "cyberfox" ]; then
  echo "Auto purge uncommited untracked changes"
  cd cyberfox
  git checkout -- .
  echo "Cloning latest cyberfox source files"
  git pull
  echo "Setting branding identity to linux"
  sed -i "s/\(IDENTITY_BRANDING_INTEL *= *\).*/\1/" $WORKDIR/cyberfox/build/defines.sh
  sed -i "s/\(IDENTITY_BRANDING_LINUX *= *\).*/\11/" $WORKDIR/cyberfox/build/defines.sh 
  cd ..
  #Need to redo chmod and set permsissions every pull.
  echo "Changing chmod of cyberfox repository to 777"
  chmod -R 777 cyberfox 
  cd cyberfox
else
  echo "Downloading cyberfox source repository"
  git clone https://github.com/InternalError503/cyberfox.git
  echo "Changing chmod of cyberfox repository to 777"
  chmod -R 777 cyberfox
  echo "mozconfig does not exist copying pre-configured to cyberfox root"
  cp -r $WORKDIR/cyberfox/_Build/_Linux/mozconfig $WORKDIR/cyberfox/
  echo "Setting branding identity to linux"
  sed -i "s/\(IDENTITY_BRANDING_INTEL *= *\).*/\1/" $WORKDIR/cyberfox/build/defines.sh
  sed -i "s/\(IDENTITY_BRANDING_LINUX *= *\).*/\11/" $WORKDIR/cyberfox/build/defines.sh
  cd cyberfox
fi

echo "Do you wish to build cyberfox now?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
	  if [ -d $WORKDIR/obj64 ]; then
	    echo "Old ojb64 build output found! would you like to remove it now ?"
	      select yn in "Yes" "No"; do
		  case $yn in
		      Yes ) rm -rvf $WORKDIR/obj64; break;;
		      No ) break;;
		  esac
	      done
	  fi
        ./mach build; break;;
        No ) break;;
    esac
done

echo "Do you wish to package cyberfox now?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) ./mach package; break;;
        No ) break;;
    esac
done