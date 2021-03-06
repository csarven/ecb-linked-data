#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

agency="ecb";
state=""; #".staging" or ''
data="/data/$agency-linked-data/data$state/";
provRetrieval="$data""$agency"".prov.retrieval.rdf";
xslDocument="/home/sarcap/linked-sdmx/scripts/generic.xsl";
namespace="http://$agency.270a.info/";
db="/data/$agency-linked-data/tdb$state/";
tdbAssembler="/usr/lib/fuseki/tdb.$agency$state.ttl";
JVM_ARGS="-Xmx24000M"
javatdbloader="java $JVM_ARGS tdb.tdbloader --desc=$tdbAssembler";
void="/var/www/$agency.270a.info/void$state.ttl";
voidInit="$agency.void.init.ttl";
graphs="/home/sarcap/Graphs/";
dataflow="$data""Dataflow.xml";
