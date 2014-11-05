function [value] = predict(in)

load '../weights/octave/02/L1.mat' Theta1;
load '../weights/octave/02/L2.mat' Theta2;
load '../weights/octave/02/L3.mat' Theta3;
	plotNerons;
	subplot(5,6,26);
	plot(in);
	z2 = Theta1 * [1;in'];
	a2 = sigmoid(z2)
subplot(5,6,27);
	plot(a2);
	z3 = Theta2 * [1;a2];
	a3 = sigmoid(z3)
subplot(5,6,28);
	plot(a3);
	z4 = Theta3 * [1;a3];
	a4 = sigmoid(z4)
	for i=1:size(a2)
		if a2(i) > .7
			subplot(5, 6, i);
			plot(Theta1(i, :), 'g');
		end
	if (a4(2) > .5)
		fprintf('The price will go up tomorrow');
	endif
	if (a4(1) > .5)
		fprintf('The price will go down tomorrow');
	endif
	fprintf('\nI am this sure:\n');
	a4(1) * 100
	fprintf('% chance to increase\n');
	a4(2) * 100
	fprintf('% chance to increase');
end
