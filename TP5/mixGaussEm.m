function [label, model] = mixGaussEm(X, init)
%% init
fprintf('EM for Gaussian mixture: running ... \n');
tol = 1e-6;
maxiter = 500;
R = initialization(X,init);
for iter = 2:maxiter
    [~,label(1,:)] = max(R,[],2);
    R = R(:,unique(label));   % remove empty clusters
    model = maximization(X,R);
    R = expectation(X,model);
end

function R = initialization(X, init)
n = size(X,2);
if isstruct(init)  % init with a model
    R  = expectation(X,init);
elseif numel(init) == 1  % random init k
    k = init;
    label = ceil(k*rand(1,n));
    R = full(sparse(1:n,label,1,n,k,n));
elseif all(size(init)==[1,n])  % init with labels
    label = init;
    k = max(label);
    R = full(sparse(1:n,label,1,n,k,n));
else
    error('ERROR: init is not valid.');
end

function R = expectation(X, model)
mu = model.mu;
Sigma = model.Sigma;
w = model.w;

n = size(X,2);
k = size(mu,2);
R = zeros(n,k);
suma = 0;

for j = 1:n
    for i = 1:k
        R(j, i) = w(i)*mvnpdf(X(:, j), mu(:, i), Sigma(:, :, i));
    end
end
for j = 1:n
   suma = sum(R, 2);
   for i = 1:k
       R(j, i) = R(j, i)/suma(j);
   end
end

function model = maximization(X, R)
[d,n] = size(X);
k = size(R,2);
nk = sum(R,1);
w = nk/n;
mu = bsxfun(@times, X*R, 1./nk);

Sigma = zeros(d,d,k);
r = sqrt(R);
for i = 1:k
    Xo = bsxfun(@minus,X,mu(:,i));
    Xo = bsxfun(@times,Xo,r(:,i)');
    Sigma(:,:,i) = Xo*Xo'/nk(i);
end

model.mu = mu;
model.Sigma = Sigma;
model.w = w;
