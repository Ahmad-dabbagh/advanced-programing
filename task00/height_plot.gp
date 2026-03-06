set terminal png size 1000,600
set output 'height_distribution.png'

set title 'Height Frequency Distribution'
set xlabel 'Height'
set ylabel 'Frequency'

set style data boxes
set style fill solid 0.7
set boxwidth 0.8

plot 'height_freq.dat' using 2:1 with boxes notitle

