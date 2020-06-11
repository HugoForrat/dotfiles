#!/bin/bash

DIR=/home/"$USER"/.scripts/
for f in $(find "$DIR" -maxdepth 1 -type f -not -path */.git/* -not -name *LICENSE* -not -name *README*)
# FIXME: fails if there are files with spaces in them but this shoudl'nt be the case
do
	chmod u+x "$f" # If has the execution bit, then no need to chmod the link
	ln -s "$f" /home/"$USER"/.local/bin/"$(basename "$f")"
done
