#!/bin/sh

BACKUPDIR=${HOME}/backup


#
# not change
#
if [ ! -d $BACKUPDIR ]; then
    echo "couldn't find backup directory !!!"
    exit 0
elif [ -z "$1" ]; then
    echo "please input file name !!!"
    exit 0
elif [ ! -e `basename $1` ]; then
    echo "no such file !!!"
    exit 0
fi

FILENAME=`basename $1`
DATE=`/bin/date '+%Y%m%d%H%M'`
HOSTNAME=`uname -n`

CMD="tar zcvf ${BACKUPDIR}/${FILENAME}_${DATE}_${HOSTNAME}.tgz ${FILENAME}"

echo "cmd : ${CMD}"
echo -n 'execute backup ? [y/N]'
read ans
if [ "${ans}" = "y" ]; then
    ${CMD}
else
    exit
fi