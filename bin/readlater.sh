#!/bin/bash
set -e

basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
url=$1
post_date=$(date +%Y-%m-%d)
title=$(curl -L $url -so - | ruby -rnokogiri -e 'puts Nokogiri::HTML(readlines.join).xpath("//title").map { |e| e.content }')

if [ -n "$title" ]; then
	git pull --rebase
	echo -e "---\ntitle: $title\ndate: $post_date $(date +%H:%M)\nlink: $url\n---\n" >> $basedir/../Content/readlater/$post_date-$(date +%H%M).md
	git add Content/readlater/
	git commit -m"Add read later item"
	git push
fi