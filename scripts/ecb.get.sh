#!/bin/bash

#
#    Author: Sarven Capadisli <info@csarven.ca>
#    Author URI: http://csarven.ca/#i
#

. ./ecb.config.sh

ecbNamespace="http://sdw-ws.ecb.europa.eu/" ;
#ecbItems=(Organisationscheme Dataflow CategoryScheme CodeList Concept MetadataStructureDefinition KeyFamily StructureSet ReportingTaxonomy Process);
MetaDataCodes=(CodeList Concept KeyFamily) ;
DataSetCodes=(BSI ICP SAFE SEC SEE SPF YC) ;


rm "$data""$agency".prov.retrieval.rdf

echo '<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:sdmx="http://purl.org/linked-data/sdmx#">' > "$data""$agency".prov.retrieval.rdf ;

echo "Getting MetaDataCodes:";
for MetaDataCode in "${MetaDataCodes[@]}" ;
    do
sleep 0.1
        dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
        dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;

        downloadURL="$ecbNamespace""$MetaDataCode" ;

        echo "$MetaDataCode" ;

#        wget -c -t 1 --timeout 300 --no-http-keep-alive "$downloadURL" -O "$data""$MetaDataCode".xml

sleep 1
        dtend=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
        dtendd=$(echo "$dtend" | sed 's/[^0-9]*//g') ;


        echo '
        <rdf:Description rdf:about="http://ecb.270a.info/provenance/activity/'$dtstartd'">
            <rdf:type rdf:resource="http://www.w3.org/ns/prov#Activity"/>
            <prov:startedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtstart'</prov:startedAtTime>
            <prov:endedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtend'</prov:endedAtTime>
            <prov:wasAssociatedWith rdf:resource="http://csarven.ca/#i"/>
            <prov:used rdf:resource="https://launchpad.net/ubuntu/+source/wget"/>
            <prov:used rdf:resource="'$downloadURL'"/>
            <prov:generated>
                <rdf:Description rdf:about="http://ecb.270a.info/data/'$MetaDataCode'.xml">
                    <dcterms:identifier>'$MetaDataCode'</dcterms:identifier>
                </rdf:Description>
            </prov:generated>
            <rdfs:label xml:lang="en">Retrieved '$MetaDataCode'</rdfs:label>
            <rdfs:comment xml:lang="en">'$MetaDataCode' retrieved from source and saved to local filesystem.</rdfs:comment>
        </rdf:Description>' >> "$data""$agency".prov.retrieval.rdf ;
    done



echo "Checking Dataflow.xml:" ;
xpath -q -e "/message:Structure/message:Dataflows/structure:Dataflow[not(structure:CategoryRef)]/@id" "$data"Dataflow.xml | perl -pe 's/(.*)(?=id=\")id=\"(.*)(?=\")\"(.*)/$2/' > ecb.data.txt

echo "Getting DataSetCodes:" ;
while read DataSetCode ; do
    if [[ ${DataSetCodes[*]} =~ "$DataSetCode" ]] ;
        then
        echo "  Skipping $DataSetCode for later." ;
    else
sleep 0.1
            dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
            dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;

            downloadURL="$ecbNamespace""GenericData?dataflow=$DataSetCode" ;

            title=$(xpath -q -e "/message:Structure/message:Dataflows/structure:Dataflow[@id = '$DataSetCode']/structure:Name/text()" "$data"Dataflow.xml) ;

            echo "$DataSetCode - $title" ;

#            wget -c -t 1 --timeout 300 --no-http-keep-alive "$downloadURL" -O "$data""$DataSetCode".xml

sleep 1
            dtend=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
            dtendd=$(echo "$dtend" | sed 's/[^0-9]*//g') ;

            echo '
            <rdf:Description rdf:about="http://ecb.270a.info/provenance/activity/'$dtstartd'">
                <rdf:type rdf:resource="http://www.w3.org/ns/prov#Activity"/>
                <prov:startedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtstart'</prov:startedAtTime>
                <prov:endedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtend'</prov:endedAtTime>
                <prov:wasAssociatedWith rdf:resource="http://csarven.ca/#i"/>
                <prov:used rdf:resource="https://launchpad.net/ubuntu/+source/wget"/>
                <prov:used rdf:resource="'$downloadURL'"/>
                <prov:generated>
                    <rdf:Description rdf:about="http://ecb.270a.info/data/'$DataSetCode'.xml">
                        <dcterms:identifier>'$DataSetCode'</dcterms:identifier>
                        <dcterms:title>'$title'</dcterms:title>
                    </rdf:Description>
                </prov:generated>
                <prov:generated rdf:resource="http://ecb.270a.info/data/'$DataSetCode'.xml"/>
                <rdfs:label xml:lang="en">Retrieved '$DataSetCode'</rdfs:label>
                <rdfs:comment xml:lang="en">'$DataSetCode' retrieved from source and saved to local filesystem.</rdfs:comment>
            </rdf:Description>' >> "$data""$agency".prov.retrieval.rdf ;
    fi
done < ecb.data.txt



DataSetCodes=(BSI ICP SAFE SEE SPF) ;
for DataSetCode in "${DataSetCodes[@]}" ; do
    echo "Copying $DataSetCode REF_AREAs";
    xpath -q -e "/message:Structure/message:Dataflows/structure:Dataflow/structure:Constraint/common:CubeRegion/common:Member[@isIncluded = 'true' and common:ComponentRef = 'REF_AREA']/common:MemberValue/common:Value/text()" "$data"/Dataflow."$DataSetCode".xml > "$i".REF_AREA.txt ;
done


echo "Getting some of the DataSetCodes in chunks:" ;
for DataSetCode in "${DataSetCodes[@]}" ; do
    while read j ; do

sleep 0.1
        dtstart=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
        dtstartd=$(echo "$dtstart" | sed 's/[^0-9]*//g') ;

        downloadURL="$ecbNamespace""GenericData?dataflow=$DataSetCode" ;

        title=$(xpath -q -e "/message:Structure/message:Dataflows/structure:Dataflow[@id = '$DataSetCode']/structure:Name/text()" "$data"Dataflow.xml) ;

        echo "$DataSetCode $j - $title" ;


        downloadURL="$ecbNamespace"GenericData?dataflow="$DataSetCode""&amp;"REF_AREA="$j" ;

#        wget -c -t 1 --timeout 300 --no-http-keep-alive "$downloadURL" -O "$data""$u"."$j".xml ;

sleep 1

        dtend=$(date +"%Y-%m-%dT%H:%M:%SZ") ;
        dtendd=$(echo "$dtend" | sed 's/[^0-9]*//g') ;

        echo '
        <rdf:Description rdf:about="http://ecb.270a.info/provenance/activity/'$dtstartd'">
            <rdf:type rdf:resource="http://www.w3.org/ns/prov#Activity"/>
            <prov:startedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtstart'</prov:startedAtTime>
            <prov:endedAtTime rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">'$dtend'</prov:endedAtTime>
            <prov:wasAssociatedWith rdf:resource="http://csarven.ca/#i"/>
            <prov:used rdf:resource="https://launchpad.net/ubuntu/+source/wget"/>
            <prov:used rdf:resource="'$downloadURL'"/>
            <prov:generated>
                <rdf:Description rdf:about="http://ecb.270a.info/data/'$DataSetCode'.'$j'.xml">
                    <dcterms:identifier>'$DataSetCode'</dcterms:identifier>
                    <dcterms:title>'$title'</dcterms:title>
                </rdf:Description>
            </prov:generated>
            <rdfs:label xml:lang="en">Retrieved '$DataSetCode'</rdfs:label>
            <rdfs:comment xml:lang="en">'$DataSetCode' retrieved from source and saved to local filesystem.</rdfs:comment>
        </rdf:Description>' >> "$data""$agency".prov.retrieval.rdf ;

    done < "$data"Dataflow."$DataSetCode".xml.REF_AREA.txt ;
done

echo -e "\n</rdf:RDF>" >> "$data""$agency".prov.retrieval.rdf ;


#echo "Getting some of the DataSetCodes in chunks:" ;
#find "$data" -size 0c -name "*.xml" | while read i ; do file=$(basename "$i"); DataSetCode=${file%.*}; 
#    wget -c -t 1 --timeout 300 --no-http-keep-alive "$ecbNamespace"Dataflow/"$DataSetCode" -O "$data"Dataflow."$$DataSetCode".xml ;
#done

#ecbNamespace="http://sdw-ws.ecb.europa.eu/" ;
#find . -size 0c -name "*.xml" | while read i ; do perl -pe "s/.\/([^\.]*).xml/\$1/" | while read j ; do
#    while read k ; do
#        wget -c -t 1 --timeout 300 --no-http-keep-alive "$ecbNamespace"GenericData?dataflow="$j""&amp;"REF_AREA="$k" -O "$data""$j"."$k".xml
#    done < "$data"Dataflow."$j".xml.REF_AREA.txt
#done ; done
