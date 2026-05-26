#!/bin/bash
COMPRESS_CRIT="\.(ass|atom|bin|bm|bmp|conf|css|csv|htm|html|ico|js|json|kar|list|lrc|lst|map|md|mid|mjs|mod|mts|otf|rss|sbv|srt|ssa|svg|trc|ts|tsv|ttf|ttml|txt|vgm|vtt|wasm|webmanifest|xml|ytt)$"
rm -v 'book/FontAwesome/fonts/fontawesome-webfont.eot' 'book/FontAwesome/fonts/fontawesome-webfont.ttf'
echo "$(date +"%s")" > build-time.txt
cp -r book book-gz
cp -r book book-br
cp -r book book-base
cd book
tar cvf ../pages-build.tar *
cd ..
#zopfli --i1 -v pages-build.tar
gzip -9v pages-build.tar
rm -v pages-build.tar
cd book-gz
tree -ifl | while IFS= read -r file; do
	if [ -f "$file" ]; then
		# Is a file
		if [ "$(echo "$file" | grep -E "$COMPRESS_CRIT")" != "" ]; then
			gzip -v9 "$file" #&& echo "Compressed \"${file}\" with Zopfli."
		else
			echo "File \"${file}\" cannot be compressed."
		fi
		if [ -f "$file" ]; then
			rm -v "$file"
		fi
	fi
done
tar cvf ../pages-build-gz.tar *
cd ..
cd book-br
tree -ifl | while IFS= read -r file; do
	if [ -f "$file" ]; then
		# Is a file
		if [ "$(echo "$file" | grep -E "$COMPRESS_CRIT")" != "" ]; then
			brotli -v9 "$file"
		else
			echo "File \"${file}\" cannot be compressed."
		fi
		if [ -f "$file" ]; then
			rm -v "$file"
		fi
	fi
done
tar cvf ../pages-build-br.tar *
cd ..
cd book-base
tree -ifl | while IFS= read -r file; do
	if [ -f "$file" ]; then
		# Is a file
		if [ "$(echo "$file" | grep -E "$COMPRESS_CRIT")" != "" ]; then
			rm -v "$file"
		else
			echo "File \"${file}\" is preserved."
		fi
	fi
done
tar cvf ../pages-build-base.tar *
cd ..
exit