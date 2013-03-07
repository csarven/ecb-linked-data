#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./ecb.config.sh


dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;

echo Exporting "$data"ecb.metadata.archive."$dtstartd".ttl ;
java "$JVM_ARGS" tdb.tdbquery --time --desc="$tdbAssembler" --results=turtle 'CONSTRUCT { ?s ?p ?o } WHERE { GRAPH <'"$namespace"'graph/void> { ?s ?p ?o } }' > "$data"ecb.metadata.archive."$dtstartd".nt

echo Exporting "$data"ecb.prov.archive.ttl ;
java "$JVM_ARGS" tdb.tdbquery --time --desc="$tdbAssembler" --results=turtle 'CONSTRUCT { ?s ?p ?o } WHERE { ?s a <http://www.w3.org/ns/prov#Activity> . ?s ?p ?o . }' > "$data"ecb.prov.archive.nt

