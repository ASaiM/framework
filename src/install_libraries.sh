#!/bin/bash
current_dir=$PWD

echo -e "(re)install proftpd with specific modules? (y/n) \c"
read 
if [ $REPLY == "y" ]; then
    echo -e "install from sources? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        cd lib/proftpd

        make clean >> tmp/proftpd_make_clean
        if grep "Error" tmp/proftpd_make_clean > /dev/null ; then
            echo "Error with make_clean for proftpd"
            exit
        fi

        ./configure \
            --prefix=/usr/local/ \
            --disable-auth-file \
            --disable-ncurses \
            --disable-ident \
            --disable-shadow \
            --enable-openssl \
            --with-modules=mod_sql:mod_sql_passwd:mod_sql_postgres \
            #--with-includes=/usr/lib/postgresql/9.4/bin/ \
            #--with-libraries=/usr/lib/postgresql/9.4/lib/
            >> proftpd_tmp/configure
        if grep "Error" tmp/proftpd_configure > /dev/null ; then
            echo "Error with configure for proftpd"
            exit
        fi

        make >> tmp/proftpd_make
        if grep "Error" tmp/proftpd_make > /dev/null ; then
            echo "Error with make for proftpd"
            exit
        fi

        sudo make install >> tmp/proftpd_make_install
        if grep "Error" tmp/proftpd_make_install > /dev/null ; then
            echo "Error with make_install for proftpd"
            exit
        fi

        cd $current_dir
fi
sudo cp config/proftpd.conf /usr/local/etc/proftpd.conf >> tmp/proftpd_cp
if grep "Error" tmp/proftpd_cp > /dev/null ; then
    echo "Error with cp for proftpd"
    exit
fi
echo "SQLNamedQuery                   LookupGalaxyUser SELECT \"email, (CASE WHEN substring(password from 1 for 6) = 'PBKDF2' THEN substring(password from 38 for 69) ELSE password END) AS password2,512,512,'"$PWD"/"$1"database/ftp/%U','/bin/bash' FROM galaxy_user WHERE email='%U'\"" >> /usr/local/etc/proftpd.conf 

if ! which git-hg > /dev/null; then
    echo -e "git-hg not found! Install? (y/n) \c"
    read
    if [ $REPLY == "y" ]; then
        cd lib/git-hg
        make >> tmp/git-hg_make
        if grep "Error" tmp/git-hg_make > /dev/null ; then
            echo "Error with make for git-hg"
            exit
        fi

        sudo make install >> tmp/git-hg_make_install
        if grep "Error" tmp/git-hg_make_install > /dev/null ; then
            echo "Error with make install for git-hg"
            exit
        fi

        cd $current_dir
    fi
fi

pip install -r requirements.txt >> tmp/pip_install
if grep "Error" tmp/pip_install > /dev/null ; then
    echo "Error with pip_install"
    exit
fi
