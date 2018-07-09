#!/bin/bash
source ./functions.sh
IFS=$'\n'
rootfile="dps.html"
header=$(cat ./_header)
header=${header/include_title/DPS Statistics}
echo "$header" > $rootfile

for dungeon in $(ls ../dps/ | cut -d "-" -f 1 | uniq) ; do

   indexfile="dps-$dungeon.html"
   dungeonname=$(get_dungeon_name $dungeon )
   echo "<a href=\"https://neowutran.ovh/data/html/dps-$dungeon.html\">$dungeonname</a>" >> $rootfile
   header=$(cat ./_header)
   header=${header/include_title/"$dungeonname"}
   echo "$header" > $indexfile
   echo "<h1>$dungeonname</h1>" >> $indexfile

   for boss in $(ls ../dps/ | grep $dungeon-) ; do

      bossid=$(echo "$boss" | cut -d '-' -f 2)
      bossname=$(get_boss_name $dungeon $bossid)
      echo "<a href=\"/data/html/dps-$boss.html\">$bossname</a>" >> $indexfile
      filename="dps-$boss.html"
      header=$(cat ./_header)
      header=${header/include_title/"$dungeonname - $bossname"}
      echo "$header" > $filename
      echo "<h1>$dungeonname - $bossname</h1>" >> $filename

      for class in $(ls ../dps/$boss/) ; do

         echo "<h2>$class</h2>" >> $filename
         for region in $(ls ../dps/$boss/$class/) ; do
            echo "<h3>$region</h3>" >> $filename
            echo "<img style='height: 100%; width: 100%; object-fit: contain' src=\"/data/dps/$boss/$class/$region/plot.svg\" />" >> $filename
         done
      done
      echo $(cat ./_footer) >> $filename
   done
done
