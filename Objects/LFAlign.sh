#!/bin/bash

perl ./LFAligner/scripts/LF_aligner_4.2.pl --filetype="t" --infiles="./source.txt","./target.txt" --languages="$1","$2" --segment="n" --review="n" --tmx="n" --outfile="./aligned.txt"