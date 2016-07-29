function [X, z] = gausseanMixtureGenerator(d, c, n)
w = rand(c, 1)';
z = categoricalDistribution(w,n);
mu0 = zeros(d,1);
mu = zeros(d,c);
Sigma = zeros(d,d,c);
X = zeros(d,n);
sigma_1=1;sigma_2=1;rho=0.4;

for i = 1:c
    idx = z==i;
    Sigma(:,:,i) = [sigma_1*sigma_1   rho*sigma_1*sigma_2;
                    rho*sigma_1*sigma_2 sigma_2*sigma_2];
    mu(:,i) = mvnrnd(mu0,Sigma(:,:,i), 1);
    X(:,idx) = mvnrnd(mu(:,i),Sigma(:,:,i), sum(idx))';
end