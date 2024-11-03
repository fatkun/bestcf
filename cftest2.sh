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
  min_speed=$5
  iata=$6
  args=$7

  s_start_time=$(date +%s)
  # st 测速线程
  echo "START ------> "$info
  cfiptest -f $file -s -mins $min_speed -maxdc 500 -maxsc $testc -iata=$iata -st 1 -o $TMP_RESULT_PATH $args

  cat $TMP_RESULT_PATH >> $RESULT_PATH

  s_end_time=$(date +%s)
  s_elapsed_time=$((s_end_time - s_start_time))
  echo "$info 耗时: $s_elapsed_time seconds"
  echo "$info 耗时: $s_elapsed_time seconds,,,,,,," >> $RESULT_PATH
  echo "\n\n\n"

	count=`cat $TMP_RESULT_PATH|awk -F',' 'NR>1{print $1}'|wc -l`
	if [ "x0" = "x$count" ]; then
		echo "no result"
		return
	fi

  cat $TMP_RESULT_PATH|awk -F ',' 'NR>1{
    mapping["NRT"] = "JP";
    mapping["FUK"] = "JP";
    mapping["KIX"] = "JP";
    mapping["HKG"] = "HK";
    mapping["LAX"] = "US";
    mapping["NYC"] = "US";
    mapping["SJC"] = "US";
    mapping["SIN"] = "SG";
    mapping["LHR"] = "BG";
    mapping["TPE"] = "TW";
    mapping["KHH"] = "TW";
    mapping["ICN"] = "KR";

    for (key in mapping) {if ($4 == key) {$4 = mapping[key];break;}}
    if (index($1, ":") > 0) {$1="["$1"]";}
	  print $1":"$2"#"$4" '$info'"
	  }'|head -n "$outc" >> $TMP_PATH
}

final_release() {
  mv $TMP_PATH $FINAL_PATH
  clean_tmp_file
  end_time=$(date +%s)
  elapsed_time=$((end_time - start_time))
  echo "耗时: $elapsed_time seconds"
  echo "耗时: $elapsed_time seconds,,,,,,," >> $RESULT_PATH
}

upload() {
	git add *.txt *.csv
	git commit -m 'update'
	git push
	date
}

start_time=$(date +%s)
init
#speedtest '../input/cf.txt' "CF" 5 5 4 "" " -dtt 1 "

#speedtest '../new/45102.txt' "阿里" 5 5 4 "" " -dtt 1 "

speedtest '../new/3258.txt' "xTom" 3 3 4 """ -dtt 1 "
speedtest '../new/932.txt' "XNNET" 3 3 4 """ -dtt 1 "
#speedtest '../input/as967.txt' "VMISS" 3 3 4 """ -dtt 1 "
#speedtest '/root/bin/gcf/ip.txt' "汇聚" 4 3 4 "TPE,KHH" # TW
speedtest '/root/bin/gcf/ip.txt' "汇聚" 4 3 4 "SJC,NYC,LAX" # US
speedtest '/root/bin/gcf/ip.txt' "汇聚" 4 3 4 "SIN"
#speedtest '/root/bin/gcf/ip.txt' "汇聚" 4 3 4 "HKG" 
#speedtest '/root/bin/gcf/ip.txt' "汇聚" 4 3 4 "ICN" #KR
speedtest '/root/bin/gcf/ip.txt' "汇聚" 4 3 4 "NRT,FUK,KIX" # JP
#speedtest '../input/AS41378.txt' "Kirino" 3 3 4 ""

#speedtest './input2/ipv6.txt' "IPV6" 3 2 2
final_release
upload
