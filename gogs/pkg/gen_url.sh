#!/bin/sh

echo "# meta variables for deps" >Makefile.meta
echo "prepare_deps:" >Makefile.get
cat Makefile | while read line
do
    if echo $line | grep -qe '^VERSION_'
    then
        name=`echo $line | sed "s/VERSION_//" | sed "s/=.*//"`
        name_under=`echo $line | sed "s/VERSION_//" | sed "s/=.*//"`
        var_version=`echo $line | sed "s/=.*//"`
        var_url=`echo $line | sed "s/VERSION_/URL_/" | sed "s/=.*//"`
        var_path=`echo $line | sed "s/VERSION_/PATH_/" | sed "s/=.*//"`
        name_url=$name
        file=`echo $name |sed 's/\//-/g'`

        if echo $name_url | grep -qe '^golang.org/x'
        then
            name_url=`echo $name | sed 's|^golang.org/x|github.com/golang|'`

        elif echo $name_url | grep -qe 'redis.v2'
        then
            name_url=`echo $name | sed 's|redis.v2|go-redis/redis|'`

        elif echo $name_url | grep -qe 'ini.v1'
        then
            name_url=`echo $name | sed 's|ini.v1|go-ini/ini|'`

        elif echo $name_url | grep -qe 'macaron.v1'
        then
            name_url=`echo $name | sed 's|macaron.v1|go-macaron/macaron|'`

        elif echo $name_url | grep -qe 'bufio.v1'
        then
            name_url=`echo $name | sed 's|bufio.v1|go-bufio/bufio|'`

        elif echo $name_url | grep -qe 'alexcesaro/quotedprintable.v3'
        then
            name_url=`echo $name | sed 's|alexcesaro/quotedprintable.v3|alexcesaro/quotedprintable|'`

        elif echo $name_url | grep -qe 'gomail.v2'
        then
            name_url=`echo $name | sed 's|gomail.v2|go-gomail/gomail|'`

        elif echo $name_url | grep -qe 'ldap.v2'
        then
            name_url=`echo $name | sed 's|ldap.v2|go-ldap/ldap|'`

        elif echo $name_url | grep -qe 'asn1-ber.v1'
        then
            name_url=`echo $name | sed 's|asn1-ber.v1|go-asn1-ber/asn1-ber|'`

        fi

        if echo $name_url | grep -qe 'gopkg.in'
        then
            name_url=`echo $name_url | sed 's|gopkg.in|github.com|'`
        fi

        echo "$var_url=https://$name_url/archive/\$($var_version).tar.gz" >> Makefile.meta
        echo "$var_path=$name" >> Makefile.meta
        printf "\t\$(WGS) -u \$($var_url) -o \$(BUILD_DIR)/$file-\$(${var_version}).tar.gz\n" >> Makefile.get
        printf "\t\$(GO_EXT) -a \$(BUILD_DIR)/$file-\$(${var_version}).tar.gz -n \$($var_path)\n" >>Makefile.get
        printf "\trm \$(BUILD_DIR)/$file-\$(${var_version}).tar.gz\n" >> Makefile.get
    fi
done
