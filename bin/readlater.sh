#!/bin/bash
set -e

cmd=$(if [ "$(uname)" = "Darwin" ]; then echo mac/title; else echo linux/title; fi)
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
url=$1
title=$($basedir/$cmd $url)
post_date=$(date +%Y-%m-%dT%H:%M:%S%z)
file_name=$(date +%Y-%m-%d-%H%M)

if [ -n "$title" ]; then
	git pull --rebase
	echo -e "---\ntitle: \"$title\"\ndate: $post_date\nlink: $url\n---\n" >> $basedir/../content/reading-list/$file_name.md
	git add content/reading-list/
	git commit -m"Add reading list item"
	git push
fi