Scripts for Edinburgh Neural MT systems for WMT 16
==================================================

This repository contains scripts and an example config used for the Edinburgh Neural MT submission (UEDIN-NMT)
for the shared translation task at the 2016 Workshops on Statistical Machine Translation (http://www.statmt.org/wmt16/).

The scripts will facilitate the reproduction of our results, and serve as additional documentation (along with the system description paper)


OVERVIEW
--------

- We built translation models with Nematus ( https://www.github.com/rsennrich/nematus )
- We used BPE as subword segmentation to achieve open-vocabulary translation ( https://github.com/rsennrich/subword-nmt )
- We automatically back-translated in-domain monolingual data into the source language to create additional training data. The data is publicly available here: http://statmt.org/rsennrich/wmt16_backtranslations/
- More details about our system will appear in the (upcoming) system description paper

SCRIPTS
-------

- preprocessing : preprocessing scripts for Romanian that we found helpful for translation quality.
                  we used the Moses tokenizer and truecaser for all language pairs.

- sample : sample scripts that we used for preprocessing, training and decoding. We used mostly the same settings for all translation directions,
           with small differences in vocabulary size. Dropout was enabled for EN<->RO, but disabled otherwise.


- r2l : scripts for reranking the output of the (default) left-to-right decoder with a model that decodes from right-to-left.


LICENSE
-------

The scripts are available under the MIT License.

PUBLICATIONS
------------

The Edinburgh Neural MT submission to WMT 2016 is described in:

 TBD

It is based on work described in the following publications:

Dzmitry Bahdanau, Kyunghyun Cho, Yoshua Bengio (2015):
    Neural Machine Translation by Jointly Learning to Align and Translate, Proceedings of the International Conference on Learning Representations (ICLR).

Rico Sennrich, Barry Haddow, Alexandra Birch (2015):
    Neural Machine Translation of Rare Words with Subword Units. arXiv preprint.

Rico Sennrich, Barry Haddow, Alexandra Birch (2015):
    Improving Neural Machine Translation Models with Monolingual Data. arXiv preprint.