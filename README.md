Scripts for Edinburgh Neural MT systems for WMT 16
==================================================

This repository contains scripts and an example config used for the Edinburgh Neural MT submission (UEDIN-NMT)
for the shared translation task at the 2016 Workshops on Statistical Machine Translation (http://www.statmt.org/wmt16/),
and for the paper "Linguistic Input Features Improve Neural Machine Translation".

The scripts will facilitate the reproduction of our results, and serve as additional documentation (along with the system description paper)

NOTE: for newer instructions (from WMT 17), see http://data.statmt.org/wmt17_systems/training/

OVERVIEW
--------

- We built translation models with Nematus ( https://www.github.com/rsennrich/nematus )
- We used BPE as subword segmentation to achieve open-vocabulary translation ( https://github.com/rsennrich/subword-nmt )
- We automatically back-translated in-domain monolingual data into the source language to create additional training data.
- More details about our system are available in the system description paper (see below for reference)

MODELS and DATA
---------------

- pre-trained models on WMT data are released at http://statmt.org/rsennrich/wmt16_systems/
  they currently correspond to the best single model for 8 translation directions: EN<->{CS,DE,RO,RU}

- automatically back-translated monolingual data, which we used for our WMT submissions, is available at http://statmt.org/rsennrich/wmt16_backtranslations/

- linguistically annotated corpora which we used for our factored models are available at http://data.statmt.org/rsennrich/wmt16_factors/

SCRIPTS
-------

- preprocessing : preprocessing scripts for Romanian that we found helpful for translation quality.
                  we used the Moses tokenizer and truecaser for all language pairs.

- sample : sample scripts that we used for preprocessing, training and decoding. We used mostly the same settings for all translation directions,
           with small differences in vocabulary size. Dropout was enabled for EN<->RO, but disabled otherwise.

- factored_sample: sample scripts for preprocessing and training with linguistic input features. This was not used in shared task submissions,
                   but in (Sennrich and Haddow, 2016).

- r2l : scripts for reranking the output of the (default) left-to-right decoder with a model that decodes from right-to-left.


EVALUATION
----------

WMT reports case-sensitive BLEU on detokenized text with the NIST BLEU scorer.
Assuming that you have detokenized your output (see `sample/postprocess-test.sh`) in the file `output.detok`, here is how we score a system (on the example of EN-DE):

```
  /path/to/mosesdecoder/scripts/ems/support/wrap-xml.perl de newstest2016-ende-src.en.sgm < output.detok > tmpfile
  /path/to/mosesdecoder/scripts/generic/mteval-v13a.pl -c -s newstest2016-ende-src.en.sgm -r newstest2016-ende-ref.de.sgm -t tmpfile
```

alternatively, you can use `multi-bleu-detok.perl`, which accepts detokenized output in plain text, and gives the same result as the NIST Bleu scorer:

```
  /path/to/nematus/data/strip_sgml.py < newstest2016-ende-ref.de.sgm > newstest2016-ende-ref.de.txt
  /path/to/nematus/data/multi-bleu-detok.perl newstest2016-ende-ref.de.txt < output.detok
```

Note that `multi-bleu.perl` (or `multi-bleu-detok.perl`) on tokenized text will give different scores (usually higher), because of tokenization differences.
Also, comparing different systems with tokenized BLEU is unreliable unless tokenization is identical.
Even when using standard Moses tokenization, command line options like '-penn' and '-a' will cause inconsistencies.


LICENSE
-------

The scripts are available under the MIT License.

PUBLICATIONS
------------

The Edinburgh Neural MT submission to WMT 2016 is described in:

Rico Sennrich, Barry Haddow, Alexandra Birch (2016):
    Edinburgh Neural Machine Translation Systems for WMT 16, Proc. of the First Conference on Machine Translation (WMT16). Berlin, Germany

It is based on work described in the following publications:

Dzmitry Bahdanau, Kyunghyun Cho, Yoshua Bengio (2015):
    Neural Machine Translation by Jointly Learning to Align and Translate, Proceedings of the International Conference on Learning Representations (ICLR).

Rico Sennrich, Barry Haddow, Alexandra Birch (2016):
    Neural Machine Translation of Rare Words with Subword Units. Proceedings of the 54th Annual Meeting of the Association for Computational Linguistics (ACL 2016). Berlin, Germany.

Rico Sennrich, Barry Haddow, Alexandra Birch (2016):
    Improving Neural Machine Translation Models with Monolingual Data. Proceedings of the 54th Annual Meeting of the Association for Computational Linguistics (ACL 2016). Berlin, Germany.

The use of linguistic input features (factored_sample) is described in:

Rico Sennrich, Barry Haddow (2016):
    Linguistic Input Features Improve Neural Machine Translation, Proc. of the First Conference on Machine Translation (WMT16). Berlin, Germany
