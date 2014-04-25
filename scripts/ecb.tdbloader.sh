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

rm "$data""$agency".observations.meta.nt
ls -1S "$data"import/*.nt | grep -Ev "(CodeList|Concept|KeyFamily)" | while read i ; do file=$(basename "$i"); DataSetCode=${file%.*}; echo "<$namespace""dataset/$DataSetCode> <http://www.w3.org/2000/01/rdf-schema#seeAlso> <$namespace""data/$agency.observations.ttl> ." >> "$data""$agency".observations.meta.nt ; done
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data""$agency".observations.meta.nt


java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.dbpedia.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.eurostat.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.geonames.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.hr.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.qudt.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.worldbank.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.worldbank.currency.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.transparency.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.bfs.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.fao.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.imf.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.uis.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.exactMatch.frb.currency.nt
java "$JVM_ARGS" tdb.tdbloader --desc="$tdbAssembler" --graph="$namespace"graph/meta "$data"ecb.property.meta.nt

./ecb.tdbstats.sh
#real    136m33.587s
#user    132m4.487s
#sys     6m17.568s
