#!/bin/sh

# theano device, in case you do not want to compute on gpu, change it to cpu
device=gpu

# path to nematus ( https://www.github.com/rsennrich/nematus )
nematus=/path/to/nematus

THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device,on_unused_input=warn python $nematus/nematus/translate.py \
     -m model/model.npz \
     -i data/newsdev2016.bpe.ro \
     -o data/newsdev2016.output \
     -k 12 -n -p 1
