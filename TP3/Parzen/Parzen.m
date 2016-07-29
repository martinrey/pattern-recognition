function [p]=Parzen(X,h,step,xleftlimit,xrightlimit)
[l, N] = size(X);
k = 1;
x = xleftlimit;
while x < xrightlimit + step/2
    p(k) = 0;
    for i = 1:N
        xi = X(:,i);
        p(k) = p(k) + 1/h * phi((x - xi)/h);
    end
    k=k+1;
    x=x+step;
end
p = p./N;

function p = phi(val)
p = (abs(val) <= 0.5);