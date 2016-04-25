#/bin/sh

# path to moses decoder: https://github.com/moses-smt/mosesdecoder
mosesdecoder=/path/to/mosesdecoder

# suffix of target language files
lng=en

sed -r 's/ \@(\S*?)\@ /\1/g' | \
$mosesdecoder/scripts/recaser/detruecase.perl