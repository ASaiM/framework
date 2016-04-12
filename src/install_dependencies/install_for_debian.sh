#!/usr/bin/env bash

echo "Update apt-get..."
sudo apt-get update

echo "Install git..."
sudo apt-get install git

echo "Install mercurial..."
sudo apt-get install mercurial

echo "Install python and pip..."
sudo apt-get install python
sudo apt-get install python-dev python-pip

echo "Install perl..."
sudo apt-get install perl

echo "Install scons..."
sudo apt-get install scons

echo "Install openssl..."
sudo apt-get install openssl

echo "Install postgres..."
sudo apt-get install postgresql postgresql-contrib
sudo apt-get install libpq-dev

echo "Install wget..."
sudo apt-get install wget

echo "Install curl..."
sudo apt-get install curl


