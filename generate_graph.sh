#!/bin/bash
# new field separator, the end of line
IFS=$'\n'

for directory in $(find ./dps/ -type d 2> /dev/null) ; do
   plotfiles=""
   for file in $(ls $directory/*.txt 2> /dev/null); do
      if [[ ! -z "$plotfiles" ]]; then
         plotfiles="$plotfiles,"
      fi

      total_sum=$(cat $file | cut -d ":" -f 2 | paste -sd+ - | bc)
      plotfiles="$plotfiles '$file' using (\$1*1e-3):(\$2*100/$total_sum) with boxes"
   done
   if [[ ! -z "$plotfiles" ]]; then
      gnuplot <<- EOF
         set datafile separator ':'
         set autoscale xy
         set grid
         set termoption enhanced
         set format y '%1.0f%%'
         set style fill transparent solid 0.5
         set xtics 500
         set terminal svg font "Bitstream Vera Sans, 12" size 1000,500 linewidth 1
         set output "|cat > $directory/plot.svg"
         plot $plotfiles
EOF
   fi
done
