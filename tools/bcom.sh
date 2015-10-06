#!/bin/bash
#export BTIME="$(shellda te +%Y%m%d.%H%M%S"
BTIME=$(date +%Y%m%d)
cd $OUT
export PACKAGE_OUT="xoplax-InsiderPreview-1011-$1-$BTIME-$CM_BUILDTYPE.zip"
mv $OUT/cm-11-$BTIME-$CM_BUILDTYPE-$1.zip $OUT/$PACKAGE_OUT
echo Package complete on $OUT/$PACKAGE_OUT

