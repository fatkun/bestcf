	CloudflareST \
		-url 'https://speed.fatkun.cloudns.ch/50m' \
		-ip 168.138.192.0/19 \
		-tp 2083 -allip \
		-n 100 \
		-o ./tmp.csv.tmp \
		-sl 5 -dn 5 -tl 300 -dd

	cat ./tmp.csv.tmp|awk -F',' 'NR>1{print $1}'
