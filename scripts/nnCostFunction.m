function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1:hidden_layer_size^2 + hidden_layer_size) + (hidden_layer_size * (input_layer_size + 1))), ...
                 hidden_layer_size, (hidden_layer_size + 1));

Theta3 = reshape(nn_params((1:hidden_layer_size * num_labels + num_labels) + ((hidden_layer_size * (input_layer_size + 1)) + (hidden_layer_size^2 + hidden_layer_size))), ...
                 num_labels, (hidden_layer_size + 1));
m = size(X, 1);
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
Theta3_grad = zeros(size(Theta3));


X = [ones(1, m); X'];

nzTheta1 = Theta1(:, [2:end]);
nzTheta2 = Theta2(:, [2:end]);
nzTheta3 = Theta3(:, [2:end]);

L1 = sigmoid(Theta1 * X);
L2 = sigmoid(Theta2 * [ones(1, m); L1]);
L3 = sigmoid(Theta3 * [ones(1, m); L2])';
J = 0;
for k=1:num_labels
	test = y < 0;
	if k == 1 
		test = y > 0;
	end
	J += ((1/m) * sum((log(L3(:, k)) .* (test * -1)) - ((log((L3(:, k) * -1) + 1)) .* (((test) * -1) + 1))));
end
J += ((lambda / (2 * m)) * (sum(sum(nzTheta1.^2)) + sum(sum(nzTheta2.^2)) + sum(sum(nzTheta3.^2))));


for i=1:m
	yx = [y(i) > 0 ;y(i) < 0];
	z2 = Theta1 * X(:, i);
	a2 = sigmoid(z2);
	z3 = Theta2 * [1;a2];
	a3 = sigmoid(z3);
	z4 = Theta3 * [1;a3];
	a4 = sigmoid(z4);
	delta4 = a4 - yx;
	delta3 = (Theta3' * delta4) .* sigmoidGradient([1;z3]);
	delta2 = (Theta2' * delta3(2:end)) .* sigmoidGradient([1;z2]);
	Theta3_grad += [delta4 * [1;a3]'];
	Theta2_grad += [delta3(2:end) * [1;a2]'];
	Theta1_grad += [delta2(2:end) * X(:, i)'];
end
Theta3_grad = Theta3_grad ./ m;
Theta2_grad = Theta2_grad ./ m;
Theta1_grad = Theta1_grad ./ m;
t1_reg = Theta1 .* (lambda / m);
t2_reg = Theta2 .* (lambda / m);
t3_reg = Theta3 .* (lambda /m);
t1_reg(:, 1) = 0;
t2_reg(:, 1) = 0;
t3_reg(:, 1) = 0;
Theta3_grad = Theta3_grad+t3_reg;
Theta2_grad = Theta2_grad+t2_reg;
Theta1_grad = Theta1_grad+t1_reg;


grad = [Theta1_grad(:) ; Theta2_grad(:); Theta3_grad(:)];
J=J(1,1);
end
