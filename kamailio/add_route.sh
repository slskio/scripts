#!/bin/sh

for i in `cat route.csv`
do
	did=$(echo $i | cut -d , -f2)
	setid=$(echo $i | cut -d , -f3)

	# Add a new mtree record to database
	kamcli mtree db-add mtree $did $setid
done

# Reload MTREE
kamcli mtree reload srt
