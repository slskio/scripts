#!/bin/sh

for i in `cat route.csv`
do
	did=$(echo $i | cut -d , -f1)
	setid=$(echo $i | cut -d , -f2)

	# echo "add $did - $setid"

	echo "kamctl db exec \"INSERT INTO mtree (id, tprefix, tvalue) VALUES (NULL, '$did', '$setid')\";"
	# kamctl db exec "INSERT INTO mtree (id, tprefix, tvalue) VALUES (NULL, '$did', '$setid')";
done

# Reload MTREE
echo "kamcmd mtree.reload srt"
# kamcmd mtree.reload srt
