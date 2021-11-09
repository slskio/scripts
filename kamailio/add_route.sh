#!/bin/sh

dos2unix route.csv route.csv
for i in `cat route.csv`
do
	did=$(echo $i | cut -d , -f2)
	setid=$(echo $i | cut -d , -f3)

	# Add a new mtree record to database
	echo "adding $did with $setid into mtree"
	kamcli mtree db-add mtree $did $setid
done

# Reload MTREE
kamcli mtree reload srt
