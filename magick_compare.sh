#!/bin/bash

if [ "$#" -le 2 ]; then
    echo "You must be provided two folder path for comparing the files and the start frame index. ($# provided)"
    exit 1
fi

echo "compare these folders $1, $2"
echo "start at $3"

index=0
for file in $1/*.tga; do
    index=$((index+1))
    [ $index -le $3 ] && continue;

    f=${file##*/}
    echo "diff - $f"
    magick compare -metric RMSE "$1/$f" "$2/$f" diff.tga
    feh diff.tga
done

