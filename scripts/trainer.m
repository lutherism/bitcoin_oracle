% terminal script for running training


clear ; close all; clc

%% Setup the parameters you will use for this exercise
input_layer_size  = 10;  % 20x20 Input Images of Digits
hidden_layer_size = 10;   % 25 hidden units
num_labels = 1;          % 10 labels, from 1 to 10   

companies = {'ge';'msft';'yhoo';'googl';'amzn';'vrsn';'tsla';'rsh'};

dataSetr = [0 zeros(1, input_layer_size)];

for i=1:size(companies,1)
	dataSetr = [dataSetr;csvread(['../data/' companies{i} '_stock.csv'])];
end

dataSet = dataSetr(randperm(size(dataSetr,1)),:);

X = dataSet(1:end-500, 2:11);
y = dataSet(1:end-500, 1);

Xt = dataSet(end-499:end, 2:11);
yt = dataSet(end-499:end, 1);

m = size(X, 1)


initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, hidden_layer_size);
initial_Theta3 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:); initial_Theta3(:)];


load '../weights/octave/06/L1.mat' Theta1;
load '../weights/octave/06/L2.mat' Theta2;
load '../weights/octave/06/L3.mat' Theta3;

fprintf('\nTraining Neural Network... \n')

for i=1:15
initial_nn_params = [Theta1(:); Theta2(:); Theta3(:)];

size(initial_nn_params)
%  After you have completed the assignment, change the MaxIter to a larger
%  value to see how more training helps.
options = optimset('MaxIter', 5);

%  You should also try different values of lambda
lambda = .1;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);
for i=1:150
% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1:hidden_layer_size^2 + hidden_layer_size) + (hidden_layer_size * (input_layer_size + 1))), ...
                 hidden_layer_size, (hidden_layer_size + 1));

Theta3 = reshape(nn_params((1:hidden_layer_size * num_labels + num_labels) + ((hidden_layer_size * (input_layer_size + 1)) + (hidden_layer_size^2 + hidden_layer_size))), ...
                 num_labels, (hidden_layer_size + 1));

save '../weights/octave/06/L1.mat' Theta1;
save '../weights/octave/06/L2.mat' Theta2;
save '../weights/octave/06/L3.mat' Theta3;
initial_nn_params = nn_params;
fprintf('test set\n');
nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, Xt, yt, lambda);
plotNerons;
end
fprintf('Program paused. Press enter to continue.\n');
pause;
end
