#!/bin/bash
IFS=$'\n'
for dungeon in $(ls ../dps/ | cut -d "-" -f 1 | uniq) ; do
   pattern_grep="Zone id=\"$dungeon\""
   pattern_sed="s/.*name=\"\(.*\)\".*/\1/"
   name=$(grep $pattern_grep ./TeraDpsMeterData/monsters/monsters-EU-EN.xml | sed $pattern_sed)
   if [[ -z "$name" ]]; then
      name=$(grep $pattern_grep ./TeraDpsMeterData/monsters/monsters-KR.xml | sed $pattern_sed)
   fi
   echo "<a class=\"dropdown-item\" href=\"https://neowutran.ovh/dps-$dungeon.html\">$name</a>"
done
