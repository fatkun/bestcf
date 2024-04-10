#/bin/bash

. ~/.bash_profile

RESULT_PATH=./output/result.csv
TMP_RESULT_PATH=./output/result.tmp.csv
TMP_PATH=./output/best.tmp.txt
FINAL_PATH=./output/best.txt
MAX_ITEM=5

init() {
  date
  clean_tmp_file
  rm -f $RESULT_PATH
  git pull
}

clean_tmp_file() {
  rm -f $TMP_PATH
  rm -f $TMP_RESULT_PATH
}

speedtest() {
  file=$1
  info=$2
  testc=$3
  outc=$4

  s_start_time=$(date +%s)
  # st 测速线程
  # cfiptest -f xxx -st 0
  # cat ali.txt|awk -F ',' '!a[$1]++{print}'
  cfiptest -f $file -url speed.fatkun.cloudns.ch/50m -mins 4 -maxdc 1000 -maxsc $testc -st 1 -o $TMP_RESULT_PATH

	cat $TMP_RESULT_PATH >> $RESULT_PATH

	count=`cat $TMP_RESULT_PATH|awk -F',' 'NR>1{print $1}'|wc -l`
	if [ "x0" = "x$count" ]; then
		echo "no result"
		return
	fi
	if [ "IPV6" = "$info" ]; then
	  cat $TMP_RESULT_PATH|awk -F ',' 'NR>1{
    mapping["HKG"] = "HK";
    mapping["NYC"] = "US";
    mapping["SJC"] = "US";
    mapping["SIN"] = "SG";
    mapping["LHR"] = "BG";

    for (key in mapping) {if ($4 == key) {$4 = mapping[key];break;}}
	  print "["$1"]:"$2"#"$4" '$info'";
	  }'|head -n "$outc" >> $TMP_PATH
	else
	  cat $TMP_RESULT_PATH|awk -F ',' 'NR>1{
    mapping["HKG"] = "HK";
    mapping["NYC"] = "US";
    mapping["SJC"] = "US";
    mapping["SIN"] = "SG";
    mapping["LHR"] = "BG";

    for (key in mapping) {if ($4 == key) {$4 = mapping[key];break;}}
	  print $1":"$2"#"$4" '$info'"
	  }'|head -n "$outc" >> $TMP_PATH
	fi
	s_end_time=$(date +%s)
  s_elapsed_time=$((s_end_time - s_start_time))
  echo "耗时: $s_elapsed_time seconds"
}

final_release() {
  mv $TMP_PATH $FINAL_PATH
  clean_tmp_file
}

upload() {
	git add *.txt *.csv
	git commit -m 'update'
	git push
	date
}

start_time=$(date +%s)
init
speedtest './input2/ali.txt' "阿里" 7 5
speedtest './input2/AS41378.txt' "Kirino" 5 3
speedtest './input2/ipv6.txt' "IPV6" 5 3
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
echo "耗时: $elapsed_time seconds" >> $RESULT_PATH
echo "耗时: $elapsed_time seconds"
final_release
upload
