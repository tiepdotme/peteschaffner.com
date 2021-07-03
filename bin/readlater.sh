#!/bin/bash
set -e

basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
url=$1
post_date=$(date +%Y-%m-%d)
title=$(curl -s $url | grep -o "<title>[^<]*" | head -1 | cut -d'>' -f2-)

if [ -n "$title" ]; then
	git pull --rebase
	echo -e "---\ndate: $post_date $(date +%H:%M)\nlink: $url\n---\n\n# $title" >> $basedir/../Content/readlater/$post_date-$(date +%H%M).md
	git add Content/readlater/
	git commit -m"Add read later item"
	git push
fi