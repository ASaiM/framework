#!/usr/bin/env bash
. src/misc.sh

echo "Update brew..."
brew update

echo "Install git..."
install_mac_dependency git

echo "Install mercurial..."
install_mac_dependency mercurial

echo "Install python..."
install_mac_dependency python

echo "Install perl..."
install_mac_dependency perl

echo "Install scons..."
install_mac_dependency scons

echo "Install openssl..."
install_mac_dependency openssl

echo "Install postgres..."
install_mac_dependency postgres

echo "Install wget..."
install_mac_dependency wget

#echo "Install gcc48..."
#sudo port selfupdate
#sudo port install gcc48
