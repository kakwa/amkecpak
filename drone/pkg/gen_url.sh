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
            #name="golang.org/$name"
        elif echo $name_url | grep -qe 'code.google.com/p/go.crypto'
        then
            name_url=`echo $name | sed 's|code.google.com/p/go.crypto|github.com/golang/crypto|'`
            #name="/$name"
        elif echo $name_url | grep -qe 'yaml.v2'
        then
            name_url=`echo $name | sed 's|gopkg.in/yaml.v2|github.com/go-yaml/yaml|'`
        elif echo $name_url | grep -qe 'gopkg.in/bluesuncorp/validator.v5'
        then
            name_url=`echo $name | sed 's|gopkg.in/bluesuncorp/validator.v5|github.com/bluesuncorp/validator|'`
        elif echo $name_url | grep -qe 'gopkg.in/gorp.v1'
        then
            name_url=`echo $name | sed 's|gopkg.in/gorp.v1|github.com/go-gorp/gorp|'`
        fi
        echo "$var_url=https://$name_url/archive/\$($var_version).tar.gz" >> Makefile.meta
        echo "$var_path=$name" >> Makefile.meta
        printf "\t\$(WGS) -u \$($var_url) -o \$(BUILD_DIR)/$file-\$(${var_version}).tar.gz\n" >> Makefile.get
        printf "\t\$(GO_EXT) -a \$(BUILD_DIR)/$file-\$(${var_version}).tar.gz -n \$($var_path)\n" >>Makefile.get
        printf "\trm \$(BUILD_DIR)/$file-\$(${var_version}).tar.gz\n" >> Makefile.get
    fi
done
