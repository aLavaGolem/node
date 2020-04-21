#!/bin/bash
url="http://www.huhudm.com"
seed(){
  for da in `echo "$1" | tr ' ' '#'`
  do
    herf=`echo $da | cut -f 1 -d "#"`
    title=`echo $da | cut -f 2 -d "#"`

    #echo $herf
    path="$2/$title"
    if [ ! -d "$path" ];then
      mkdir $path
    fi
	rep=`curl -s "$url$herf"`
	
    page=`echo "$rep" | grep -o -P "[0-9].*?\<\/b\>" | sed "s/<\/b>//g"`
    #echo 页数：$page
	
	for i in `seq 1 $page`
	do	
	    sleep 1
		(#echo 下标：$i
		urlz=`echo "$url$herf" | sed "s/1\./$i./g"` 
		#echo 每一集地址:$urlz
		rep=`curl -s "$urlz"`
		headurl=`echo "$rep" | grep -o -P "id=\"hdDomain\".*?\\\>" | grep -o -P "\".*?\"" | tail -n 1 | sed "s/\"//g" | cut -f 1 -d "|" `
		#echo headurl:$headurl
		value=`echo "$rep" | grep -o -P "\<img.*?\>" | grep -o -P "\".*?\"" | head -n 2 | tail -n 1 | sed "s/\"//g"`
		#echo "value:$value"
		#python执行js
		val=`./venv/Scripts/python.exe ./javascript.py $value`
		echo 地址：$val
		filename=${val##*/}
		if [ ! -f "$path/$filename" ];then
		  echo 下载文件:$path/$filename 下载地址:$headurl$val
		  `curl "$headurl$val" > $path/$filename `
		fi)&
	done
  done
 
}
pulp(){
  data=`curl -s "$1"`
  #echo "$data"
  title=`echo "$data" | sed ":t;N;s/\n//;b t" | grep -o -P "\<h1\>.*?\<" | sed "s/[\<\> h1]//g"`
  echo $title
  if [ ! -d "$title" ];then
    mkdir $title
  fi
  ui=`echo "$data" | sed ":t;N;s/\n//;b t" | grep -o -P "cVolUl.*?\<\/ul" | head -n 1 `
  #echo $ui
  #echo --------------
  #echo --------------
  #echo --------------
  a=`echo "$ui" | grep -o -P "\<a.*?\>" | awk '{print $3" "$5$6}' | sed "s/[\'\>]//g" | sed "s/href=//g" | sed "s/title=//g"`
  #echo "$a"
  
  seed "$a" $title
  



}
pulp "http://www.huhudm.com/huhu8595.html"

