#!/bin/sh

rhr="/etc/redhat-release"
if ! [ -f "$rhr" ]
then
    printf 'unk\n'
    exit 0
fi

gen_dist(){
    pref="$1"
    count="$2"
    cn="$3"
    if grep -q "$cn"  "$rhr"
    then
        printf "${pref}${count}\n"
        exit 0
    fi
}

fc_releases="Yarrow Tettnang Heidelberg Stentz Bordeaux Zod Moonshine Werewolf Sulphur Cambridge Leonidas Constantine Goddard Laughlin Lovelock Verne Miracle Spherical Schrödinger Heisenbug"

c=1
for i in $fc_releases
do
    gen_dist "fc" "$c" "$i"
    c=$(( $c + 1 ))
done

rhel_releases="NONE Pensacola Taroon Nahant Tikanga Santiago Maipo"

c=1
for i in $rhel_releases
do
    gen_dist "el" "$c" "$i"
    c=$(( $c + 1 ))
done
