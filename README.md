bitcoin_oracle
==============
A Neural Net predictor written in Octave.

The weights folder contains weights for a 50 in, 2 out network, with 2 25 unit hidden layers. It has been trained on daily bitcoin prices since 2010 (source:http://www.coindesk.com/) in order to geuss if the price will be up the following day.

In my testing, I've been getting a 65%-75% correct prediciton rate.


- To use:

 cd to ./scripts folder in octave

 run 'training' to train a nueral net on data found in './data/bitcoin.csv'

  run 'plotNerons' to see bottom layer nuerons

  run 'runSim(X, y)' on a Matrix of price history features X, with tradeProfit vector y

  run 'predict(X)' on a vector of the previous 60 daily bitcoin prices X to get back the oracle's geuss for tomorrow's price.
