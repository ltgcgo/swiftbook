#!/bin/bash
COMPRESS_CRIT="\.(bin|bm|bmp|conf|css|csv|htm|html|ico|js|json|kar|list|lst|map|md|mid|mjs|mod|otf|svg|tsv|ttf|vgm|wasm|webmanifest|xml)$"
rm -v 'book/FontAwesome/fonts/fontawesome-webfont.eot' 'book/FontAwesome/fonts/fontawesome-webfont.ttf'
echo "$(date +"%s")" > build-time.txt
cp -r book book-gz
cp -r book book-br
cd book
tar cvf ../pages-build.tar *
cd ..
zopfli --i1 -v pages-build.tar
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
exit