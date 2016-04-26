RERANKING WITH RIGHT-TO-LEFT-MODELS (R2L)
-----------------------------------------

For English<->German and English->Czech, we trained separate models with reversed target order, and used those models for reranking.

To use reranking with reversed (right-to-left) models, do the following:

1. use reverse.py to reverse the word order on the target side of the training/dev set.
use the same vocabulary, and apply reverse.py *after* truecasing/BPE, to simplify the mapping from l2r to r2l and back.

2. train a separate model (or ensemble) with the reversed target side. I'll call this the r2l model.

3. at test time, produce an n-best list with the l2r model(s):

  time THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=gpu,on_unused_input=warn python /path/to/nematus/nematus/translate.py -m model.npz -i test.bpe.de -o test.output.50best -k 50 -n -p 1 --n-best

4. reverse the outputs in the n-best list, and re-score with the r2l model(s).

  python reverse_nbest.py < test.output.50best > test.output.50best.reversed

  time THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=gpu,on_unused_input=warn python /path/to/nematus/nematus/rescore.py -m /path/to/r2l_model/model.npz -s test.bpe.de -i test.output.50best.reversed -o test.output.50best.rescored -b 80 -n
  python rerank.py < test.output.50best.rescored | python reverse.py > test.output.reranked
