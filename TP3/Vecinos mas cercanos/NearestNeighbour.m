function [p]=NearestNeighbour(X,knn,xleftlimit,xrightlimit,step)
[l,N] = size(X);
k = 1;
x = xleftlimit;
while x < xrightlimit + step/2
    distance = [];
    for i = 1:N
        xi = X(:,i);
        distance(i) = abs(x-xi);
    end
    distance = sort(distance, 'ascend');
    ro = distance(knn);
    V = 2 * ro;
    p(k) = knn / (N * V);
    k = k + 1;
    x = x + step;
end
