#!/bin/sh

# borrowed from
# http://d.hatena.ne.jp/tettou77-2/20100525/1274810510

dir=`dirname $0`
date=`date +%F_%T`
memo=`zenity --entry --title="一言メモ" --text="メモを記録します" --width=400`
echo $date $memo >> ${dir}/memo.txt