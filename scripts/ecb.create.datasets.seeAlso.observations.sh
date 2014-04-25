#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./ecb.config.sh

java "$JVM_ARGS" tdb.tdbquery --desc="$tdbAssembler" 'CONSTRUCT { ?dataset <http://www.w3.org/2000/01/rdf-schema#seeAlso> ?observation } WHERE { ?observation <http://purl.org/linked-data/cube#dataSet> ?dataset }' --results=turtle > "$data"$agency".observations.ttl

