#!/bin/bash
total_sum1=$(cat ./dps/770-3000/Archer/EU/67.txt | cut -d ":" -f 2 | paste -sd+ - | bc)
total_sum2=$(cat ./dps/770-3000/Archer/EU/68.txt | cut -d ":" -f 2 | paste -sd+ - | bc)
gnuplot <<- EOF
         set datafile separator ':'
         set autoscale xy
         set grid
         set termoption enhanced
         #set format y '%.1t 10^{%T}'
         set format y '%1.0f%%' 
         set xtics 500
         set terminal svg font "Bitstream Vera Sans, 12" size 1000,1000 linewidth 1
         set output "|cat > ./dps/770-3000/Archer/EU/plot.svg"
         plot './dps/770-3000/Archer/EU/67.txt' using (\$1*1e-3):(\$2*100/$total_sum1) with linespoint, './dps/770-3000/Archer/EU/68.txt' using (\$1*1e-3):(\$2*100/$total_sum2) with linespoint

EOF

