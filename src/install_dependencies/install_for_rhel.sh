#!/usr/bin/env bash

echo "Update yum..."
sudo yum update

echo "Install git..."
sudo yum install git

echo "Install mercurial..."
sudo yum install mercurial

echo "Install python..."
sudo yum install python
sudo yum install python-dev python-pip
sudo yum install libffi-dev libssl-dev libxml2-dev libxslt1-dev

echo "Install perl..."
sudo yum install perl

echo "Install scons..."
sudo yum install scons

echo "Install openssl..."
sudo yum install openssl

echo "Install postgres..."
sudo yum install postgres*
sudo yum install libpq-dev

echo "Install wget..."
sudo yum install wget

echo "Install curl..."
sudo yum install curl