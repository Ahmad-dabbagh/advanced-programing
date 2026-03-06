#!/usr/bin/env gawk -f
# Usage:
#   gawk -f accountant.awk test_1m.csv
#
# Produces deductions_33_percent.txt
# Prints reconciliation report to stdout

BEGIN {
    FS = ","
    fee_num = 33
    fee_den = 100

    baseFile = ".base.tmp"
    remFile  = ".rem.tmp"
    outFile  = "deductions_33_percent.txt"

    n = 0
    total = 0
    base_sum = 0

    system("rm -f " baseFile " " remFile " " outFile)
}

function money_to_cents(s,   p,d,c,t) {
    gsub(/^[ \t]+|[ \t]+$/, "", s)
    if (s == "") return -1
    split(s, p, ".")
    d = p[1] + 0
    c = substr(p[2] "00", 1, 2) + 0
    t = substr(p[2] "000", 3, 1) + 0
    if (t >= 5) c++
    if (c >= 100) { d++; c -= 100 }
    return d * 100 + c
}

NR == 1 { next }

{
    s = $7
    gsub(/^[ \t]+|[ \t]+$/, "", s)
    if (s == "") next

    sc = money_to_cents(s)
    if (sc < 0) next

    total += sc
    num = sc * fee_num
    b = int(num / fee_den)
    r = num % fee_den

    base_sum += b
    n++

    print b >> baseFile
    printf "%d\t%d\n", r, n >> remFile
}

END {
    expected = int((total * fee_num + 50) / fee_den)
    diff = expected - base_sum

    if (diff > 0)
        system("sort -nr " remFile " | head -n " diff " | awk '{print $2}' > .bonus")
    else if (diff < 0)
        system("sort -n " remFile " | head -n " (-diff) " | awk '{print $2}' > .bonus")
    else
        system("touch .bonus")

    while ((getline x < ".bonus") > 0) bonus[x] = 1
    close(".bonus")

    i = 0
    sum = 0
    while ((getline b < baseFile) > 0) {
        i++
        d = b
        if (bonus[i]) d += (diff > 0 ? 1 : -1)
        sum += d
        printf "%d.%02d\n", int(d/100), d%100 >> outFile
    }

    disc = sum - expected
    if (disc < 0) disc = -disc

    print "=== RECONCILIATION REPORT ==="
    print "Contractors processed:", n
    printf "Total revenue: %d.%02d\n", int(total/100), total%100
    printf "Sum of deductions: %d.%02d\n", int(sum/100), sum%100
    printf "Expected (33%% of total): %d.%02d\n", int(expected/100), expected%100
    printf "Discrepancy: %d.%02d\n", int(disc/100), disc%100
    print "Status:", (disc <= 1 ? "RECONCILED" : "DISCREPANCY")
    print "============================="

    system("rm -f " baseFile " " remFile " .bonus")
}
