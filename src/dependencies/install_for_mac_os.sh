#!/bin/bash
function install_dependency {
    dependency=$1
    if brew ls --versions $dependency | grep -q 1; then
        brew install $dependency
        brew link --overwrite $dependency
    fi
}


echo "Update brew..."
brew update

echo "Install git..."
install_dependency git

echo "Install mercurial..."
install_dependency mercurial

echo "Install python..."
install_dependency python

echo "Install perl..."
install_dependency perl

echo "Install scons..."
install_dependency scons

echo "Install openssl..."
install_dependency openssl

echo "Install postgres..."
install_dependency postgres

echo "Install wget..."
install_dependency wget
