#/bin/bash
RESULT_PATH=./result.csv
PORT=2083
. ~/.bash_profile

speedtest() {
	CloudflareST \
		-url 'https://speed.fatkun.cloudns.ch/50m' \
		-f ./ip2.txt \
		-tp $PORT \
		-n 100 \
		-o $RESULT_PATH \
		-sl 5 -dn 5 -tl 300 
}

gen_result() {
	cat $RESULT_PATH|awk -F',' 'NR>1{print $1":'$PORT'#CMCC"}' > best.txt
	count=`cat ./best.txt|wc -l`
	if [ "x0" = "x$count" ]; then
		echo "no result"
		exit
	fi
}

upload() {
	git add *.txt *.csv
	git commit -m 'update'
	git push
}


speedtest
gen_result
upload
