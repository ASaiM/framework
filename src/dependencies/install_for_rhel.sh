#!/bin/bash

echo "Update brew..."
yum update

echo "Install git..."
yum install git

echo "Install mercurial..."
yum install mercurial

echo "Install python..."
yum install python

echo "Install perl..."
yum install perl

echo "Install scons..."
yum install scons

echo "Install openssl..."
yum install openssl

echo "Install postgres..."
yum install postgres*

echo "Install wget..."
yum install wget