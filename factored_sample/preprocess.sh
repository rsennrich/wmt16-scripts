#!/bin/bash

# this sample script preprocesses a sample corpus, including tokenization,
# truecasing, and subword segmentation. 
# for application to a different language pair,
# change source and target prefix, optionally the number of BPE operations,
# and the file names (currently, data/corpus and data/newstest2013 are being processed)

# in the tokenization step, you will want to remove Romanian-specific normalization / diacritic removal,
# and you may want to add your own.
# also, you may want to learn BPE segmentations separately for each language,
# especially if they differ in their alphabet

# suffix of source language files
SRC=en

# suffix of target language files
TRG=de

# number of merge operations. Network vocabulary should be slightly larger (to include characters),
# or smaller if the operations are learned on the joint vocabulary
bpe_operations=89500

# path to moses decoder: https://github.com/moses-smt/mosesdecoder
mosesdecoder=/path/to/mosesdecoder

# path to subword segmentation scripts: https://github.com/rsennrich/subword-nmt
subword_nmt=/path/to/subword-nmt

# path to nematus ( https://www.github.com/rsennrich/nematus )
nematus=/path/to/nematus

# tokenize
for prefix in corpus newstest2013
 do
   cut -f 2 data/$prefix.conll.$SRC | \
   awk -v RS="" '{$1=$1}7' | \
   $mosesdecoder/scripts/tokenizer/escape-special-chars.perl -l $SRC > data/$prefix.tok.$SRC

   cat data/$prefix.$TRG | \
   $mosesdecoder/scripts/tokenizer/normalize-punctuation.perl -l $TRG | \
   $mosesdecoder/scripts/tokenizer/tokenizer.perl -a -l $TRG > data/$prefix.tok.$TRG

 done

# train truecaser
$mosesdecoder/scripts/recaser/train-truecaser.perl -corpus data/corpus.tok.$SRC -model model/truecase-model.$SRC
$mosesdecoder/scripts/recaser/train-truecaser.perl -corpus data/corpus.tok.$TRG -model model/truecase-model.$TRG

# apply truecaser (cleaned training corpus)
for prefix in corpus
 do
  $mosesdecoder/scripts/recaser/truecase.perl -model model/truecase-model.$SRC < data/$prefix.tok.$SRC > data/$prefix.tc.$SRC
  $mosesdecoder/scripts/recaser/truecase.perl -model model/truecase-model.$TRG < data/$prefix.tok.$TRG > data/$prefix.tc.$TRG
 done

# apply truecaser (dev/test files)
for prefix in newstest2013
 do
  $mosesdecoder/scripts/recaser/truecase.perl -model model/truecase-model.$SRC < data/$prefix.tok.$SRC > data/$prefix.tc.$SRC
  $mosesdecoder/scripts/recaser/truecase.perl -model model/truecase-model.$TRG < data/$prefix.tok.$TRG > data/$prefix.tc.$TRG
 done

# train BPE
cat data/corpus.tc.$SRC data/corpus.tc.$TRG | $subword_nmt/learn_bpe.py -s $bpe_operations > model/$SRC$TRG.bpe

# apply BPE

for prefix in corpus newstest2013
 do
  $subword_nmt/apply_bpe.py -c model/$SRC$TRG.bpe < data/$prefix.tc.$SRC > data/$prefix.bpe.$SRC
  $subword_nmt/apply_bpe.py -c model/$SRC$TRG.bpe < data/$prefix.tc.$TRG > data/$prefix.bpe.$TRG
 done

# build factored input

for prefix in corpus newstest2013
 do
  ../preprocess/conll_to_factors.py data/$prefix.bpe.$SRC data/$prefix.conll.$SRC > data/$prefix.factors.$SRC
 done
 
# build network dictionary
$nematus/data/build_dictionary.py data/corpus.bpe.$SRC data/corpus.bpe.$TRG

# build dictionary for additional factors
for i in {1..4}
 do
  $mosesdecoder/scripts/training/reduce-factors.perl --corpus data/corpus.factors.$SRC --reduced-corpus data/corpus.factors.$i.$SRC --factor $i
  $nematus/data/build_dictionary.py data/corpus.factors.$i.$SRC
 done
