#!/bin/bash
read_dom () {
   local IFS=\>
   read -d \< ENTITY CONTENT
   local ret=$?
   TAG_NAME=${ENTITY%% *}
   ATTRIBUTES=${ENTITY#* }
   return $ret
}

function get_boss_name_file {
   local zonefound=""
   while read_dom; do
      if [[ $TAG_NAME = "Zone" ]]; then
         eval local $ATTRIBUTES
         if [[ $id = "$1" ]]; then
            local zonefound="yes"
         fi
      fi
      if [[ ! -z $zonefound ]]; then
         if [[ $TAG_NAME = "Monster" ]]; then
            eval local ${ATTRIBUTES/\//}
            if [[ $id = "$2" ]]; then
               echo "$name"
               return 0
            fi
         fi
      fi
   done < $3

}

function get_boss_name {
   local name=$(get_boss_name_file $1 $2 ./TeraDpsMeterData/monsters/monsters-EU-EN.xml)
   if [[ ! -z $name ]]; then
      echo "$name"
      return 0
   fi
   get_boss_name_file $1 $2 ./TeraDpsMeterData/monsters/monsters-KR.xml
}
./generate_header.sh
IFS=$'\n'
for dungeon in $(ls ../dps/ | cut -d "-" -f 1 | uniq) ; do
   indexfile="dps-$dungeon.html"
   pattern_grep="Zone id=\"$dungeon\""
   pattern_sed="s/.*name=\"\(.*\)\".*/\1/"
   dungeonname=$(grep $pattern_grep ./TeraDpsMeterData/monsters/monsters-EU-EN.xml | sed $pattern_sed)
   if [[ -z "$dungeonname" ]]; then
      dungeonname=$(grep $pattern_grep ./TeraDpsMeterData/monsters/monsters-KR.xml | sed $pattern_sed)
   fi
   header=$(cat ./header.html)
   header=${header/include_title/"$dungeonname"}
   echo "$header" > $indexfile
   echo "<h1>$dungeonname</h1>" >> $indexfile
   for boss in $(ls ../dps/ | grep $dungeon-) ; do
      bossid=$(echo "$boss" | cut -d '-' -f 2)
      bossname=$(get_boss_name $dungeon $bossid)
      echo "<a role=\"button\" class=\"btn btn-primary btn-lg btn-block\" href=\"https://neowutran.ovh/dps-$boss.html\">$bossname</a>" >> $indexfile
      filename="dps-$boss.html"
      header=$(cat ./header.html)
      header=${header/include_title/"$dungeonname - $bossname"}
      echo "$header" > $filename
      echo "<h1>$dungeonname - $bossname</h1>" >> $filename
      for class in $(ls ../dps/$boss/) ; do
         echo "<h2>$class</h2>" >> $filename
         for region in $(ls ../dps/$boss/$class/) ; do
            echo "<h3>$region</h3>" >> $filename
            echo "<img style='height: 100%; width: 100%; object-fit: contain' src=\"https://neowutran.ovh/data/dps/$boss/$class/$region/plot.svg\" />" >> $filename
         done
      done
      echo $(cat ./_footer) >> $filename
   done
done
