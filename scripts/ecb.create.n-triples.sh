#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./ecb.config.sh

rm "$data"import/*.nt ;

DataSetCodes=(CodeList Concept KeyFamily) ;
for DataSetCode in "${DataSetCodes[@]}" ; do ls -1 "$data""$DataSetCode".rdf | while read i ; do rapper -g "$i" > "$data"import/"$DataSetCode".nt ; done ; done


ExcludeDataSetCodes=(BNT) ;
while read DataSetCode ; do
    if [[ ${ExcludeDataSetCodes[*]} =~ "$DataSetCode" ]] ;
        then
            echo "  Skipping $DataSetCode." ;
        else
            for i in "$data""$DataSetCode"*rdf ; do
                rapper -g "$i" >> "$data"import/"$DataSetCode".nt ;
            done
    fi
done < "$data"../scripts/"$agency".data.txt
#real    76m19.024s
#user    72m27.976s
#sys     1m48.451s
