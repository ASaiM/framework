#!/usr/bin/env bash
. src/misc.sh

echo "Install dependencies"
echo "===================="

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "OS: MacOSX"
    $src_install_dependencies/install_for_mac_os.sh
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    if cat /etc/*-release | grep "debian"; then
        $src_install_dependencies/install_for_debian.sh
    else
        $src_install_dependencies/install_for_rhel.sh
    fi
else
    echo "Unknow OS"
fi
echo ""