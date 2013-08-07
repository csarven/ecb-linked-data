#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./ecb.config.sh

echo "Removing $db";
rm -rf "$db";

ls -1S "$data"import/*.nt | grep -vE "(CodeList|Concept|KeyFamily).nt" | while read i ; do file=$(basename "$i"); DataSetCode=${file%.*}; java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/"$DataSetCode" "$i"; done ;

java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"import/CodeList.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"import/Concept.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"import/KeyFamily.nt

java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.prov.archive.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.prov.retrieval.rdf


#rapper -g ecb-bfs-location.trigrams.accept.nt > /data/ecb-linked-data/data/ecb.exactMatch.bfs.nt
#rapper -g ecb-bfs-location.trigrams.review.nt >> /data/ecb-linked-data/data/ecb.exactMatch.bfs.nt
#rapper -g ecb-dbpedia.country.trigrams.accept.nt > /data/ecb-linked-data/data/ecb.exactMatch.dbpedia.nt
#rapper -g ecb-dbpedia.country.trigrams.review.nt >> /data/ecb-linked-data/data/ecb.exactMatch.dbpedia.nt
#rapper -g ecb-worldbank.country.trigrams.accept.nt > /data/ecb-linked-data/data/ecb.exactMatch.worldbank.nt
#rapper -g ecb-worldbank.country.trigrams.review.nt >> /data/ecb-linked-data/data/ecb.exactMatch.worldbank.nt
#rapper -g ecb-transparency.country.trigrams.accept.nt > /data/ecb-linked-data/data/ecb.exactMatch.transparency.nt
#rapper -g ecb-transparency.country.trigrams.review.nt >> /data/ecb-linked-data/data/ecb.exactMatch.transparency.nt

java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.worldbank.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.transparency.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.dbpedia.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.bfs.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.fao.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.imf.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.property.meta.nt

./ecb.tdbstats.sh
#real    136m33.587s
#user    132m4.487s
#sys     6m17.568s
