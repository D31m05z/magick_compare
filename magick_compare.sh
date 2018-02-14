#!/bin/bash

usage="$(basename "$0") [-a] [-b] [-s n] -- You must be provided two folder path for comparing the images and the start frame index.

where:
    -h  show this help text
    -a  folder1
    -b  folder2
    -s  set the start frame"

start=0
while getopts ':a:b:h:s:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    s) start=$OPTARG
       ;;
    a) folder1=$OPTARG
       ;;
    b) folder2=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

if [ -z $folder1 ]; then
  echo "-a [option] is required"
  exit
fi

if [ -z $folder2 ]; then
  echo "-b [option] is required"
  exit
fi

index=0
for file in $folder1/*.tga; do
    index=$((index+1))
    [ $index -le $start ] && continue;

    f=${file##*/}
    echo " - diff - $f"
    magick compare -metric RMSE "$folder1/$f" "$folder2/$f" diff.tga
    feh diff.tga
done

