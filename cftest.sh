#/bin/bash
RESULT_PATH=./result.csv

function speedtest {
	#./CloudflareST -allip -sl 5 -dn 10 -tl 1000 -url 'https://cdn.cloudflare.steamstatic.com/steam/apps/256843155/movie_max.mp4'
	CloudflareST \
		-url 'https://speed.fatkun.cloudns.ch/50m' \
		-f ./ip.txt \
		-n 100 \
		-o $RESULT_PATH
		-sl 5 -dn 5 -tl 200 
}

function gen_result {
	cat ./result.csv|awk -F',' 'NR>1{print $1":443#CMCC"}' > best.txt
}

function upload {
	git add *.txt
	git commit -m 'update'
	git push -u origin main
}


gen_result
upload
