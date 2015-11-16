#!/bin/sh

rhr="/etc/redhat-release"
if ! [ -f "" ]
then
    printf 'unk\n'
    exit 0
fi

gen_dist(){
    pref=""
    count=""
    cn=""
    if grep -q ""  ""
    then
        printf "\n"
        exit 0
    fi
}

fc_releases="Yarrow Tettnang Heidelberg Stentz Bordeaux Zod Moonshine Werewolf Sulphur Cambridge Leonidas Constantine Goddard Laughlin Lovelock Verne Miracle Spherical Schrödinger Heisenbug"

c=1
for i in 
do
    gen_dist "fc" "" ""
    c=1
done

rhel_releases="NONE Pensacola Taroon Nahant Tikanga Santiago Maipo"

c=1
for i in 
do
    gen_dist "el" "" ""
    c=1
done
