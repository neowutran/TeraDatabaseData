#!/bin/bash
source ./functions.sh
IFS=$'\n'
rootfile="dps.html"
header=$(cat ./_header)
header=${header/include_title/DPS Statistics}
echo "$header" > $rootfile

echo "<div class=\"pa3 pa5-ns\">" >> $rootfile
echo "<ul class=\"list pl0 measure center\">" >> $rootfile

for dungeon in $(ls ../dps/ | cut -d "-" -f 1 | uniq) ; do

   indexfile="dps-$dungeon.html"
   dungeonname=$(get_dungeon_name $dungeon )
   echo "<li class=\"lh-copy pv3 ba bl-0 bt-0 br-0 b--dotted b--black-30\"><a href=\"/data/html/dps-$dungeon.html\">$dungeonname</a></li>" >> $rootfile

   header=$(cat ./_header)
   header=${header/include_title/"$dungeonname"}
   echo "$header" > $indexfile
   echo "<h1>$dungeonname</h1><div class=\"pa3 pa5-ns\"><ul class=\"list pl0 measure center\">" >> $indexfile

   for boss in $(ls ../dps/ | grep $dungeon-) ; do

      bossid=$(echo "$boss" | cut -d '-' -f 2)
      bossname=$(get_boss_name $dungeon $bossid)
      echo "<li class=\"lh-copy pv3 ba bl-0 bt-0 br-0 b--dotted b--black-30\"><a href=\"/data/html/dps-$boss.html\">$bossname</a></li>" >> $indexfile
      filename="dps-$boss.html"
      header=$(cat ./_header)
      header=${header/include_title/"$dungeonname - $bossname"}
      echo "$header" > $filename
      echo "<h1>$dungeonname - $bossname</h1>" >> $filename

      for class in $(ls ../dps/$boss/) ; do

         echo "<h2>$class</h2>" >> $filename
         for region in $(ls ../dps/$boss/$class/) ; do
            echo "<h3>$region</h3>" >> $filename
            echo "<img class='graph' src=\"/data/dps/$boss/$class/$region/plot.svg\" alt="$boss-$class-$region" />" >> $filename
         done
      done
      echo $(cat ./_footer) >> $filename
   done

   echo "</ul></div>" >> $indexfile
   echo $(cat ./_footer) >> $indexfile

done

echo "</ul></div>" >> $rootfile
echo $(cat ./_footer) >> $rootfile
