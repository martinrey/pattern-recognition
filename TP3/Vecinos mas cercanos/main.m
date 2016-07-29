mu = 0;
sigma = 1;
n = 1000;
step = 0.1;
knn = 50
[X] = mvnrnd(mu, sigma, n)';

x=-3:step:3;
plot(x,normpdf(x,mu,sigma),'Color',[0 0 0]);
hold;

pdf_parzen=NearestNeighbour(X, knn, -3, 3, step);
plot(x,pdf_parzen,'r');