#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. $HOME/lodstats-env/bin/activate

. ./ecb.config.sh
#cd "$data"import
#rm *stats*


#echo "Creating LODStats for Datasets"
#find "$data"import/*.nt -name "[!CodeList|Concept|KeyFamily|ecb.|meta.]*" | while read i ; do lodstats -val "$i" > "$i".stats.ttl ; echo "Created $i.stats.ttl" ; done;
#652 minutes

echo Exporting "$namespace"graph/meta ;
java "$JVM_ARGS" tdb.tdbquery --time --desc="$tdbAssembler" --results=n-triples 'CONSTRUCT { ?s ?p ?o } WHERE { GRAPH <'"$namespace"'graph/meta> { ?s ?p ?o } }' > "$data"import/meta.nt ;

echo Creating LODStats "$data"import/meta.nt.stats.ttl ;
lodstats -val "$data"import/meta.nt > "$data"import/meta.nt.stats.ttl ;

echo "Fixing URI for meta stats" ;
find "$data"import/*stats.ttl -name "[!ecb.]*" | while read i ; do sed -ri 's/<file:\/\/\/data\/'"$agency"'-linked-data\/data'"$state"'\/import\/([^\.]*)\.nt/<http:\/\/'"$agency"'.270a.info\/dataset\/\1/g' "$i" ; done ;


