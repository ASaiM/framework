#!/bin/bash
current_dir=$PWD

echo -e "(re)install proftpd with specific modules? (y/n) \c"
read 
if [ $REPLY == "y" ]; then
    echo -e "install from sources? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        cd lib/proftpd
        make clean
        ./configure \
            --prefix=/usr/local/ \
            --disable-auth-file \
            --disable-ncurses \
            --disable-ident \
            --disable-shadow \
            --enable-openssl \
            --with-modules=mod_sql:mod_sql_passwd:mod_sql_postgres 
            #--with-includes=/usr/lib/postgresql/9.4/bin/ \
            #--with-libraries=/usr/lib/postgresql/9.4/lib/
        make
        make install
        cd $current_dir
    else
        sudo apt-get install proftpd-basic \
            proftpd-mod-pgsql \
            proftpd-mod-mysql 
        echo 'LoadModule mod_sql.c' >> /etc/proftpd/modules.conf 
        echo 'LoadModule mod_sql_passwd.c' >> /etc/proftpd/modules.conf 
        echo 'LoadModule mod_sql_postgres.c' >> /etc/proftpd/modules.conf
        cp config/proftpd.conf /etc/proftpd/proftpd.conf
        echo "SQLNamedQuery                   LookupGalaxyUser SELECT \"email, (CASE WHEN substring(password from 1 for 6) = 'PBKDF2' THEN substring(password from 38 for 69) ELSE password END) AS password2,512,512,'"$PWD"/"$1"database/ftp/%U','/bin/bash' FROM galaxy_user WHERE email='%U'\"" >> /usr/local/etc/proftpd.conf 
    fi
fi
cp config/proftpd.conf /usr/local/etc/proftpd.conf
echo "SQLNamedQuery                   LookupGalaxyUser SELECT \"email, (CASE WHEN substring(password from 1 for 6) = 'PBKDF2' THEN substring(password from 38 for 69) ELSE password END) AS password2,512,512,'"$PWD"/"$1"database/ftp/%U','/bin/bash' FROM galaxy_user WHERE email='%U'\"" >> /usr/local/etc/proftpd.conf 

if ! which git-hg > /dev/null; then
    echo -e "git-hg not found! Install? (y/n) \c"
    read
    if [ $REPLY == "y" ]; then
        cd lib/git-hg
        make
        sudo make install
        cd $current_dir
    fi
fi

pip install -r requirements.txt

