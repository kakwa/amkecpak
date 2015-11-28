#!/bin/sh

echo "# meta variables for deps" >Makefile.meta
echo "prepare_deps:" >Makefile.get
cat Makefile | while read line
do
    if echo $line | grep -qe '^VERSION_'
    then
        name=`echo $line | sed "s/VERSION_//" | sed "s/_/\//" | sed "s/_/\//" | sed "s/=.*//"`
        name_under=`echo $line | sed "s/VERSION_//" | sed "s/=.*//"`
        var_version=`echo $line | sed "s/=.*//"`
        var_url=`echo $line | sed "s/VERSION_/URL_/" | sed "s/=.*//"`
        var_path=`echo $line | sed "s/VERSION_/PATH_/" | sed "s/=.*//"`
        name_url=$name

        if echo $name_url | grep -qe '^x/'
        then
            name_url=`echo $name | sed 's|^x/|golang/|'`
            name="golang.org/$name"
        elif echo $name_url | grep -qe 'redis.v2'
        then
            name_url=`echo $name | sed 's|redis.v2|go-redis/redis|'`
            name="gopkg.in/$name"
        elif echo $name_url | grep -qe 'gomail.v2'
        then
            name_url=`echo $name | sed 's|gomail.v2|go-gomail/gomail|'`
            name="gopkg.in/$name"
        elif echo $name_url | grep -qe 'ini.v1'
        then
            name_url=`echo $name | sed 's|ini.v1|go-ini/ini|'`
            name="gopkg.in/$name"
        elif echo $name_url | grep -qe 'macaron.v1'
        then
            name_url=`echo $name | sed 's|macaron.v1|go-macaron/macaron|'`
            name="gopkg.in/$name"
        elif echo $name_url | grep -qe 'bufio.v1'
        then
            name_url=`echo $name | sed 's|bufio.v1|go-bufio/bufio|'`
            name="gopkg.in/$name"
        elif echo $name_url | grep -qe 'alexcesaro/quotedprintable.v3'
        then
            name_url=`echo $name | sed 's|alexcesaro/quotedprintable.v3|alexcesaro/quotedprintable|'`
            name="gopkg.in/$name"
        elif echo $name_url | grep -qe 'anchor_name'
        then
            name=`echo $name | sed 's|sanitized/anchor_name|sanitized_anchor_name|'`
            name_url=$name
            name="github.com/$name"
        else
            name="github.com/$name"
        fi
        echo "$var_url=https://github.com/$name_url/archive/\$($var_version).tar.gz" >> Makefile.meta
        echo "$var_path=$name" >> Makefile.meta
        printf "\t\$(WGS) -u \$($var_url) -o \$(BUILD_DIR)/$name_under-\$(${var_version}).tar.gz\n" >> Makefile.get
        printf "\t\$(GO_EXT) -a \$(BUILD_DIR)/$name_under-\$(${var_version}).tar.gz -n \$($var_path)\n" >>Makefile.get
        printf "\trm \$(BUILD_DIR)/$name_under-\$(${var_version}).tar.gz\n" >> Makefile.get
    fi
done
