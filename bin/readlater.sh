#!/bin/sh
set -e

post_date=$(date +%Y-%m-%d)
url=$(echo 'set dialogText to text returned of (display dialog "Read Later URL:" default answer (the clipboard as text))\n return dialogText' | osascript 2>&1)
title=$(curl -s $url | grep -o "<title>[^<]*" | head -1 | cut -d'>' -f2-)

if [ -n "$title" ]; then
	git pull --rebase
	echo "---\ndate: $post_date $(date +%H:%M)\nlink: $url\n---\n\n# $title" >> Content/readlater/$post_date-$(date +%H%M).md
	git add Content/readlater/
	git commit -m"Add read later item"
	git push
	echo "🎉 Success!"
else
	echo "⚠️ Something went wrong. Check the URL and try again."
	exit 1
fi