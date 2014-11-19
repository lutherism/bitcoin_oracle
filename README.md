bitcoin_oracle
==============
A Neural Net predictor written in Octave.

The weights folder contains weights for a 10 in, 1 out network, with 2 25 unit hidden layers. It has been trained on daily bitcoin prices since 2010 (source:http://www.coindesk.com/), and alternately relative stock prices for certain high profile tech stocks in the same time period, in order to geuss if the price will be up the following day.

In my testing, I've been getting a 45%-64% correct prediciton rate on unseen trail data sets. This is a hard problem, and I'm interested to see other people work on nets of their own with tweaks to my lambda and cost function or data set.


- To use:

 cd to ./scripts folder in octave

 run 'training' to train a nueral net on data found in './data/bitcoin.csv'

  run 'plotNerons' to see bottom layer nuerons

  run 'runSim(X, y)' on a Matrix of price history features X, with tradeProfit vector y

  run 'predict(X)' on a vector of the previous 10 daily bitcoin price changes by ratio on vector X (in the form of nth_element = ((nth_day_previous_price/0_day_price) - 1) to get back the oracle's geuss for tomorrow's price.
