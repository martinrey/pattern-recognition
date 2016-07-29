mu = 0;
sigma = 1;
n = 1000;
step = 0.1;
h = 1;
[X] = mvnrnd(mu, sigma, n)';

x=-3:step:3;
plot(x,normpdf(x,mu,sigma),'Color',[0 0 0]);
hold;

pdf_parzen=Parzen(X, h, step, -3, 3);
plot(x,pdf_parzen,'r');