function [value] = simRun(X, y)
load '../weights/octave/02/L1.mat' Theta1;
load '../weights/octave/02/L2.mat' Theta2;
load '../weights/octave/02/L3.mat' Theta3;
	bank = 100;
	m = size(X, 1);
badtrades = 0;
trades = 0;
startingTotal = bank;
tradeTimes = zeros(m, 1);
for i=1:m
	z2 = Theta1 * [1;X(i, :)'];
	a2 = sigmoid(z2);
	z3 = Theta2 * [1;a2];
	a3 = sigmoid(z3);
	z4 = Theta3 * [1;a3];
	a4 = sigmoid(z4);
	lastbank = bank;
	if (a4(1) > .5)
		if (bank < 20000) 
			invest = 100;
		else
			invest = 100;
		endif
		bank -= invest;
		tradeTimes(i) = 1;
		bank += invest * (1 + y(i))
		trades+=1;
	else
		fprintf('no deal \n');
	endif
	if (lastbank > bank) 
		fprintf('BAD TRADE \n');
		badtrades+=1;
end
end
badtrades
trades
(trades-badtrades) / trades
profit = bank / startingTotal
end

