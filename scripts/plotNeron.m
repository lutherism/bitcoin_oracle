function [neron] = plotNeron(x, y, z, neron) 
		subplot(x, y, z);
		plot(fliplr(neron));
end
		
