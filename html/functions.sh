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

function get_dungeon_name {
   local pattern_grep="Zone id=\"$1\""
   local pattern_sed="s/.*name=\"\(.*\)\".*/\1/"
   local dungeonname=$(grep $pattern_grep ./TeraDpsMeterData/monsters/monsters-EU-EN.xml | sed $pattern_sed)
   if [[ -z "$dungeonname" ]]; then
      local dungeonname=$(grep $pattern_grep ./TeraDpsMeterData/monsters/monsters-KR.xml | sed $pattern_sed)
   fi
   echo "$dungeonname"
}
