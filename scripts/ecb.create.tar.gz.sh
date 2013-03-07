#!/bin/bash

. ./ecb.config.sh

cd "$data"
tar -cvzf meta.tar.gz CodeList.rdf Concept.rdf KeyFamily.rdf ecb.*

tar -cvzf data.tar.gz *.rdf --exclude='CodeList.rdf' --exclude='Concept.rdf' --exclude='KeyFamily.rdf' --exclude='ecb.*'

