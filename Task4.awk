#!/bin/awk -f
# based on:
#   https://gist.github.com/mikewallace1979/3973059
 
# Quick hacky script that computes basic statistics from a single
# column of numbers from stdin - inspired by the CouchDB _stats reducer
 
BEGIN { count = 0; sum = 0 }

# skip lines that arent numbers
$1 !~ /^-?[0-9]*\.?[0-9]+$/ {
    #print "skipping: \"" $1 "\"";
    next
}

count == 0 || $1 < min { min = $1 }
count == 0 || $1 > max { max = $1 }

{ count++; sum += $1 ; sumsq += $1 ** 2 }

END {
    # Stolen from http://www.commandlinefu.com/commands/view/1661/display-the-standard-deviation-of-a-column-of-numbers-with-awk
    if (count > 0) {
        mean = sum/count
        stddev = sqrt(sumsq/count - mean**2)
    }
 
  
    print "Min RTT: " min
    print "Max RTT: " max
    print "Average RTT: " mean
    print "Standard deviation RTT: " stddev
}
