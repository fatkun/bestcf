#/bin/bash
RESULT_PATH=./result.csv
. ~/.bash_profile

speedtest() {
	#./CloudflareST -allip -sl 5 -dn 10 -tl 1000 -url 'https://cdn.cloudflare.steamstatic.com/steam/apps/256843155/movie_max.mp4'
	CloudflareST \
		-url 'https://speed.fatkun.cloudns.ch/50m' \
		-f ./ip.txt \
		-n 100 \
		-o $RESULT_PATH \
		-sl 5 -dn 5 -tl 200 
}

gen_result() {
	cat ./result.csv|awk -F',' 'NR>1{print $1":443#CMCC"}' > best.txt
}

upload() {
	git add *.txt *.csv
	git commit -m 'update'
	git push -u origin main
}


speedtest
gen_result
upload
