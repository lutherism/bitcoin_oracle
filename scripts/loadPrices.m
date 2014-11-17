function [X, y, raw, vals, r, thresh] = loadPrices(file)
	raw = csvread(['../data/' file]);
	X = raw(:, 2:end);
	y = raw(:, 1);
	m = size(X,1);

	r = ones(m+1,1);
	r(1,1) = 1000;
	for i=1:m
		r(i+1) = ((y(i)/5)+1)*r(i);
	end
	thresh = @(p) dailyRun(X, y, p, 1000);
	vals = arrayfun(thresh,([505:560].*.001));
end
