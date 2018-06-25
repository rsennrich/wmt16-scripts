This directory contains some sample files and configuration scripts for training a neural MT model with multiple input featues.
It documents the method described in:

Rico Sennrich, Barry Haddow, (2016):
    Linguistic Input Features Improve Neural Machine Translation. Proceedings of WMT16.


INSTRUCTIONS
------------

all scripts contain variables that you will need to set to run the scripts.
For processing the sample data, only paths to different toolkits need to be set.
For processing new data, more changes will be necessary.

As a first step, preprocess the training data:

  ./preprocess.sh

It is assumed that you have the source text in the CONLL format, with a plain text target side.
The preprocessed files we used for our WMT 2016 experiments can be found here: http://data.statmt.org/rsennrich/wmt16_factors/ (note: since the target side is already tokenized, you can delete the tokenization section in `preprocess.sh` if you use these files)

Then, start training: on normal-size data sets, this will take about 1-2 weeks to converge.
Models are saved regularly, and you may want to interrupt this process without waiting for it to finish.

  ./train.sh

Given a model, preprocessed text can be translated thusly:

  ./translate.sh

Finally, you may want to post-process the translation output, namely merge BPE segments,
detruecase and detokenize:

  ./postprocess-test.sh < data/newstest2013.output > data/newstest2013.postprocessed


INSTRUCTIONS FOR LINGUISTIC ANNOTATION
--------------------------------------

If you want to work with raw text, here are the commands we used for creating the CONLL-formatted text.
All commands were run after tokenization (with the Moses tokenizer), and after running the Moses script `scripts/tokenizer/deescape-special-chars.perl` to undo the escaping of special characters:

For English:

Download Stanford CoreNLP, then run:

  preprocess/stanford-conll-wrapper.py --corenlp /path/to/stanford-corenlp-3.5.0.jar --corenlp-models /path/to/stanford-corenlp-3.5.0-models.jar < input_file > output_file

3.5.0 is the version used in the published experiments. Newer versions of CoreNLP also support CoNLL output directly, although the number of columns is smaller, and conll_to_factors.py needs to be adjusted:

  java -cp /path/to/stanford-corenlp-3.9.1.jar:/path/to/stanford-corenlp-3.9.1-models.jar edu.stanford.nlp.pipeline.StanfordCoreNLP -annotators "tokenize, ssplit, pos, depparse, lemma" -ssplit.eolonly true -tokenize.whitespace true -outputFormat conll < input_file > output_file 2> /dev/null

For German:

Download ParZu and execute `install.sh`: https://github.com/rsennrich/ParZu

to parse tokenized, one-line-per-sentence German text, run:

  ParZu/parzu --input tokenized_lines -p 8 < input_file > output_file