RESULT1=./output/tmp1.csv

CloudflareST \
    -url 'https://speed.fatkun.cloudns.ch/50m' \
    -f ./input/ip_us.txt \
    -allip \
    -tp 2083 \
    -n 200 \
    -o $RESULT1 \
    -sl 5 -dn 5 -tl 300 \
    -tlr 0.2 \
    -t 1

	cat $RESULT1|awk -F',' 'NR>1{print $1}'
