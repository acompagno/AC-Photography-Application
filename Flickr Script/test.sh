read FLICKR_URL 
curl $FLICKR_URL | grep -ni "seta" | grep -oh 'title="[^"]\+"' | cut -c 7- > settitles.temp
curl $FLICKR_URL | grep -ni "seta" | grep -oh 'href="[^"]\+"' | cut -c 7- | sed 's/^/"http:\/\/www.flickr.com/' > seturls.temp 
URL=$(curl $FLICKR_URL | grep -ni "seta" | grep -oh 'href="[^"]\+"' | cut -c 7- | sed 's/^/"www.flickr.com/' | sed 's/"//g' )
URLCOUNT=$(echo "$URL" | wc -l)
for ((i=1; i<=URLCOUNT; i++)); do
	TEMPURL=$(echo "$URL" | head -n $i | tail -n 1)
	PAGECOUNT=$(curl "$TEMPURL" | grep -oh 'data-page-count="[[:digit:]]"' | grep -oh '[[:digit:]]')
	if ["$PAGECOUNT" == ""]; then
		PAGECOUNT=$(echo "1")
		echo "pagecount 1"
	fi
	for ((b=1; b<=PAGECOUNT; b++)); do 
		TEMPURLWITHPAGE=$(echo "$TEMPURL""page$b")
		echo "set_data $i-$b.temp"
		echo "$TEMPURLWITHPAGE"
		curl "$TEMPURLWITHPAGE" |  grep "Y.listData" | cut -c 15- | sed 's/;$//' > "set_data $i-$b.temp"
	done
done
python3 getdata.py 
python3 formatdata.py
rm *.temp
# http://www.flickr.com/photos/13906431@N07/sets/