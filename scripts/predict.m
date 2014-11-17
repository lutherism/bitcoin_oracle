function [value] = predict(in)

load '../weights/octave/06/L1.mat' Theta1;
load '../weights/octave/06/L2.mat' Theta2;
load '../weights/octave/06/L3.mat' Theta3;
	plotNerons;
	plotNeron(5,6,26,in);
	z2 = Theta1 * [1;in'];
	a2 = sigmoid(z2)
	plotNeron(5,6,27,a2);
	z3 = Theta2 * [1;a2];
	a3 = sigmoid(z3)
	plotNeron(5,6,28,a3);
	z4 = Theta3 * [1;a3];
	a4 = sigmoid(z4)
	if (a4(1) > .565)
		fprintf('The price will go up tomorrow');
	endif
	if (a4(1) < .434)
		fprintf('The price will go down tomorrow');
	endif
	fprintf('\nI am this sure:\n');
	a4(1) * 100
	fprintf('% chance to increase\n');
	(1- a4(1)) * 100
	fprintf('% chance to increase');
end
