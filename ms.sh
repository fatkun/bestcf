ASN=$1
PORT_RANGE=$2

RANGE_FILE=./tmp/${ASN}_range.txt
MASSCAN_FILE=./tmp/${ASN}_masscan.txt
MASSCAN_IP_FILE=./tmp/${ASN}_masscan_ip.txt
FIRST_FILTER_FILE=./out/${ASN}.txt
CFIP_FILE=./tmp/${ASN}_ip.txt
PORT_RANGE_DEFAULT="443,2053,2083,2087,2096,8443"

if [ -z "$ASN" ]
then
  echo "asn is empty"
  exit 1
fi


if [ -z "$PORT_RANGE" ]
then
  PORT_RANGE=$PORT_RANGE_DEFAULT
fi

echo "Start scan ASN $ASN, Port $PORT_RANGE"


#masscan -iL $RANGE_FILE -p 0-65530 --rate 10000 -oL $MASSCAN_FILE

rm $MASSCAN_IP_FILE
rm $FIRST_FILTER_FILE

cfiptest asn -as $ASN > $RANGE_FILE
masscan -iL $RANGE_FILE -p "$PORT_RANGE" --wait=8 --rate 20000 -oL $MASSCAN_FILE
cat $MASSCAN_FILE|grep open|awk '{print $4","$3}' >> $MASSCAN_IP_FILE
rm $MASSCAN_FILE


#while IFS= read -r line1 && IFS= read -r line2 && IFS= read -r line3 && IFS= read -r line4 && IFS= read -r line5  && IFS= read -r line6 && IFS= read -r line7 && IFS= read -r line8  && IFS= read -r line9  && IFS= read -r line10; do
#    echo "$line1 - $line10"
#    masscan -p "$PORT_RANGE" --wait=3 --rate 50000 -oL $MASSCAN_FILE "$line1 $line2 $line3 $line4 $line5 $line6 $line7 $line8 $line9 $line10"
#    cat $MASSCAN_FILE|grep open|awk '{print $4","$3}' >> $MASSCAN_IP_FILE
#done < "$RANGE_FILE"

cfiptest -f $MASSCAN_IP_FILE -st 0 -o $CFIP_FILE
cat $CFIP_FILE|awk -F',' '{print $1","$2}' >> $FIRST_FILTER_FILE
