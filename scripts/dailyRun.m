
function [value, bankVals] = dailyRun(X, y, thresh, bank)
load '../weights/octave/06/L1.mat' Theta1;
load '../weights/octave/06/L2.mat' Theta2;
load '../weights/octave/06/L3.mat' Theta3;
	m = size(X, 1);
badtrades = 0;
trades = 0;
startingTotal = bank;
badtrade = 0;
confidence= 0;
bankVals = zeros(m, 1);
tradeTimes = zeros(m, 1);
invest = 0;
for i=1:m
	z2 = Theta1 * [1;X(i, :)'];
	a2 = sigmoid(z2);
	z3 = Theta2 * [1;a2];
	a3 = sigmoid(z3);
	z4 = Theta3 * [1;a3];
	a4 = sigmoid(z4);
	value = (y(i)/5)+1;
	if (a4(1) > thresh && invest == 0)
		trades+=1;
		bank--;
		if (bank < 20000) 
			invest += bank;
		else
			invest = 10000;
		endif
		bank -= invest;
	elseif (a4(1) < (1-thresh) && invest > 1)
		trades+=1;
		bank--;
		bank += invest;
		invest = 0;
	endif
		lastbank = bank;
		confidence +=a4(1);
		invest *= value;
		bank - lastbank;
		bankVals(i) = bank+invest;
	if (lastbank > bank) 
		badtrade+=a4(1);
		badtrades+=1;
end
end
confidence = confidence / trades
badtrade/badtrades
badtrades
trades
(trades-badtrades) / trades
profit = bank / startingTotal
value = bank+invest;
end

