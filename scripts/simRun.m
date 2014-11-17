function [value] = simRun(X, y)
load '../weights/octave/04/L1.mat' Theta1;
load '../weights/octave/04/L2.mat' Theta2;
load '../weights/octave/04/L3.mat' Theta3;
	bank = 1000;
	m = size(X, 1);
badtrades = 0;
trades = 0;
startingTotal = bank;
badtrade = 0;
confidence= 0;
tradeTimes = zeros(m, 1);
invest = 0;
for i=1:m
	z2 = Theta1 * [1;X(i, :)'];
	a2 = sigmoid(z2);
	z3 = Theta2 * [1;a2];
	a3 = sigmoid(z3);
	z4 = Theta3 * [1;a3];
	a4 = sigmoid(z4);
	value = (y(i)/5)+1
	if (a4(2) > .55 && invest == 0)
		lastbank = bank;
		confidence +=a4(2);
		fprintf('\n');
		if (bank < 20000) 
			invest += bank*.8;
			bank -= invest;
			invest = invest% *.99
		else
			invest = 10000;
				bank -= 10000;
		endif
	elseif (a4(1) > .55 && invest > 0)
		tradeTimes(i) = 1;
		roi = invest %* .99
		bank += roi
		trades+=1;
		invest = 0;
		fprintf('we earned\n');
		bank - lastbank
	fprintf('\n');
	if (lastbank > bank) 
		badtrade+=a4(2);
		fprintf('\nBAD TRADE \n');
		badtrades+=1;
end
	fprintf('\n');
endif
			invest *= value;
end
confidence = confidence / trades
badtrade/badtrades
badtrades
trades
(trades-badtrades) / trades
profit = bank / startingTotal
end

